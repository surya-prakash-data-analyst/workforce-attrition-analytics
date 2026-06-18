-- ============================================================
-- DEPARTMENT ATTRITION ANALYSIS
-- Workforce Attrition Analytics Dashboard
-- ============================================================

-- 1. Department deep-dive with all KPIs
WITH dept_summary AS (
    SELECT
        department,
        job_role,
        COUNT(*)                                                   AS headcount,
        SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)        AS attrited,
        ROUND(AVG(monthly_income), 0)                              AS avg_income,
        ROUND(AVG(job_satisfaction), 2)                            AS avg_satisfaction,
        ROUND(AVG(years_at_company), 1)                            AS avg_tenure
    FROM hr_analytics
    GROUP BY department, job_role
)
SELECT
    department,
    job_role,
    headcount,
    attrited,
    ROUND(100.0 * attrited / headcount, 2)                        AS role_attrition_pct,
    avg_income,
    avg_satisfaction,
    avg_tenure,
    RANK() OVER (PARTITION BY department ORDER BY 100.0 * attrited / headcount DESC) AS rank_in_dept,
    ROUND(100.0 * attrited / headcount, 2) -
        AVG(100.0 * attrited / headcount) OVER (PARTITION BY department) AS vs_dept_avg
FROM dept_summary
ORDER BY department, role_attrition_pct DESC;

-- 2. Department overtime exposure
SELECT
    department,
    SUM(CASE WHEN over_time = 'Yes' THEN 1 ELSE 0 END)            AS ot_employees,
    COUNT(*)                                                       AS total_employees,
    ROUND(100.0 * SUM(CASE WHEN over_time='Yes' THEN 1 ELSE 0 END) / COUNT(*), 1) AS ot_rate_pct,
    SUM(CASE WHEN over_time='Yes' AND attrition='Yes' THEN 1 ELSE 0 END) AS ot_attrited,
    ROUND(100.0 * SUM(CASE WHEN over_time='Yes' AND attrition='Yes' THEN 1 ELSE 0 END) /
          NULLIF(SUM(CASE WHEN over_time='Yes' THEN 1 ELSE 0 END), 0), 1) AS ot_attrition_rate
FROM hr_analytics
GROUP BY department;

-- 3. Department satisfaction vs attrition correlation
SELECT
    department,
    ROUND(AVG(job_satisfaction), 2)                                AS avg_job_satisfaction,
    ROUND(AVG(environment_satisfaction), 2)                        AS avg_env_satisfaction,
    ROUND(AVG(work_life_balance), 2)                               AS avg_wlb,
    ROUND(100.0 * SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_pct,
    DENSE_RANK() OVER (ORDER BY AVG(job_satisfaction) ASC)         AS lowest_satisfaction_rank
FROM hr_analytics
GROUP BY department
ORDER BY avg_job_satisfaction;
