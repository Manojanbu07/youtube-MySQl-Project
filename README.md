YouTube Channel & Video Analytics(MY_SQL)
A SQL-based analysis of YouTube channel and video performance data — covering data cleaning, aggregation, and 
advanced analytics using joins, CTEs, and window functions.
Overview

This project analyzes YouTube video and channel-level data across two raw tables (videos_raw, channel_raw) to answer business questions such as which channels perform best, how engagement varies, and which channels convert subscribers into views most efficiently.

Dataset
videos_raw — per-video stats: views, likes, comments, engagement rate, publish date, tags, duration
channel_raw — per-channel stats: subscriber count, total views, video count, country
What this project covers. Dataset from  Google BigQueryApi

Data Cleaning
Identifying and handling NULL values (tags column)
Detecting duplicate rows using GROUP BY + HAVING
Standardizing missing values with UPDATE

Exploratory & Aggregate Analysis
Total views/likes/comments per channel
Average engagement rate, and videos performing above average
Top videos by view count, like-to-view ratio
Uploads by day of week and by month

Advanced Analytics
Ranking channels using RANK() and DENSE_RANK()
Year-over-year view growth using LAG()
Subscriber-to-view efficiency using CTEs
Upload consistency per channel using STDDEV()
A combined dashboard_combined table (joined view + channel data) built for downstream reporting/dashboarding
Key SQL Techniques Used

JOIN · GROUP BY / HAVING · Subqueries · CTE (WITH) · Window Functions (RANK, DENSE_RANK, LAG) · CASE statements · Aggregate functions (SUM, AVG, STDDEV) · NULLIF for safe division

Tools
MySQL

