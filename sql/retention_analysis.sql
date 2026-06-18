-- ============================================================
-- RETENTION ANALYSIS
-- Workforce Attrition Analytics Dashboard
-- ============================================================

-- 1. Tenure-based retention analysis using LAG pattern
WITH tenure_buckets AS (
    SELECT
        CASE
            WHEN years_at_company < 1  THEN '< 1 Year'
            WHEN years_at_company < 3  THEN '1-3 Years'
            WHEN years_at_company < 5  THEN '3-5 Years'
            WHEN years_at_company < 10 THEN '5-10 Years'
            ELSE '10+ Years'
        END                                                        AS tenure_band,
        attrition,
        monthly_income,
        job_satisfaction
    FROM hr_analytics
)
SELECT
    tenure_band,
    COUNT(*)                                                       AS employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)            AS attrited,
    ROUND(100.0 * SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_pct,
    ROUND(AVG(monthly_income), 0)                                  AS avg_income,
    ROUND(AVG(job_satisfaction), 2)                                AS avg_satisfaction
FROM tenure_buckets
GROUP BY tenure_band
ORDER BY attrition_pct DESC;

-- 2. Promotion recency effect on retention
SELECT
    CASE
        WHEN years_since_last_promotion = 0 THEN 'Promoted This Year'
        WHEN years_since_last_promotion <= 2 THEN '1-2 Years Ago'
        WHEN years_since_last_promotion <= 5 THEN '3-5 Years Ago'
        ELSE '5+ Years Ago'
    END                                                            AS promotion_recency,
    COUNT(*)                                                       AS employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)            AS attrited,
    ROUND(100.0 * SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_pct,
    ROUND(AVG(monthly_income), 0)                                  AS avg_income
FROM hr_analytics
GROUP BY promotion_recency
ORDER BY attrition_pct DESC;

-- 3. Manager relationship and retention
SELECT
    CASE
        WHEN years_with_curr_manager < 1  THEN '< 1 Year Same Manager'
        WHEN years_with_curr_manager < 3  THEN '1-3 Years Same Manager'
        WHEN years_with_curr_manager < 7  THEN '3-7 Years Same Manager'
        ELSE '7+ Years Same Manager'
    END                                                            AS manager_tenure_band,
    COUNT(*)                                                       AS employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)            AS attrited,
    ROUND(100.0 * SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_pct,
    ROUND(AVG(relationship_satisfaction), 2)                       AS avg_relationship_satisfaction
FROM hr_analytics
GROUP BY manager_tenure_band
ORDER BY attrition_pct DESC;

-- 4. Stock option impact on retention
SELECT
    stock_option_level,
    COUNT(*)                                                       AS employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)            AS attrited,
    ROUND(100.0 * SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_pct,
    ROUND(AVG(monthly_income), 0)                                  AS avg_income,
    DENSE_RANK() OVER (ORDER BY 100.0 * SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END) / COUNT(*) ASC) AS retention_rank
FROM hr_analytics
GROUP BY stock_option_level
ORDER BY attrition_pct;

-- 5. Retention probability score for active employees
WITH scored AS (
    SELECT
        emp_id,
        department,
        job_role,
        monthly_income,
        years_at_company,
        job_satisfaction,
        work_life_balance,
        attrition,
        -- Higher score = better retention probability
        (CASE WHEN years_at_company >= 5        THEN 20 ELSE 0 END) +
        (CASE WHEN monthly_income >= 10000      THEN 20 ELSE 0 END) +
        (CASE WHEN job_satisfaction >= 3        THEN 15 ELSE 0 END) +
        (CASE WHEN over_time = 'No'             THEN 15 ELSE 0 END) +
        (CASE WHEN stock_option_level > 0       THEN 10 ELSE 0 END) +
        (CASE WHEN work_life_balance >= 3       THEN 10 ELSE 0 END) +
        (CASE WHEN marital_status != 'Single'   THEN 10 ELSE 0 END)  AS retention_score
    FROM hr_analytics
    WHERE attrition = 'No'
)
SELECT
    emp_id, department, job_role, monthly_income, years_at_company,
    retention_score,
    NTILE(4) OVER (ORDER BY retention_score DESC)                  AS retention_quartile,
    CASE
        WHEN retention_score >= 80 THEN 'High Retention Probability'
        WHEN retention_score >= 60 THEN 'Moderate Retention'
        WHEN retention_score >= 40 THEN 'At Risk'
        ELSE 'Flight Risk'
    END                                                            AS retention_label
FROM scored
ORDER BY retention_score ASC  -- show most at-risk first
LIMIT 50;
