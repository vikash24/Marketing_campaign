-- Calculate Click through rate(CTR-> percentage of people who clicked at banner (Clicks/ Impressions)), 
-- Conversion 1 (conversion from visitors to leads for this campaign (Leads/Click)), 
-- Conversion 2 (conversion rate from leads to sales (Orders/Leads)), 
-- Average order value(AOV) (Average order value for this campaign (Revenue/Number of Orders)) , 
-- Cost per click (CPC) (how much does it cost us to attract 1 click (on average) (Marketing spending/Clicks)) , 
-- Customer acquisition cost (CAC) (how much does it cost us to attract 1 order (on average)), 
-- ROMI for all records (return on marketing investments, It is calculated ( Total earning - Marketing cost ) / Marketing cost )).

select campaign_id,campaign_name,
100*(clicks/impressions) as click_through_rate,
100*(leads/clicks) as conversion_1,
100*(orders/leads) as conversion_2,
revenue/orders as average_order_value,
mark_spent/clicks as cost_per_clicks,
mark_spent/orders as customer_acquisition_cost,
(revenue- mark_spent)/mark_spent as ROMI
from marketing;

-- Calculate Overall ROMI
select (sum(revenue)-sum(mark_spent))/sum(mark_spent) as Overall_ROMI from marketing;

-- Calculate ROMI for instagram_blogger campaign between 15th Feb to 25th Feb
select campaign_name, (sum(revenue)-sum(mark_spent))/sum(mark_spent) as ROMI 
from marketing 
where campaign_name='instagram_blogger' and
c_date between '2021-02-15' and '2021-02-25';

-- Select the campaign names that never had negative ROMI
select distinct campaign_name 
from marketing
where campaign_name not in (select distinct campaign_name 
from marketing 
where (revenue-mark_spent)/mark_spent<0)

-- Find out the average revenue spent on weekend (Saturday and Sunday)
select avg(revenue) from marketing
where dayname(c_date) in ('Saturday', 'Sunday')

-- Find out the average revenue spent on weekdays(Monday to Friday) with NOT IN
select avg(revenue) from marketing
where dayname(c_date) not in ('Saturday', 'Sunday')

-- Which campaign showed the worst loss in a single day? By loss we mean negative gross profit (revenue - marketing spending). Enter campaign ID.
select campaign_name, campaign_id, revenue - mark_spent as profitloss from marketing order by (revenue - mark_spent)

-- How much total money we spent on Facebook on campaigns with negative ROMI
select sum(mark_spent) 
from marketing
where (revenue - mark_spent)/mark_spent<0 and
locate('facebook', campaign_name)
