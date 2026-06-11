--1. Count Content by Country
--Business Requirement
--Analytics team wants to know how many titles exist for a given country.

CREATE or REPLACE procedure CountContentByCountry(
In country_name VARCHAR(100)
)
LANGUAGE plpgsql -- PostgreSQL requires the procedural language to be specified
AS $$
DECLARE
total_titles INT;  -- declaring variable that need to store the result
BEGIN 
SELECT COUNT(*)  -- Counts the number of records matching the condition
INTO total_titles	-- Stores the result in the variable total_titles
FROM netflix
WHERE country ILIKE '%' || country_name || '%'; 
-- ILIKE performs a case-insensitive search
    -- '%' are wildcards and || concatenates strings
    -- Example: country_name='India' becomes '%India%'

RAISE NOTICE 'Total_Titles: %', total_titles; 
-- Displays the value stored in total_titles
END;
$$;
--Concepts Practiced
--Input parameter
--Variable declaration
--SELECT INTO
--RAISE NOTICE

CALL CountContentByCountry('India');


--2. Data Quality Check (Missing Directors)
--Business Requirement
--Data Engineering team wants to monitor missing director values.
CREATE OR REPLACE procedure CheckMissingDirectors() --created stored procedure to check missing value
LANGUAGE plpgsql   -- PostgreSQL requires the procedural language to be specified
AS $$
DECLARE
missing_count INT; -- Variable to store the number of records with missing directors
BEGIN
SELECT COUNT(*)  -- Counts all rows matching the condition
INTO missing_count
FROM netflix
WHERE director IS NULL; -- Filters records where director value is NULL

RAISE NOTICE 'Missing Directors: %', missing_count; -- Displays the count stored in missing_count
END;
$$;

CALL CheckMissingDirectors(); -- Executes the stored procedure

-- Business Requirement:
-- Monitor missing values across multiple important columns
-- to identify potential data quality issues.
CREATE OR REPLACE PROCEDURE DataQualityCheck() -- Creates (or replaces) a stored procedure named DataQualityCheck
LANGUAGE plpgsql -- Creates (or replaces) a stored procedure named DataQualityCheck
AS $$
DECLARE
    missing_director INT; -- Stores count of records with missing directors
    missing_country INT;  -- Stores count of records with missing countries
    missing_rating INT;    -- Stores count of records with missing ratings
BEGIN

    SELECT COUNT(*)         
    INTO missing_director      -- Stores count result in missing_director variable
    FROM netflix
    WHERE director IS NULL;     -- Counts records where director is missing

    SELECT COUNT(*)
    INTO missing_country    -- Stores count result in missing_country variable
    FROM netflix
    WHERE country IS NULL;     -- Counts records where country is missing

    SELECT COUNT(*)            -- Stores count result in missing_rating variable
    INTO missing_rating
    FROM netflix
    WHERE rating IS NULL;      -- Counts records where rating is missing

    RAISE NOTICE 'Missing Directors: %', missing_director;   -- Prints count of missing directors
    RAISE NOTICE 'Missing Countries: %', missing_country;    -- Prints count of missing countries
    RAISE NOTICE 'Missing Ratings: %', missing_rating;        -- Prints count of missing ratings

END;
$$;

CALL DataQualityCheck(); -- Executes the stored procedure and displays all data quality metrics
--Concepts Practiced
--Data quality validation
--Monitoring datasets
--Aggregate calculations


--3. Validate User Input
--Business Requirement
--Country name must not be empty.
CREATE OR REPLACE PROCEDURE ValidateCountry(
IN country_name VARCHAR (100)
)
-- Creates (or replaces) a stored procedure that accepts
-- a country name as an input parameter
LANGUAGE plpgsql 
-- Specifies that the procedure uses PostgreSQL's procedural language
AS $$ 
BEGIN
if country_name IS NULL THEN
 -- Checks whether the input parameter is NULL
RAISE Exception 'Country name cannot be NULL';
-- Stops execution and throws an error message
END IF;
 -- End of IF block
RAISE NOTICE 'Valid Country: %', country_name;
 -- Displays the country name if validation passes
END;
$$;

CALL ValidateCountry(NULL);
-- Executes the procedure with a NULL value
-- Expected Output:
-- ERROR: Country name cannot be NULL
--Concepts Practiced
--IF statements
--Error handling
--Input validation

--4. Genre Popularity Analysis
--Business Requirement
--Product team wants to know how many titles belong to a genre.
CREATE OR REPLACE PROCEDURE GenrePopularity(
    IN genre_name VARCHAR
)
-- Creates (or replaces) a stored procedure that accepts
-- a genre name as an input parameter

LANGUAGE plpgsql
-- Specifies that the procedure uses PostgreSQL's procedural language

AS $$

DECLARE

    total_titles INT;
    -- Variable to store the number of titles belonging to the genre

BEGIN

    SELECT COUNT(*)
    -- Counts the number of records matching the genre

    INTO total_titles
    -- Stores the count result into the variable total_titles

    FROM netflix

    WHERE listed_in ILIKE '%' || genre_name || '%';
    -- Performs a case-insensitive search for the genre
    -- '%' are wildcards that match any sequence of characters
    -- '||' concatenates strings
    -- Example:
    -- genre_name = 'Drama'
    -- Search pattern becomes '%Drama%'
    -- This matches:
    -- 'Dramas'
    -- 'International TV Shows, Dramas'
    -- 'Comedies, Dramas'

    RAISE NOTICE 'Total Titles in % : %',
                 genre_name,
                 total_titles;
    -- Displays the genre name and total count

END;

$$;

CALL GenrePopularity('Drama');
-- Executes the procedure for the Drama genre
--Concepts Practiced
--Parameters
--String matching
--Business analytics logic

--5. ETL Audit Logging
--This is the most Data Engineering-oriented example.
--Create Audit Table
CREATE TABLE audit_log (

    log_id SERIAL PRIMARY KEY,
    -- Auto-incrementing unique identifier for each audit record

    load_time TIMESTAMP,
    -- Stores the date and time when the load occurred

    records_loaded INT
    -- Stores the number of records loaded during the pipeline run

);



CREATE OR REPLACE PROCEDURE LogDataLoad(

    IN record_count INT
    -- Input parameter representing the number of records loaded

)

LANGUAGE plpgsql
-- Specifies that the procedure uses PostgreSQL's procedural language

AS $$

BEGIN

    INSERT INTO audit_log(

        load_time,
        -- Column that stores the load timestamp

        records_loaded
        -- Column that stores the number of loaded records

    )

    VALUES(

        CURRENT_TIMESTAMP,
        -- Captures the current system timestamp

        record_count
        -- Inserts the value passed into the procedure

    );

END;

$$;



CALL LogDataLoad(8807);
-- Executes the procedure
-- Indicates that 8,807 records were loaded successfully



SELECT *
FROM audit_log;
-- Displays all audit records stored in the audit_log table

--Concepts Practiced
--INSERT statements
--Audit logging
--ETL tracking
--Production-style data engineering