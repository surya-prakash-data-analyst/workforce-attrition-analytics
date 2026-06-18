-- ============================================================
-- ATTRITION ANALYSIS
-- Workforce Attrition Analytics Dashboard
-- ============================================================

-- 1. Overall attrition KPIs
SELECT
    COUNT(*)                                                       AS total_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)            AS total_attrition,
    ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct,
    ROUND(AVG(monthly_income), 0)                                  AS avg_monthly_income,
    ROUND(AVG(years_at_company), 1)                                AS avg_tenure_years,
    ROUND(AVG(age), 1)                                             AS avg_age
FROM hr_analytics;

-- 2. Attrition rate by department
SELECT
    department,
    COUNT(*)                                                       AS total_employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)            AS attrited,
    ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct,
    RANK() OVER (ORDER BY 100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) DESC) AS risk_rank
FROM hr_analytics
GROUP BY department
ORDER BY attrition_rate_pct DESC;

-- 3. Attrition by overtime — highest single behavioral driver
SELECT
    over_time,
    COUNT(*)                                                       AS employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)            AS attrited,
    ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct,
    ROUND(AVG(monthly_income), 0)                                  AS avg_income,
    ROUND(AVG(years_at_company), 1)                                AS avg_tenure
FROM hr_analytics
GROUP BY over_time;

-- 4. Attrition by salary slab using CASE WHEN
SELECT
    CASE
        WHEN monthly_income < 5000  THEN 'Up to $5K'
        WHEN monthly_income < 10000 THEN '$5K-$10K'
        WHEN monthly_income < 15000 THEN '$10K-$15K'
        ELSE '$15K+'
    END                                                            AS salary_band,
    COUNT(*)                                                       AS employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)            AS attrited,
    ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct,
    ROUND(AVG(monthly_income), 0)                                  AS avg_income
FROM hr_analytics
GROUP BY salary_band
ORDER BY attrition_rate_pct DESC;

-- 5. Multi-factor attrition risk — overtime + low salary
SELECT
    over_time,
    CASE WHEN monthly_income < 5000 THEN 'Low Salary' ELSE 'Standard Salary' END AS salary_level,
    COUNT(*)                                                       AS employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)            AS attrited,
    ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct
FROM hr_analytics
GROUP BY over_time, salary_level
ORDER BY attrition_rate_pct DESC;

-- 6. Attrition by business travel frequency
SELECT
    business_travel,
    COUNT(*)                                                       AS employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)            AS attrited,
    ROUND(100.0 * SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_rate_pct,
    ROUND(AVG(distance_from_home), 1)                             AS avg_distance_from_home
FROM hr_analytics
GROUP BY business_travel
ORDER BY attrition_rate_pct DESC;

-- 7. Retained vs attrited employee comparison
SELECT
    attrition,
    ROUND(AVG(monthly_income), 0)                                  AS avg_income,
    ROUND(AVG(years_at_company), 1)                                AS avg_tenure,
    ROUND(AVG(age), 1)                                             AS avg_age,
    ROUND(AVG(job_satisfaction), 2)                                AS avg_job_satisfaction,
    ROUND(AVG(work_life_balance), 2)                               AS avg_work_life_balance,
    ROUND(AVG(distance_from_home), 1)                              AS avg_distance_home
FROM hr_analytics
GROUP BY attrition;
