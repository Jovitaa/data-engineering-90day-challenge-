-- 🔹 Query 1: SELECT + WHERE
SELECT title, release_year, rating
FROM netflix
WHERE show_type = 'Movie'          -- only include movies (exclude TV shows)
  AND listed_in LIKE '%Drama%'     -- filter for movies where genre includes Drama
  AND rating = 'PG-13';            -- restrict to PG-13 rated movies

-- Purpose: This query retrieves all PG‑13 drama movies, showing their title, release year, and rating.

-- 🔹 Query 2: GROUP BY + HAVING
SELECT country, COUNT(*) AS total_movies
FROM netflix
WHERE show_type = 'Movie'          -- only include movies
GROUP BY country                   -- group results by country of origin
HAVING COUNT(*) >= 100             -- only keep countries with at least 100 movies
ORDER BY total_movies DESC;        -- sort countries by movie count, highest first

-- Purpose: This query highlights countries with significant representation in the dataset,
-- showing only those that have 100 or more movies, ordered by volume.
