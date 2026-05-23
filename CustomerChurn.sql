use CustomerChrunDB

select *
from Customer_Churn;

select*
from Customer_Churn
where age is Null or subscription_type is null

--Total churn by gender 
SELECT 
    gender,
    COUNT(*) AS ChurnedCount
FROM Customer_Churn WITH (NOLOCK)
WHERE churn = 1
GROUP BY gender;
/* Almot both gender are the same*/

-- The most age churned 
WITH RankedAgeChurn AS (
    SELECT 
        age,
        COUNT(*) AS   churn_count,
        ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS HighestRank,
        ROW_NUMBER() OVER (ORDER BY COUNT(*) ASC) AS LowestRank
    FROM Customer_Churn WITH (NOLOCK)
    WHERE churn = 1
    GROUP BY age
)
SELECT 
    age,
    churn_count
FROM RankedAgeChurn
WHERE HighestRank = 1 OR LowestRank = 1
ORDER BY  churn_count DESC;
/* age 19 is the most age churned may be causing be parents regulation and the least one is age 24*/
-- Subscription VS churn
select
    subscription_type,
    count(*) churn
from Customer_Chrun 
where churn = 1 
group by subscription_type
order by churn desc
/*Basic Subscription is the most churned category (This mean the price is not the reason)*/
-- City VS churn
select
    city,
    count(*) churn
from Customer_churn
where churn = 1 
group by city
order by churn desc
-- Customer recency 
SELECT TOP 10 
    Customer_id,
    total_orders,
    last_purchase_days_ago,
    (total_orders*10) - last_purchase_days_ago as loyalty_score
FROM Customer_churn WITH (NOLOCK)
ORDER BY loyalty_score desc