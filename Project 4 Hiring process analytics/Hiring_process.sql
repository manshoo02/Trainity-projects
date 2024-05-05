use project3;

#TASK 1 JOBS REVIEWED OVER TIME
select avg(h) as 'avg jobs reviewed per hour',
avg(s) as 'avg jobs reviewed per second'
from (
select ds,
((count(job_id)*3600)/sum(time_spent)) as h,
((count(job_id))/sum(time_spent)) as s
from job_data
where 
month(ds)=11
group by ds)a;


#TASK 2 THROUGHPUT ANALYSIS
SELECT ds as review_date, jobs_reviewed, 
AVG(jobs_reviewed) 
OVER(ORDER BY ds ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS 7_rolling_days_avg
FROM ( SELECT ds, COUNT(job_id) AS jobs_reviewed FROM job_data GROUP BY ds ORDER BY ds ) a;




#task 3 language share analysis
SELECT language AS Languages, ROUND(100*COUNT(*)/total,2) 
AS Percentage, sub.total
FROM job_data
CROSS JOIN (SELECT COUNT(*) AS total FROM job_data) AS sub
GROUP BY language, sub.total;






#TASK 4 DUPLICATE ROWS DETECTION
SELECT actor_id, COUNT(*) AS Dulicates FROM job_data
GROUP BY actor_id HAVING COUNT(*) >1;



