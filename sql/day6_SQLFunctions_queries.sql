--Buit-in functions
--1. Count Movies vs TV Shows
-- Count total content by type: Movie or TV Show
SELECT 
    show_type,
    COUNT(*) AS total_count
FROM netflix
GROUP BY show_type
ORDER BY total_count DESC;

--2. Top 5 Years with Most Releases
-- Find top 5 release years with highest number of titles
SELECT 
    release_year,
    COUNT(*) AS total_releases
FROM netflix
GROUP BY release_year
ORDER BY total_releases DESC
LIMIT 5;

--3. Rank Content by Release Year
-- Rank all titles based on release year, latest first
SELECT title, release_year,
RANK()OVER(PARTITION BY release_year ORDER BY release_year desc) AS release_rank
FROM netflix;

--4. Running Total of Releases Over Years
-- First count releases per year, then calculate cumulative/running total
SELECT release_year, 
Count(*)
as yearly_releases,
SUM(COUNT(*))OVER(ORDER BY release_year) as running_total
FROM netflix
GROUP BY release_year
ORDER BY release_year;

--5. Find Latest Content per Category
-- Find latest released content for each show type
WITH ranked_content as
(
SELECT title, release_year, show_type,
ROW_NUMBER() OVER(PARTITION BY show_type ORDER BY release_year desc)
AS rn
FRom netflix
)
SELECT title, release_year, show_type
FROM ranked_content
WHERE rn = 1;


--6. Replace NULL Values Using COALESCE
---- Replace missing director, country, and rating values
SELECT 
title,
COALESCE(director, 'Unknown Director') as director,
COALESCE(director, 'Unknown Country') as country,
COALESCE(rating, 'Not rated') as rating
From netflix;

--7. Categorize Content Using CASE
---- Categorize content based on release year
SELECT title,
release_year,
CASE 
WHEN release_year >= 2020 THEN 'New Content'
WHEN release_year BETWEEN 2010 and 2019 THEN 'Moderate Content'
WHEN release_year BETWEEN 2000 and 2009 THEN 'Old Content'
ELSE 'Classic Content'
END as content_category 
FROM netflix;

--8. Extract Year and Month from date_added
-- Extract year and month from date_added column
SELECT 
title, date_added, added_year,
EXTRACT (MONTH FROM date_added) AS month_added
FROM netflix;

--9. Create Scalar UDF for Classification
-- Create a scalar function to classify content by release year
CREATE OR REPLACE FUNCTION classify_content(
release_year_input INT
)
RETURNS TEXT
AS $$
BEGIN 
RETURN 
CASE
WHEN release_year_input >= 2019 THEN 'NEW Content'
WHEN release_year_input BETWEEN 2010 and 2019 THEN 'Moderate Content'
WHEN release_year_input BETWEEN 2000 and 2009 THEN 'Old Content'
ELSE 'Classic Content'
END;
END;
$$ LANGUAGE plpgsql;

SELECT 
    title,
    release_year,
    classify_content(release_year) AS content_category
FROM netflix
order by release_year desc;

--10. Create Table-Valued Function for Reusable Filtering
-- Create a table-valued function to filter content by show_type
CREATE OR REPLACE FUNCTION get_content_by_type(
input_show_type TEXT
)
RETURNS TABLE
(
show_id VARCHAR,
title VARCHAR,
show_type VARCHAR,
release_year INT,
rating VARCHAR
)
AS $$
BEGIN
RETURN QUERY
SELECT 
n.show_id,
n.title,
n.show_type,
n.release_year,
n.rating
FROM netflix n 
WHERE n.show_type = input_show_type;
END; 
$$
LANGUAGE plpgsql;

-- Get all Movies
SELECT * 
FROM get_content_by_type('Movie');

-- Get all TV Shows
SELECT *
FROM get_content_by_type('TV Show');