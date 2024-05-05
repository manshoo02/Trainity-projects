use project3;
#TASK 1 weekly user engagement
select 
extract(year from occured_at) as Year,
extract(week from occured_at) as weekNo,
count(distinct user_id) as User_Engagement
from events
group by 1,2
order by 1,2;




#TASK 2 USER GROWTH ANALYSIS
select 
  year,
  weeknum,
  num_active_user,
  SUM(num_active_user)OVER
  (ORDER BY year_num, week_num 
  ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) 
  AS cum_active_user
from(
select 
  extract(year from a.activated_at) as year_num,
  extract(week from a.activated_at) as week_num,
  count(distinct user_id) as num_active_user
from 
  users a 
WHERE
  state = 'active'
group by year,weeknum
order by year,weeknum
) a;




#TASK 3 WEEKLY RETENTION ANALYSIS
SELECT
distinct user_id,
COUNT(user_id) as total_users,
SUM(CASE WHEN retention_week = 1 Then 1 Else 0 END) as retention
FROM (
SELECT
a.user_id,
a.signup_week,
b.engagement_week,
b.engagement_week - a.signup_week as retention_week
FROM 
(
(SELECT distinct user_id, extract(week from occured_at) as signup_week from events
WHERE event_type = 'signup_flow'
and event_name = 'complete_signup'
and extract(week from occured_at) = 18
)a 
LEFT JOIN
(SELECT distinct user_id, extract(week from occured_at) as engagement_week FROM events
where event_type = 'engagement'
)b 
on a.user_id = b.user_id
)
)d 
group by user_id
order by user_id
;



#TASK 4 WEEKLY ENGAGEMENT PER DEVICE
SELECT 
  extract(year from occured_at) as year,
  extract(week from occured_at) as week_num,
  device,
  COUNT(distinct user_id) as users
FROM 
	events
where event_type = 'engagement'
GROUP by 1,2,3
order by 1,2,3;




#TASK 5 
SELECT
  100.0 * SUM(CASE WHEN action IN ('email_open') THEN 1 ELSE 0 END) / 
  SUM(CASE WHEN action IN ('sent_weekly_digest', 'sent_reengagement_email', 'email_open') THEN 1 ELSE 0 END) 
  AS emails_rate_of_opening,
  100.0 * SUM(CASE WHEN action = 'email_clickthrough' THEN 1 ELSE 0 END) / 
  SUM(CASE WHEN action IN ('sent_weekly_digest', 'sent_reengagement_email', 'email_clickthrough') THEN 1 ELSE 0 END) 
  AS emails_rate_of_opening
FROM email_events;
