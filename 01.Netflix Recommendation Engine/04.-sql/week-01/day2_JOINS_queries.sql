--creating a table to store ratings linked to Netflix shows 
CREATE TABLE ratings(
rating_id SERIAL PRIMARY KEY, -- unique identifier for each rating
show_id TEXT, --references show_id from netflix table
user_id INT, --references user_id from users table 
rating INT --rating value(1-5)
);

--create a table to store user identities 
CREATE TABLE users
(user_id SERIAL PRIMARY KEY, --unique identifier for each user 
user_name TEXT -- name of the user
);

---Generate 1000 synthetic users named user_1through user_1000
INSERT INTO users (user_name)
SELECT 'user_' || generate_series(1,1000);

--- Insert 5000 ratings linked to existing netflix shows 
--- each rating is assigned to a random user_id between 1 and 1000
--- ratings are randomly generated between 1 and 5 
INSERT INTO ratings (show_id, user_id, rating)
SELECT show_id,
      (random()*1000)::INT + 1, -- random user_id 
      (random()*5 + 1)::INT --random rating 
FROM netflix
LIMIT 5000;

-- Add a foreign key constraint to enforce that user_id in ratings
-- must exist in the users table
ALTER TABLE ratings 
ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(user_id);

--Problem 1: INNER JOIN Basics  
--Question: You have two tables: netflix (movies) and ratings (user ratings). How do you retrieve all movies that have at least one rating?
SELECT m.title, r.rating
FROM netflix m
INNER JOIN ratings r
ON m.show_id = r.show_id;

--Problem 2: LEFT JOIN for Missing Data  
--Question: How do you list all movies, including those without ratings?
SELECT m.title, r.rating
FROM netflix m
LEFT JOIN ratings r
ON m.show_id = r.show_id;

--Problem 3: FULL JOIN for Reconciliation  
--Question: How do you find all movies and ratings, even if some ratings don’t match a movie record?
SELECT m.title, r.rating
FROM netflix m
FULL OUTER JOIN ratings r
ON m.show_id = r.show_id;

--Problem 4: Aggregated Join  
--Question: How do you calculate the average rating per genre?
SELECT listed_in, ROUND(AVG(r.rating),0) as avg_rating
FROM netflix m
INNER JOIN ratings r 
ON m.show_id = r.show_id
GROUP BY listed_in
ORDER BY avg_rating desc;

--Problem 5: Multi-Table Join  
--Question: Suppose you also have a users table. How do you show which user rated which movie?
SELECT u.user_name, r.rating, m.title
FROM users u
INNER JOIN ratings r
ON u.user_id = r.user_id 
INNER JOIN netflix m 
ON m.show_id = r.show_id;



