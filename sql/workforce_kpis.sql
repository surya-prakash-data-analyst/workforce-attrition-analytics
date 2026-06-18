-- ============================================================
-- WORKFORCE KPIs
-- Workforce Attrition Analytics Dashboard
-- ============================================================

-- 1. Core workforce KPI summary
WITH base AS (
    SELECT
        COUNT(*)                                                   AS total_headcount,
        SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)        AS total_attrited,
        SUM(CASE WHEN attrition = 'No'  THEN 1 ELSE 0 END)        AS total_retained,
        ROUND(AVG(monthly_income), 0)                              AS avg_monthly_income,
        ROUND(AVG(CASE WHEN attrition='Yes' THEN monthly_income END), 0) AS avg_income_attrited,
        ROUND(AVG(CASE WHEN attrition='No'  THEN monthly_income END), 0) AS avg_income_retained,
        ROUND(AVG(years_at_company), 1)                            AS avg_tenure,
        ROUND(AVG(age), 1)                                         AS avg_age
    FROM hr_analytics
)
SELECT
    *,
    ROUND(100.0 * total_attrited / total_headcount, 2)            AS attrition_rate_pct,
    -- Estimated annual replacement cost at 2x monthly salary
    total_attrited * avg_income_attrited * 2                      AS est_annual_replacement_cost
FROM base;

-- 2. Department-level workforce scorecard
SELECT
    department,
    COUNT(*)                                                       AS headcount,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)            AS attrited,
    ROUND(100.0 * SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_pct,
    ROUND(AVG(monthly_income), 0)                                  AS avg_income,
    ROUND(AVG(job_satisfaction), 2)                                AS avg_job_satisfaction,
    ROUND(AVG(work_life_balance), 2)                               AS avg_work_life_balance,
    ROUND(AVG(years_at_company), 1)                                AS avg_tenure,
    -- Replacement cost per department
    SUM(CASE WHEN attrition='Yes' THEN monthly_income * 2 ELSE 0 END) AS dept_replacement_cost,
    RANK() OVER (ORDER BY SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END) / COUNT(*) DESC) AS risk_rank
FROM hr_analytics
GROUP BY department
ORDER BY attrition_pct DESC;

-- 3. Job role KPIs with window function comparison to company average
WITH role_kpis AS (
    SELECT
        job_role,
        COUNT(*)                                                   AS headcount,
        ROUND(100.0 * SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_pct,
        ROUND(AVG(monthly_income), 0)                              AS avg_income,
        ROUND(AVG(job_satisfaction), 2)                            AS avg_satisfaction
    FROM hr_analytics
    GROUP BY job_role
)
SELECT
    job_role,
    headcount,
    attrition_pct,
    avg_income,
    avg_satisfaction,
    ROUND(AVG(attrition_pct) OVER (), 2)                          AS company_avg_attrition,
    ROUND(attrition_pct - AVG(attrition_pct) OVER (), 2)          AS vs_company_avg,
    DENSE_RANK() OVER (ORDER BY attrition_pct DESC)                AS attrition_rank
FROM role_kpis
ORDER BY attrition_pct DESC;

-- 4. Monthly income distribution by department
SELECT
    department,
    ROUND(MIN(monthly_income), 0)                                  AS min_income,
    ROUND(AVG(monthly_income), 0)                                  AS avg_income,
    ROUND(MAX(monthly_income), 0)                                  AS max_income,
    ROUND(AVG(CASE WHEN attrition='Yes' THEN monthly_income END), 0) AS avg_income_left,
    ROUND(AVG(CASE WHEN attrition='No'  THEN monthly_income END), 0) AS avg_income_stayed,
    ROUND(AVG(CASE WHEN attrition='No' THEN monthly_income END) -
          AVG(CASE WHEN attrition='Yes' THEN monthly_income END), 0) AS income_retention_premium
FROM hr_analytics
GROUP BY department
ORDER BY income_retention_premium DESC;

-- 5. Satisfaction scores by attrition status
SELECT
    attrition,
    ROUND(AVG(job_satisfaction), 2)                                AS avg_job_satisfaction,
    ROUND(AVG(environment_satisfaction), 2)                        AS avg_env_satisfaction,
    ROUND(AVG(relationship_satisfaction), 2)                       AS avg_relationship_satisfaction,
    ROUND(AVG(work_life_balance), 2)                               AS avg_work_life_balance,
    ROUND(AVG(job_involvement), 2)                                  AS avg_job_involvement
FROM hr_analytics
GROUP BY attrition;
