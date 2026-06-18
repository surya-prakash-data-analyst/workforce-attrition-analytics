-- ============================================================
-- EMPLOYEE SEGMENTATION
-- Workforce Attrition Analytics Dashboard
-- ============================================================

-- 1. Age group segmentation with attrition rates
SELECT
    CASE
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 45 THEN '36-45'
        WHEN age BETWEEN 46 AND 55 THEN '46-55'
        ELSE '55+'
    END                                                            AS age_group,
    COUNT(*)                                                       AS employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)            AS attrited,
    ROUND(100.0 * SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_pct,
    ROUND(AVG(monthly_income), 0)                                  AS avg_income,
    ROUND(AVG(job_satisfaction), 2)                                AS avg_satisfaction
FROM hr_analytics
GROUP BY age_group
ORDER BY attrition_pct DESC;

-- 2. Risk tier classification using CASE WHEN scoring
WITH risk_scores AS (
    SELECT
        emp_id,
        department,
        job_role,
        monthly_income,
        years_at_company,
        over_time,
        attrition,
        (CASE WHEN over_time = 'Yes'               THEN 30 ELSE 0 END) +
        (CASE WHEN monthly_income < 5000           THEN 25 ELSE 0 END) +
        (CASE WHEN business_travel = 'Travel_Frequently' THEN 20 ELSE 0 END) +
        (CASE WHEN years_at_company < 2            THEN 15 ELSE 0 END) +
        (CASE WHEN marital_status = 'Single'       THEN 10 ELSE 0 END) +
        (CASE WHEN job_satisfaction <= 2           THEN 10 ELSE 0 END) +
        (CASE WHEN age BETWEEN 18 AND 25           THEN 10 ELSE 0 END)  AS risk_score
    FROM hr_analytics
    WHERE attrition = 'No'  -- only active employees
)
SELECT
    emp_id,
    department,
    job_role,
    monthly_income,
    years_at_company,
    risk_score,
    CASE
        WHEN risk_score >= 70 THEN 'Critical Risk'
        WHEN risk_score >= 50 THEN 'High Risk'
        WHEN risk_score >= 30 THEN 'Medium Risk'
        ELSE 'Low Risk'
    END                                                            AS risk_tier,
    DENSE_RANK() OVER (ORDER BY risk_score DESC)                   AS priority_rank
FROM risk_scores
ORDER BY risk_score DESC;

-- 3. Marital status and gender cross-analysis
SELECT
    marital_status,
    gender,
    COUNT(*)                                                       AS employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)            AS attrited,
    ROUND(100.0 * SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_pct,
    ROUND(AVG(monthly_income), 0)                                  AS avg_income
FROM hr_analytics
GROUP BY marital_status, gender
ORDER BY attrition_pct DESC;

-- 4. Education field attrition analysis
SELECT
    education_field,
    COUNT(*)                                                       AS employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)            AS attrited,
    ROUND(100.0 * SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_pct,
    RANK() OVER (ORDER BY 100.0 * SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END) / COUNT(*) DESC) AS risk_rank
FROM hr_analytics
GROUP BY education_field
ORDER BY attrition_pct DESC;

-- 5. High-risk segment profile — critical factors combined
SELECT
    CASE
        WHEN over_time = 'Yes' AND monthly_income < 5000 AND business_travel = 'Travel_Frequently' THEN 'Triple Risk'
        WHEN over_time = 'Yes' AND monthly_income < 5000 THEN 'OT + Low Salary'
        WHEN over_time = 'Yes' AND business_travel = 'Travel_Frequently' THEN 'OT + High Travel'
        WHEN monthly_income < 5000 AND business_travel = 'Travel_Frequently' THEN 'Low Salary + High Travel'
        WHEN over_time = 'Yes' THEN 'OT Only'
        WHEN monthly_income < 5000 THEN 'Low Salary Only'
        ELSE 'Standard'
    END                                                            AS risk_profile,
    COUNT(*)                                                       AS employees,
    SUM(CASE WHEN attrition = 'Yes' THEN 1 ELSE 0 END)            AS attrited,
    ROUND(100.0 * SUM(CASE WHEN attrition='Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS attrition_pct
FROM hr_analytics
GROUP BY risk_profile
ORDER BY attrition_pct DESC;
