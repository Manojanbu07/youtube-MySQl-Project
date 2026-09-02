create database youtube_project;
use youtube_project;
show tables;
select count(*) from videos_raw;
select * from youtube_project.videos_raw;


-- SUM of all Viewcount, Likecount,Commentcount --
select channel_name,sum(view_count) as total_viewcount,sum(like_count) as total_likecount, sum(comment_count) as total_commmentcount 
from youtube_project.videos_raw
group by channel_name
Order by total_viewcount desc;

-- Sum of total_subscriber --
select channel_name, sum(subscriber_count) as total_subscriber from youtube_project.channel_raw
group by channel_name
order by total_subscriber desc;

select c.channel_name, sum(v.view_count) as total_viewcount, sum(c.subscriber_count) as total_subsCount
 from youtube_project.channel_raw c join youtube_project.videos_raw v 
on c.channel_name=v.channel_name
group by channel_name
order by total_subsCount desc;

-- Calculate the average engagement_rate across all videos.
select round(avg(engagement_rate),2) avg_engRate from youtube_project.videos_raw;

-- 7.Find videos where engagement_rate is above average 
select title, channel_name,like_count,view_count, engagement_rate from videos_raw 
where engagement_rate <
(select avg(engagement_rate) from videos_raw);

-- Extract the top 3 videos by view_count using LIMIT.
select title, sum(view_count)as total_view from videos_raw
group by title 
order by title desc 
limit 3;
select title, max(view_count), channel_name from videos_raw
group by title, channel_name
limit 3;

-- 9.	Count how many videos were published on a Friday.
select count(video_id) total_videos from videos_raw 
where publish_day = 'Friday';
select count(video_id) as total_videos  from videos_raw;

-- 10.	Find the total view_count grouped by publish_month.
select monthname(published_at) as month1, sum(view_count) as total_view_count from videos_raw
group by month1
order by month1 desc;

-- 11.	Which video has the best like-to-view ratio? (likes / views × 100) 
select title, channel_name from videos_raw 
where (like_count * 100.0 / NULLIF(view_count, 0))  >
(select (sum(like_count)/sum(view_count))*100 as like_to_view_ratio from videos_raw);

-- 12.	List videos whose tags contain the word python.
select count(title) from (
select title,channel_name from videos_raw
where title like '%python%') as python_count;
with cte as (
select title,channel_name from videos_raw
where title like '%python%'
)
select count(title) from cte;

-- 13.	Rank videos by view_count using a window function (RANK() or DENSE_RANK()).
select distinct(channel_name),
rank() over (order by view_count )as view_rnk
 from videos_raw;
 select distinct(channel_name),
dense_rank() over (order by view_count )as view_rnk
 from videos_raw
 limit 10;
 
 -- Data cleaning --
 -- Data cleaning function Case Statement like when null there 1 or else 0 and coat with sum or count formula -
 select
    sum(case when video_id is null then '' else 0 end) as video_id_nulls,
    sum(case when title is null then '' else 0 end) as title_nulls,
    sum(case when tags is null then '' else 0 end) as tags_nulls,
    sum(case when category_id is null then 1 else 0 end) as category_nulls
from videos_raw;
-- count(*) function and also group by function with digits 1,2,3 which helps to group by single column with digits and count how
-- many times the event has occured in the same column!!
 show columns from videos_raw;
 select tags, count(*)from videos_raw
 group by 1
 having count(*)>1;
 -- handing null values --
 select sum(case when tags is null then 1 else 0 end ) as total_null_count from videos_raw;
 select count(tags) from videos_raw;
 select count(*) from videos_raw;
 select count(tags) from videos_raw;
 
 -- Diplicate values- 
 SELECT
    COUNT(*) - COUNT(category_id) AS category_id_nulls,
    COUNT(*) - COUNT(channel_name) AS channel_name_nulls,
    COUNT(*) - COUNT(comment_count) AS comment_count_nulls,
    COUNT(*) - COUNT(duration) AS duration_nulls,
    COUNT(*) - COUNT(duration_seconds) AS duration_seconds_nulls,
    COUNT(*) - COUNT(engagement_rate) AS engagement_rate_nulls,
    COUNT(*) - COUNT(fetched_at) AS fetched_at_nulls,
    COUNT(*) - COUNT(like_count) AS like_count_nulls,
    COUNT(*) - COUNT(publish_day) AS publish_day_nulls,
    COUNT(*) - COUNT(publish_month) AS publish_month_nulls,
    COUNT(*) - COUNT(publish_year) AS publish_year_nulls,
    COUNT(*) - COUNT(published_at) AS published_at_nulls,
    COUNT(*) - COUNT(tags) AS tags_nulls,
    COUNT(*) - COUNT(title) AS title_nulls,
    COUNT(*) - COUNT(video_id) AS video_id_nulls,
    COUNT(*) - COUNT(view_count) AS view_count_nulls
FROM videos_raw;

-- only tags column contains the null value !!
select case when tags is null then 'unknown ' else tags end as tag from videos_raw;

select tags,count(*) from videos_raw
group by 1
having count(*)>1;

UPDATE videos_raw
SET tags = 'Unknown'
WHERE tags IS NULL;

SELECT
    *,
    COUNT(*) AS cnt
FROM videos_raw
GROUP BY
    category_id,
    channel_name,
    comment_count,
    duration,
    duration_seconds,
    engagement_rate,
    fetched_at,
    like_count,
    publish_day,
    publish_month,
    publish_year,
    published_at,
    tags,
    title,
    video_id,
    view_count
HAVING COUNT(*) > 1;

-- advanced analtyics 
show tables;
describe videos_raw;
describe channel_raw;

-- Which channels generated the highest total video views?
select v.channel_name, sum(v.view_count) as total_view_count from videos_raw v
join channel_raw c on v.channel_name=c.channel_name 
group by v.channel_name
order by total_view_count desc ;

-- Monthly content trend
select monthname(published_at) as month_1, sum(view_count) from videos_raw
group by month_1
Order by sum(view_count) desc
limit 3;

-- Which channels convert subscribers into views most efficiently?
with view2 as (
select 
sum(c.subscriber_count) as total_subsriber , 
sum(v.view_count) as total_view_count ,  
sum(c.subscriber_count)/sum(v.view_count) as view_effiecntly,
v.channel_name 
from videos_raw v 
join channel_raw c
on v.channel_name=c.channel_name
group by v.channel_name
)
select channel_name from view2
where view_effiecntly  > 1;

select  v.channel_name , sum(v.comment_count) as total_comments,
sum(c.subscriber_count) as total_subs,
sum(c.view_count) as total_view,
rank() over (order by sum(v.comment_count) desc ) as rnk_comment,
rank() over (order by  sum(c.subscriber_count) desc ) as rnk_subs,
rank() over (order by  sum(c.view_count) desc ) as rankbyviewCount
from videos_raw v
join channel_raw c on v.channel_name=c.channel_name 
group by v.channel_name;

-- Growth with yearWise --
WITH yearly_views AS (
    SELECT
        publish_year,
        SUM(view_count) AS total_views
    FROM videos_raw
    GROUP BY publish_year
)
SELECT
    publish_year,
    total_views,
    LAG(total_views) OVER (ORDER BY publish_year) AS previous_year_views,
    total_views -
        LAG(total_views) OVER (ORDER BY publish_year) AS growth
FROM yearly_views;

-- Which channel_name having subscriber higher than the average_subscriber ?
with cte as (
select round(avg(c.subscriber_count),0) as avg_subsriber, v.channel_name  from videos_raw v
join channel_raw c on v.channel_name=c.channel_name
group by 2)
select channel_name from cte 
where avg_subsriber > '3495889';

-- Monthly uploads per channel
select v.channel_name,v.publish_year,v.publish_month, count(video_id) as total_videos from videos_raw v
join channel_raw c on v.channel_name=c.channel_name 
group by 1,2,3;
-- Monthly uploads per channel 
WITH monthly_uploads AS (
    SELECT
        channel_name,
        publish_year,
        publish_month,
        COUNT(video_id) AS uploads
    FROM videos_raw
    GROUP BY
        channel_name,
        publish_year,
        publish_month
)
SELECT
    channel_name,
    round(STDDEV(uploads),1) AS upload_variation
FROM monthly_uploads
GROUP BY channel_name
ORDER BY upload_variation;
	
-- top 10 efficient channels 
WITH view2 AS (
    SELECT
        v.channel_name,
        c.subscriber_count,
        SUM(v.view_count) AS total_views,
        ROUND(
            SUM(v.view_count) * 1.0 / c.subscriber_count,
            2
        ) AS views_per_subscriber
    FROM videos_raw v
    JOIN channel_raw c
        ON v.channel_name = c.channel_name
    GROUP BY
        v.channel_name,
        c.subscriber_count
)
SELECT *
FROM view2
ORDER BY views_per_subscriber DESC
LIMIT 10;

select view_count, count(*) as frequency  from videos_raw
Group by 1
order by frequency desc
limit 1;

select avg(view_count)as avg_view_count, stddev(view_count) as stdvdev from videos_raw;

show tables;
select * from videos_raw v
join channel_raw c on v.channel_name=c.channel_name ;
show tables;

 show columns  from videos_raw;
 show columns from channel_raw;
CREATE TABLE dashboard_combined AS
SELECT 
    v.*,
    c.channel_id,
    c.country,
    c.subscriber_count,
    c.video_count,
    c.uploads_playlist,
    c.view_count      AS channel_total_views,
    c.published_at    AS channel_created_at
FROM videos_raw v
LEFT JOIN channel_raw c ON v.channel_name = c.channel_name;


with cte as (
select tags from youtube_project.dashboard_combined
where tags="Unknown")
select count(tags) from cte;


-- checking userName
select user();
SELECT @@hostname;      -- Server name
SELECT @@port;   
select user, host from mysql.user;
show databases;

-- Step 3: Apply changes
FLUSH PRIVILEGES;
SELECT user, host FROM mysql.user;
SELECT user, host, authentication_string FROM mysql.user;

use youtube_project;
show tables;
show columns from dashboard_combined;
select * from dashboard_combined;


-- 
