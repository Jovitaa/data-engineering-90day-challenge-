--Average release year by content type 
with avg_release as(
 SELECT ROUND(AVG(release_year),0) as avg_releaseyr,
 show_type
 from netflix
 group by show_type
)
select * 
from avg_release;

--multiple CTEs
--count of total movies and total tv shows
with total_movie as(
   SELECT count(*) as movie_count
   from netflix
   where show_type='Movie'
),
total_tvshow as (
   SELECT count(*) as tvshow_count
   from netflix
   where show_type='TV Show'
)
SELECT *
FROM total_movie,total_tvshow;

--subquery
--Find movies released after the average release year.
select title, release_year
from netflix
where release_year >
(
Select avg(release_year)
from netflix
)
order by release_year desc;

--subquery
--find the latest release content
select title, release_year
from netflix
where release_year =
( select MAX(release_year)
from netflix
);

--Find users who rate content higher than their own average.
WITH user_avg AS
(
    SELECT
        user_id,
        ROUND(AVG(rating),0) AS avg_rating
    FROM ratings
    GROUP BY user_id
)

SELECT
    u.user_name,
    n.title,
    r.rating,
    ua.avg_rating
FROM ratings r
JOIN user_avg ua
ON r.user_id = ua.user_id
JOIN users u
ON r.user_id = u.user_id
JOIN netflix n
ON r.show_id = n.show_id
WHERE r.rating > ua.avg_rating;
--"Which movies/shows did each user like more than they usually do?"


--watch_history

--user_id | watch_time
----------|-----------
--1       | 120
--1       | 80
--2       | 60
--2       | 100
--"Average Watch Time Per User" (Interview-Style CTE)
with user_watch_time as(
select user_id, 
avg(watch_time) as avg_watchtime
from watch_history
group by user_id 
)
select *
from user_watch_time;



