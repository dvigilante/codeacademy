--# of distinct campaigns
SELECT COUNT(DISTINCT utm_campaign)
from page_visits;

--# of distinct sources
SELECT COUNT(DISTINCT utm_source)
from page_visits;

--distinct campaigns and their sources
SELECT DISTINCT utm_campaign, utm_source
from page_visits
ORDER BY utm_source ASC;

--distinct web pages
SELECT DISTINCT page_name
from page_visits;

--first touches per campaign
WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT 
    pv.utm_campaign,
    COUNT(*)
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
GROUP BY 1
ORDER BY 2 DESC;

--last touches per campaign
WITH last_touch AS (
  SELECT user_id,
      MAX(timestamp) as last_touch_at
  FROM page_visits
  GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         pv.page_name
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_campaign,
       COUNT(*)
FROM lt_attr
GROUP BY 1
ORDER BY 2 DESC;

--count of visitors who made a purchase
SELECT page_name, COUNT(DISTINCT user_id)
FROM page_visits
WHERE page_name = '4 - purchase'
GROUP BY 1;

--last touch at purchase with campaign counts
WITH last_touch AS (
  SELECT user_id,
      MAX(timestamp) as last_touch_at
  FROM page_visits
  GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         pv.page_name
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_campaign,
       COUNT(*)
FROM lt_attr
WHERE page_name = '4 - purchase'
GROUP BY 1
ORDER BY 2 DESC;

