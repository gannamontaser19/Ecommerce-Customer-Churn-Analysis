/*******************************************************************************
PROJECT: E-Commerce Customer Churn & Loyalty Analysis
AUTHOR: Ganna Montaser
DATE: May 2026
OBJECTIVE: Identify key behavioral risk factors for churn and rank top customer loyalty.
*******************************************************************************/
-- 0. Environment Setup & Data Quality Check
USE CustomerChrunDB;
GO
-- Checking for critical missing data that might skew insights
SELECT 
    SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS MissingAgeCount,
    SUM(CASE WHEN subscription_type IS NULL THEN 1 ELSE 0 END) AS MissingSubscriptionCount
FROM Customer_Churn WITH (NOLOCK);

-- 1. High-Level Overview: Demographics (Gender Profile)
-- Checking if a specific gender profile is disproportionately leaving
SELECT 
    gender,
    COUNT(*) AS ChurnedCount,
    FORMAT(COUNT(*) * 1.0 / SUM(COUNT(*)) OVER(), 'P2') AS PercentageOfTotalChurn
FROM Customer_Churn WITH (NOLOCK)
WHERE churn = 1
GROUP BY gender;
/* Observation: Churn volume is nearly identical across genders, suggesting product 
   dissatisfaction is universal rather than gender-specific. */


-- 2. Behavioral Extremes: Dynamic Outlier Analysis (Age)
-- Dynamically identifying the absolute highest and lowest risk age brackets
WITH RankedAgeChurn AS (
    SELECT 
        age,
        COUNT(*) AS ChurnedCount,
        ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS HighestRank,
        ROW_NUMBER() OVER (ORDER BY COUNT(*) ASC) AS LowestRank
    FROM Customer_Churn WITH (NOLOCK)
    WHERE churn = 1
    GROUP BY age
)
SELECT 
    age,
    ChurnedCount,
    CASE 
        WHEN HighestRank = 1 THEN 'Highest Churn Risk'
        WHEN LowestRank = 1 THEN 'Lowest Churn Risk'
    END AS RiskProfile
FROM RankedAgeChurn
WHERE HighestRank = 1 OR LowestRank = 1
ORDER BY ChurnedCount DESC;
/* Observation: Peak risk occurs at age 19 (potentially lower purchasing power or external
   dependencies), while retention peaks at age 24. */


-- 3. Product Analytics: Tier Churn Rate (Subscription Type)
-- Translating raw flags into a managerial format with total volume percentages
SELECT 
    subscription_type,
    COUNT(*) AS ChurnedCount,
    FORMAT(COUNT(*) * 1.0 / SUM(COUNT(*)) OVER(), 'P2') AS ShareOfTotalChurn
FROM Customer_Churn WITH (NOLOCK) -- Fixed table typo
WHERE churn = 1 
GROUP BY subscription_type
ORDER BY ChurnedCount DESC;
/* Observation: The Basic tier dominates churn. Since it is the cheapest option, 
   price is likely not the issue; rather, low onboarding engagement or lack of perceived 
   feature value is driving users away. */


-- 4. Geographic Analysis: Market Churn Breakdown
SELECT 
    city,
    COUNT(*) AS ChurnedCount,
    FORMAT(COUNT(*) * 1.0 / SUM(COUNT(*)) OVER(), 'P2') AS ShareOfTotalChurn
FROM Customer_Churn WITH (NOLOCK)
WHERE churn = 1 
GROUP BY city
ORDER BY ChurnedCount DESC;


-- 5. Customer Value Management: VIP Retention Framework
-- Using Recency & Frequency normalization to target high-value accounts at risk
SELECT TOP 10 
    Customer_id,
    total_orders,
    last_purchase_days_ago,
    ((total_orders * 10) - last_purchase_days_ago) AS LoyaltyScore
FROM Customer_Churn WITH (NOLOCK)
ORDER BY LoyaltyScore DESC;