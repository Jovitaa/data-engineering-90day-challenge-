-- Day 5 SQL Brain Training

--------------------------------------------------
-- Problem 1
-- Top 5 Countries by Content Count
--------------------------------------------------

SELECT country,
       COUNT(*) AS content_count
FROM netflix
WHERE country IS NOT NULL
GROUP BY country
ORDER BY content_count DESC
LIMIT 5;


--------------------------------------------------
-- Problem 2
-- Running Total of Releases by Year
--------------------------------------------------

SELECT release_year,
       COUNT(*) AS yearly_count,
       SUM(COUNT(*))
       OVER(ORDER BY release_year)
       AS running_total
FROM netflix
GROUP BY release_year
ORDER BY release_year;
