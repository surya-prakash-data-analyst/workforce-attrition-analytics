# Data Dictionary — HR Analytics Dataset

**File:** `data/HR_Analytics.csv`  
**Records:** 1,480 employees  
**Columns:** 38  
**Target:** `Attrition` (Yes / No)

---

## Column Reference

| Column | Type | Values | Description |
|--------|------|--------|-------------|
| EmpID | String | RM001… | Unique employee identifier |
| Age | Integer | 18–60 | Employee age |
| AgeGroup | Categorical | 18-25, 26-35, 36-45, 46-55, 55+ | Age band (pre-grouped) |
| Attrition | Categorical | Yes, No | **Target variable: did employee leave?** |
| BusinessTravel | Categorical | Non-Travel, Travel_Rarely, Travel_Frequently | Travel frequency |
| DailyRate | Integer | 102–1,499 | Daily pay rate |
| Department | Categorical | Sales, R&D, Human Resources | Department name |
| DistanceFromHome | Integer | 1–29 | Miles from home to office |
| Education | Integer | 1–5 | Education level (1=Below College, 5=Doctor) |
| EducationField | Categorical | Life Sciences, Medical, Marketing… | Field of study |
| EmployeeCount | Integer | 1 | Constant — not used in analysis |
| EmployeeNumber | Integer | 1–2,068 | Sequential employee number |
| EnvironmentSatisfaction | Integer | 1–4 | Satisfaction with work environment |
| Gender | Categorical | Male, Female | Gender |
| HourlyRate | Integer | 30–100 | Hourly pay rate |
| JobInvolvement | Integer | 1–4 | Level of job involvement |
| JobLevel | Integer | 1–5 | Seniority level |
| JobRole | Categorical | 9 roles | Specific job title |
| JobSatisfaction | Integer | 1–4 | Job satisfaction score |
| MaritalStatus | Categorical | Single, Married, Divorced | Marital status |
| MonthlyIncome | Integer | 1,009–19,999 | Monthly gross income ($) |
| SalarySlab | Categorical | Upto 5k, 5k-10k, 10k-15k, 15k+ | Pre-banded salary range |
| MonthlyRate | Integer | 2,094–26,999 | Monthly rate code |
| NumCompaniesWorked | Integer | 0–9 | Prior employers count |
| Over18 | Categorical | Y | Constant — not used |
| OverTime | Categorical | Yes, No | Works overtime regularly |
| PercentSalaryHike | Integer | 11–25 | Last salary increase % |
| PerformanceRating | Integer | 3–4 | Performance rating (3=Excellent, 4=Outstanding) |
| RelationshipSatisfaction | Integer | 1–4 | Satisfaction with work relationships |
| StandardHours | Integer | 80 | Constant — not used |
| StockOptionLevel | Integer | 0–3 | Stock option grant level |
| TotalWorkingYears | Integer | 0–40 | Total career years |
| TrainingTimesLastYear | Integer | 0–6 | Training sessions last year |
| WorkLifeBalance | Integer | 1–4 | Work-life balance score |
| YearsAtCompany | Integer | 0–40 | Years with current employer |
| YearsInCurrentRole | Integer | 0–18 | Years in current role |
| YearsSinceLastPromotion | Integer | 0–15 | Years since last promotion |
| YearsWithCurrManager | Float | 0–17 | Years with current manager |

---

## Satisfaction Scale Reference

All satisfaction scores (1–4):  
`1 = Low / Poor` · `2 = Medium` · `3 = High / Good` · `4 = Very High / Excellent`

---

## Key Summary Statistics

| Metric | Value |
|--------|-------|
| Total records | 1,480 |
| Attrition (Yes) | 238 (16.1%) |
| Retained (No) | 1,242 (83.9%) |
| Avg monthly income | $6,503 |
| Avg income — attrited | $4,813 |
| Avg income — retained | $6,829 |
| Avg tenure | 7.0 years |
| Avg age | 37 years |

---

## Missing Values

No missing values in the dataset. `YearsWithCurrManager` contains floats (0.0 values) — treated as 0 months with current manager.

Columns dropped from analysis: `Over18` (constant Y), `StandardHours` (constant 80), `EmployeeCount` (constant 1).
