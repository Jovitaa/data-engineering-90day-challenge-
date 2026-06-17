--01. Aggreagte Functions
--1. Count Movies Vs TV shows
SELECT show_type, Count(*) as count_show
FROM netflix
Group by show_type
order by count_show desc;

--2. Top 5 yrs with most releases
Select release_year, COUNT(*) as count_releases
from netflix 
Group by release_year
order by count_releases desc
LIMIT 5;

--3. Avg year of content type 
SELECT round(AVG(release_year),0) as avg_year, show_type
FROM netflix
Group By show_type
order by avg_year;

--02. Window Functions 
--1. Rank Content by Release Year
select title, release_year,
RANK()OVER(PARTITION BY show_type ORDER BY release_year desc) as rank_content
from netflix;

--2. Running Total of Releases
select release_year, count(*) as yearly_releases,
SUM(COUNT(*)) OVER(order by release_year) as running_total
from netflix
GROUP By release_year
order by release_year;

--03. CTE
--1. Latest Content Per Type
wITH latest_content as(
SELECT title, release_year, show_type,
ROW_NUMBER() OVER(partition by show_type order by release_year desc) as rn
FROM netflix)
SELECT * 
from latest_content
WHERE rn=1;

