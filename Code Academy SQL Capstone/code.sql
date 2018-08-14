--SQL 1 – How many campaigns does CoolTShirts use?

select count (distinct utm_campaign)
	from page_visits;

--SQL 2 – How many sources does CoolTShirts use?

select count (distinct utm_source)
	from page_visits;

--SQL 3 – What is the relationship between Campaign and Source?

select distinct utm_campaign as CAMPAIGN, utm_source as SOURCE
	from page_visits; 

--SQL 4 - What pages are on their website?

select distinct page_name as PAGE
from page_visits; 

--SQL 5 - How many first touches is each campaign responsible for?

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
ft_attr AS (
  SELECT ft.user_id,
         ft.first_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM first_touch ft
  JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
)
SELECT ft_attr.utm_source,
       ft_attr.utm_campaign,
       COUNT(*)
FROM ft_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

--SQL 6 - How many last touches is each campaign responsible for?

WITH last_touch AS (
    SELECT user_id,
        max(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
where page_name = '4 - purchase'
)
SELECT lt_attr.utm_source,
       lt_attr.utm_campaign,
       COUNT(*)
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

--SQL 7 - How many visitors make a purchase?

WITH last_touch AS (
    SELECT user_id,
        max(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
where page_name = '4 - purchase'
)
SELECT lt_attr.utm_source,
       lt_attr.utm_campaign,
       COUNT(*)
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

