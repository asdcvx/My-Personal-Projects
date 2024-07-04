
-- 1. SQL diye DATA ready kora for POWER BI REPORT
-- 2. SQL diye request wise data ready kora





SELECT * FROM web_marketing.dim_campaign;


-- cte er jonno

-- WITH cte1 as(); -- clause or statement

-- OVER() -- clause or statement


-- ## Problem 1: Calculate Total Revenue for Each Campaign
select * from dim_campaign;
select * from fact_marketing;

select b.campaign, sum(a.revenue) as Total_Revenue
from fact_marketing as a
join dim_campaign as b on a.campaign_id = b.campaign_id 
group by b.campaign
order by Total_Revenue desc;


-- using window function

with cte1 as (
SELECT 
	a.Date, a.user_id, a.revenue, b.campaign,
    AVG(a.revenue) OVER (PARTITION BY b.campaign) AS Average_Revenue
FROM 
    fact_marketing AS a
JOIN 
    dim_campaign AS b ON a.campaign_id = b.campaign_id
ORDER BY 
    Average_Revenue DESC)
select *, 
(revenue - average_revenue) as Differentials 
from cte1
having Differentials > 0;



-- rank users from highest to lowest
select Date, user_id, revenue from fact_marketing
order by revenue desc;


SELECT
 Date,
 User_ID,
 Revenue,
 ROW_NUMBER() OVER (PARTITION BY Revenue) AS Revenue_Rank
FROM
 fact_marketing
ORDER BY REVENUE desc;

with cte1 as (
SELECT
 Date,
 User_ID,
 Revenue,
 ROW_NUMBER() OVER (PARTITION BY Revenue) AS Revenue_Rank
FROM
 fact_marketing
ORDER BY REVENUE desc)
-- I want to see the revenue value and the number of times it repeated in my data
select Revenue, MAX(Revenue_Rank) as num_of_times_repeated
from cte1
group by Revenue;



-- I want to see how many times each campaign repeated in my data (fact_marketing)

with cte1 as (
SELECT
 a.Date,
 a.User_ID,
 a.Revenue,
 b.campaign,
 ROW_NUMBER() OVER (PARTITION BY b.campaign) AS campaign_Rank
FROM
 fact_marketing as a
 join dim_campaign as b on a.campaign_id = b.campaign_id
ORDER BY REVENUE desc)
-- I want to see the revenue value and the number of times it repeated in my data
select Campaign, MAX(campaign_Rank) as num_of_times_repeated
from cte1
group by Campaign;


-- I want to calculate running total or cumulative of page views

select * from fact_marketing
order by date;

select Date, page_views,
sum(page_views) over (partition by Date order by Date) as running_total_PV
from fact_marketing
order by Date;

SELECT 
    Date, 
    page_views,
    SUM(page_views) OVER (PARTITION BY cast(Date as Date) ORDER BY Date) AS running_total_PV
FROM 
    fact_marketing
ORDER BY 
    Date;
    
    
    




SELECT Date, Revenue,
 SUM(Revenue) OVER (ORDER BY Date) AS cumulative_revenue
FROM fact_marketing
ORDER BY Date;














SELECT
 Date,
 User_ID,
 Revenue,
 RANK() OVER (ORDER BY Revenue DESC) AS Revenue_Rank
FROM
 fact_marketing;


SELECT
 Date,
 User_ID,
 Revenue,
 DENSE_RANK() OVER (ORDER BY Revenue DESC) AS Revenue_Rank
FROM
 fact_marketing;
 
 
SELECT
 Date,
 User_ID,
 Revenue,
 PERCENT_RANK() OVER (ORDER BY Revenue) AS Revenue_Rank
FROM
 fact_marketing; 








with cte1 as (
SELECT 
	a.Date, a.user_id, a.session_duration, b.device,
    AVG(a.session_duration) OVER (PARTITION BY b.device) AS Average_session_duration
FROM 
    fact_marketing AS a
JOIN 
    dim_device AS b ON a.device_id = b.device_id
ORDER BY 
    Average_session_duration DESC)
select *, 
(session_duration - average_session_duration) as Differentials 
from cte1;




SELECT 
	Date, user_id, revenue,
    AVG(revenue) OVER () AS Average_Revenue
FROM 
    fact_marketing;





with cte1 as (
SELECT 
	Date, user_id, revenue,
    AVG(revenue) OVER () AS Average_Revenue
FROM 
    fact_marketing AS a
ORDER BY 
    Average_Revenue DESC)
select *, 
(revenue - average_revenue) as Differentials 
from cte1
having Differentials > 0;


-- running total example by country and Date
SELECT
 fc.Date,
 fc.country_id,
 dc.Country,
 Conversions,
 SUM(Conversions) OVER (PARTITION BY fc.country_id ORDER BY Date) AS
Cumulative_Conversions
FROM
 fact_marketing fc
JOIN
 dim_country dc ON fc.country_id = dc.country_id;




