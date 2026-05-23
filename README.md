# E-Commerce Customer Churn & Loyalty Analysis

## Project Objective
This project uses T-SQL to analyze customer behavior data for an e-commerce platform. The goal is to isolate key demographic and product-tier drivers behind customer churn and build a dynamic loyalty scoring matrix.

## Key Insights Uncovered
* **Subscription Risk:** Basic Tier subscribers represent the highest share of total churn. This indicates that onboarding engagement, rather than price point, is the primary retention bottleneck.
* **Age Outliers:** Dynamic window ranking identified **Age 19** as the highest churn risk and **Age 24** as the most stable user base.
* **Loyalty Framework:** Implemented a Recency-Frequency calculation to decay loyalty scores based on inactivity, successfully mapping out the platform's top 10 VIP customers.

## Tech Stack & Skills Highlighted
* **Database:** SQL Server (T-SQL)
* **Advanced Concepts:** Window Functions (`ROW_NUMBER() OVER()`), Aggregations with Windowed Denominators (`SUM(COUNT(*)) OVER()`), Data Normalization, Conditional Logic (`CASE` statements).
