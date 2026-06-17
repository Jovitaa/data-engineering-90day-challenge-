-- Create a view named 'movie_view'
--"Create a view that displays only movies from the Netflix dataset."
-- A view is a virtual table based on the result of a query
CREATE VIEW movie_view AS 
SELECT 
title, -- Select the title of the content
    show_type,      -- Select the type (Movie or TV Show)
    release_year    -- Select the release year of the content
FROM netflix        -- Source table: netflix dataset
WHERE show_type = 'Movie';  -- Filter condition: only include rows where type is 'Movie'

--2. Multi-Table View
--"Create a view showing which user rated which Netflix title."
-- Create a view named 'user_ratings_view'
-- This view combines data from three tables: users, ratings, and netflix
CREATE VIEW user_ratings_view AS
SELECT 
u.user_name,   -- Select the user's name from the users table
n.title,       -- Select the title of the Netflix content
r.rating       -- Select the rating given by the user
from users u
-- Join ratings table to link each user with their ratings
JOIN ratings r ON 
u.user_id = r.user_id  -- Match user_id in users and ratings
JOIN netflix n ON 
-- Join netflix table to link ratings with the actual show/movie
n.show_id = r.show_id;  -- Match show_id in ratings and netflix

SELECT * from user_ratings_view;

--3. Aggregate View
--"Create a view that shows average rating per Netflix title."
CREATE VIEW avg_show_rating AS
SELECT 
n.title,
ROUND(AVG(r.rating),2) AS avg_rating
from netflix n 
JOIN ratings r
on n.show_id = r.show_id
GROUP BY n.title;

SELECT * from avg_show_rating;

--4. WITH CHECK OPTION View
--"What is WITH CHECK OPTION and why would you use it?"
-- Create a view named 'recent_content_view'
-- This view filters Netflix titles released in 2020 or later
-- WITH CHECK OPTION ensures that any INSERT/UPDATE through this view
-- must satisfy the condition (release_year >= 2020)
CREATE VIEW recent_content_view AS
SELECT * 
from netflix
where release_year >= 2020
WITH CHECK OPTION;


--5. Updatable View
-- Create a simple view named 'users_view'
-- Since this view is based on a single table (users) and has no aggregation,
-- it is updatable (INSERT, UPDATE, DELETE allowed)
CREATE VIEW users_view AS
SELECT 
    user_id,     -- Select the user ID
    user_name    -- Select the user name
FROM users;

-- Insert a new row through the view
-- This will add a record to the underlying 'users' table
INSERT INTO users_view
VALUES (101, 'Jovita');

-- Update an existing row through the view
-- This modifies the user_name for user_id = 101 in the base table
UPDATE users_view
SET user_name = 'Jovita Mendis'
WHERE user_id = 101;

-- Delete a row through the view
-- This removes the record with user_id = 101 from the base table
DELETE FROM users_view
WHERE user_id = 101;