-- INSTAGRAM CASE STUDY

-- QUESTION 1
-- Find the 5 oldest users of the instagram using the database.
-- Answer Query

SELECT 
username,
created_at
FROM
instagram.users
ORDER BY 2
LIMIT 5;

-- QUESTION 2
-- Find the users who never posted a single photo on Instagram.
-- Answer Query

-- WITHOUT USING JOIN FUNCTIONS

SELECT 
id, 
username
FROM
instagram.users WHERE id NOT IN
( SELECT user_id FROM instagram.photos);

-- USING JOIN FUNCTION

SELECT 
a.username
FROM
instagram.users AS a
LEFT JOIN
instagram.photos AS b
ON a.id= b.user_id
WHERE 
b.user_id IS NULL
ORDER BY 1;

-- QUESTION 3
-- Identify the winner of the contest and provide their details to the team.
-- Answer Query

SELECT 
b.id,
a.username,
COUNT(c.user_id) AS like_count
FROM 
instagram.users AS a
INNER JOIN
instagram.photos AS b
ON a.id= b.user_id
INNER JOIN 
instagram.likes AS c
ON b.id= c.photo_id
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 1;

-- QUESTION 4
-- Identify and suggest the top 5 most commonly used hashtags on the platform
-- Answer Query

SELECT 
a.tag_name,
COUNT(b.tag_id ) AS used_counts
FROM 
instagram.tags AS a
LEFT JOIN
instagram.photo_tags AS b
ON a.id= b.tag_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- QUESTION 5
-- What day of the week do most users registers on? Provide insights on when to schedule an ad campaign.
-- Answer Query

SELECT
WEEKDAY(created_at) as day_num,
DAYNAME(created_at) AS day,
COUNT(id)
FROM
instagram.users
GROUP BY 1, 2
ORDER BY 1;

-- QUESTION 6
-- Provide how many times does an average user posts on Instagram. Also, provide the total number of photos on Instagram/ total number of users
-- Answer Query

WITH cte AS (
SELECT 
a.id AS user_id,
COUNT(b.id) AS photo_count
FROM
instagram.users AS a
LEFT JOIN
instagram.photos AS b
ON a.id= b.user_id
GROUP BY 1
ORDER BY 2 DESC)
SELECT 
SUM(photo_count) AS TotalPhotos,
COUNT(user_id) AS TotalUsers,
SUM(photo_count)/COUNT(user_id) AS AveragePostsPostedByUsers
FROM
cte;

