# LinkedIn Case Study — Workforce Attrition Analytics Dashboard

*How I analyzed 1,480 employee records to uncover $2.3M in annual attrition costs and a clear path to reducing them.*

---

## The Problem

A company with 1,480 employees was experiencing 16.1% annual attrition — above the industry benchmark for most sectors — without a clear picture of which employees were leaving, why, or what it was costing the business.

HR had the data. It was sitting in a spreadsheet. Nobody had run the analysis.

I built an end-to-end people analytics solution: a Power BI dashboard for HR leadership, a Python EDA layer for deep-dive analysis, and a SQL framework for ongoing KPI monitoring. Here's what the data showed.

---

## The Approach

The dataset covered 38 attributes across 1,480 employees — demographics, job details, satisfaction scores, compensation, tenure, and a binary attrition flag. No missing values. Clean enough to go straight to analysis.

I broke the analysis across eight dimensions: department, job role, overtime status, age group, salary band, marital status, business travel frequency, and education field. The goal was not to find one root cause — attrition rarely has one — but to identify which combinations of factors created the highest-risk profiles.

The Python correlation analysis and the Power BI drill-through capabilities together let me move from "here's the overall rate" to "here are the 47 employees still active who match the exact profile of our most frequent departees."

---

## What the Data Showed

**Overtime is the biggest behavioral flag.** Employees working overtime churn at 30.6% — three times the 10.4% rate for those without overtime. This was the single strongest behavioral predictor in the dataset. It's also the most actionable: you can change an overtime policy. You can't easily change someone's age or commute distance.

**Sales Representatives are in a crisis.** 39.3% of Sales Representatives left during the analysis period. This is not a normal attrition rate — it's a structural problem with how that role is compensated, how often it requires travel, and whether there's a clear path forward. In a revenue-generating function, this rate has direct top-line impact.

**Young employees are not staying.** The 18–25 age group churns at 35.8%. This is partially expected — early career mobility is normal — but the rate suggests the company isn't giving young employees enough reason to commit: mentorship, skills development, visible career paths.

**The salary gap is real.** Employees earning below $5,000/month leave at 21.6%. Those earning above $15,000 leave at 3.8%. Compensation is not the only factor, but in the lowest band — which represents 51% of the workforce — it's a significant one.

**The money number.** At a conservative 2× monthly salary replacement cost, 238 annual departures represent approximately $2.3M in direct replacement costs. More if you factor in productivity loss, team disruption, and knowledge drain.

---

## The Recommendations

I framed five recommendations, each tied directly to a data finding rather than best-practice theory:

1. **Overtime policy reform** — Cap mandatory overtime, compensate it properly, and audit which teams are generating it. This is the single action most likely to move the overall attrition rate.

2. **Sales Representative retention program** — Restructured compensation benchmarked to market, clear promotion criteria, and a travel policy that doesn't burn people out.

3. **Compensation review for sub-$5K employees** — 753 people in this band, 163 departures. Even modest increases in this range, targeted at the highest-risk roles, would have measurable impact.

4. **Early career development program** — Structured mentorship, rotation, and skills investment for the 18–25 cohort. The cost is low. The retention impact, over time, is significant.

5. **Exit interview program** — The current dataset tells us what correlates with attrition. Exit interviews tell us the actual reasons. Both together are far more actionable than either alone.

---

## The Business Case

A 30% reduction in overall attrition — from 16.1% to roughly 11% — saves approximately $690,000 annually after program costs. The programs themselves cost an estimated $930,000/year to run. That's a breakeven in approximately 16 months, with every subsequent year delivering net savings.

The harder-to-quantify benefits — better morale, stronger employer brand, preserved institutional knowledge, more stable customer relationships in Sales — add additional value that doesn't show up in the replacement cost calculation.

---

*Tools: Power BI · Python (Pandas, Seaborn, Matplotlib) · SQL (CTEs, Window Functions, CASE WHEN, RANK) · Excel*  
*Skills: HR Analytics · People Analytics · Employee Attrition · Workforce Segmentation · KPI Reporting · Business Intelligence · Stakeholder Reporting · Data Visualization*
