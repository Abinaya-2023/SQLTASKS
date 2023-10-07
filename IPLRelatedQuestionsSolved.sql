-- IPL CASE STUDY

-- QUESTION 1
-- Find the number of matches played in each venue?
-- Answer Query

SELECT 
venue.name AS venue_name,
COUNT(matches.id) AS number_of_matches
FROM
ipl.ipl_matches AS matches
INNER JOIN
ipl.venues AS venue
ON matches.venue_id= venue.id
GROUP BY venue.name
ORDER BY 2 DESC;

-- QUESTION 2
-- Find count of matches won by each team for each season?
-- Answer Query

SELECT 
b.name AS team_name,
c.name AS season_name,
COUNT(a.id) AS matches_won
FROM
ipl.ipl_matches AS a
LEFT JOIN
ipl.teams as b
ON 
a.winner_id= b.id
INNER JOIN
ipl.seasons AS c
ON  
a.season_id= c.id
GROUP BY b.name, c.name
ORDER BY 1,2;

-- QUESTION 3
-- Season wise find the number of MOM award won by player sort by season ascending and number of MOM won descending.
-- Answer Query

SELECT 
b.Player_Name,
c.name AS season_name,
COUNT(a.player_of_match_id) AS Award_count
FROM
ipl.ipl_matches AS a
INNER JOIN
ipl.players AS b
ON 
a.player_of_match_id= b.id
INNER JOIN
ipl.seasons AS c
ON a.season_id= c.id
GROUP BY 1, 2
ORDER BY 2 ASC, 3 DESC; 

-- QUESTION 4
-- Find which player has won most number of man of the match in each season.
-- Answer Query

WITH mom as(
SELECT 
b.Player_Name,
c.name AS season_name,
COUNT(a.player_of_match_id) AS Award_count,
DENSE_RANK() OVER (PARTITION BY c.name ORDER BY COUNT(a.player_of_match_id) DESC) AS rnk
FROM
ipl.ipl_matches AS a
INNER JOIN
ipl.players AS b
ON 
a.player_of_match_id= b.id
INNER JOIN
ipl.seasons AS c
ON a.season_id= c.id
GROUP BY 1, 2
ORDER BY 2 ASC, 3 DESC)
SELECT 
season_name,
Player_name,
Award_count
FROM 
mom
WHERE rnk=1;

-- QUESTION 5
-- Display matches participated by umpires
-- Answer Query

WITH temp AS(
SELECT 
b.name,
a.id
FROM
ipl.ipl_matches AS a
INNER JOIN
ipl.umpires AS b
ON 
a.umpire1_id= b.id
UNION
SELECT 
b.name,
a.id 
FROM 
ipl.ipl_matches AS a
INNER JOIN
ipl.umpires AS b
ON 
a.umpire2_id= b.id)
SELECT 
name,
COUNT(DISTINCT id) AS number_of_matches
FROM
temp
GROUP BY 1
ORDER BY 2 DESC;





