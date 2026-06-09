--Rank new movie
SELECT title, show_type, release_year,
Row_number()OVER(PARTITION BY show_type 
ORDER BY release_year desc) as row_num
FROM netflix
WHERE show_type = 'Movie';
--Every movie gets a unique number.

--RANK()
SELECT
    title,
    release_year,
    RANK() OVER(
        ORDER BY release_year DESC
    ) AS movie_rank
FROM netflix
WHERE show_type = 'Movie';

--DENSE_RANK()
SELECT
    title,
    release_year,
    DENSE_RANK() OVER(
        ORDER BY release_year DESC
    ) AS dense_rank
FROM netflix
WHERE show_type = 'Movie';


SELECT
    title,
    show_type,
    release_year,
    ROUND(
        -- 1. Get the percent rank
        (PERCENT_RANK() OVER(
            PARTITION BY show_type
            ORDER BY release_year DESC
        ))::numeric, -- 2. Convert it to numeric to satisfy PostgreSQL
        2            -- 3. Specify decimal places (switched to 2 so you don't get just 0 or 1)
    ) AS release_rank
FROM netflix;