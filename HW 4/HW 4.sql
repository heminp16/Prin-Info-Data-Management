#1 Draw ER diagram

#2 Create table
Create Database hw4;
CREATE TABLE `tripadvisor` (
  `RESTAURANT` text,
  `RANK` int DEFAULT NULL,
  `SCORE` double DEFAULT NULL,
  `USER_NAME` text,
  `REVIEW_STARS` int DEFAULT NULL,
  `REVIEW_DATE` text,
  `USER_REVIEWS` int DEFAULT NULL,
  `USER_RESTAURANT_REVIEWS` int DEFAULT NULL,
  `USER_HELPFUL_VOTES` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

#3 Identify reasonable functional dependencies 
-- SELECT * FROM hw4.tripadvisor; 

-- Restaurant -> rank,  score
SELECT DISTINCT 'True' as 'nonempty'
From hw4.tripadvisor t1
Where Not Exists (SELECT * from hw4.tripadvisor t1, hw4.tripadvisor t2 where t1.RESTAURANT = t2.RESTAURANT and (t1.RANK != t2.RANK or t1.SCORE != t2.SCORE))
UNION
SELECT DISTINCT 'False' as 'nonempty' 
FROM hw4.tripadvisor t1
Where Exists (SELECT * from hw4.tripadvisor t1, hw4.tripadvisor t2 where t1.RESTAURANT = t2.RESTAURANT and (t1.RANK != t2.RANK or t1.SCORE != t2.SCORE))

-- restaurant, user_name, review_date -> user_review, user_restaurant_review, user_helpful_votes, review_stars
SELECT DISTINCT 'True' as 'nonempty'
From hw4.tripadvisor t1
Where Not Exists (SELECT * from hw4.tripadvisor t1, hw4.tripadvisor t2 where (t1.RESTAURANT = t2.RESTAURANT) and (t1.USER_NAME = t2.USER_NAME) and (t1.REVIEW_DATE = t2.REVIEW_DATE) and (t1.USER_REVIEWS != t2.USER_REVIEWS and (t1.USER_RESTAURANT_REVIEWS != t2.USER_RESTAURANT_REVIEWS) and (t1.USER_HELPFUL_VOTES != t2.USER_HELPFUL_VOTES) and t1.REVIEW_STARS != t2.REVIEW_STARS))
UNION
SELECT DISTINCT 'False' as 'nonempty' 
FROM hw4.tripadvisor t1
Where Exists (SELECT * from hw4.tripadvisor t1, hw4.tripadvisor t2 where (t1.RESTAURANT = t2.RESTAURANT) and (t1.USER_NAME = t2.USER_NAME) and (t1.REVIEW_DATE = t2.REVIEW_DATE) and (t1.USER_REVIEWS != t2.USER_REVIEWS and (t1.USER_RESTAURANT_REVIEWS != t2.USER_RESTAURANT_REVIEWS) and (t1.USER_HELPFUL_VOTES != t2.USER_HELPFUL_VOTES) and t1.REVIEW_STARS != t2.REVIEW_STARS))

#4 Show that TripAdvisor is not in the BCNF. This requires identifying functional dependency which violates BCNF.  Decompose TripAdvisor to BCNF.
# Restaurant table, distinct rest, rest Primary
Create table hw4.Rest
As (Select distinct t.RESTAURANT, t.RANK, t.SCORE #Made restaurant primary: PRIMARY KEY (`RESTAURANT`(45))
From hw4.tripadvisor t);

# User table, distinct user, sum()
Create table hw4.Users
As (Select distinct t.USER_NAME, SUM(t.USER_REVIEWS) as USER_REVIEWS , SUM(USER_RESTAURANT_REVIEWS) as USER_RESTAURANT_REVIEWS,  SUM(t.USER_HELPFUL_VOTES) as USER_HELPFUL_VOTES
From hw4.tripadvisor t Group BY USER_NAME)

DELETE from hw4.Users WHERE USER_NAME = '0';


# Review table, distinct review, avg()
Create table hw4.Reviews
As Select t.RESTAURANT, t.USER_NAME, MAX(REVIEW_DATE) as REVIEW_DATE, AVG(REVIEW_STARS) as REVIEW_STARS
From hw4.tripadvisor t
Group BY RESTAURANT, USER_NAME;

#5  write simple queries to populate these tables.

-- Who wrote the most Restaurant review, this is intresting because it shows how active this person is when revewing resturants. 
Select USER_NAME
From hw4.Users 
where (USER_RESTAURANT_REVIEWS) > 2000 
Order by USER_NAME Limit 1

-- Which restaurant has the lowest avg stars? 
Select RESTAURANT, REVIEW_STARS, USER_NAME -- I chose to include the users who left these reviews as eveyone has differnt perferences.  
From hw4.Reviews 
where REVIEW_STARS < 2

-- Which restaurant has the highest score? 
Select RESTAURANT, SCORE
From hw4.Rest 
where SCORE = 5




