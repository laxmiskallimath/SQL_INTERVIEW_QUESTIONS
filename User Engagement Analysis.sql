-- ********** User Engagement Analysis ************************

-- Problem Statement: 

-- Write SQL queries to gain insights into user engagement by addressing the following problems:
--  1.Retrieve the comprehensive count of likes, comments, and shares garnered by a specific post identified by its unique post ID.
--  2.Calculate the mean number of reactions, encompassing likes, comments, and shares, per distinct user within a designated time period.
--  3.Identify the three most engaging posts, measured by the aggregate sum of reactions, within the preceding week.

-- ********************************* IN MYSQL *****************************************

-- USE DATABASE
USE USER_ENGAGEMENT;

DROP TABLE IF EXISTS Posts ;

-- Create Posts Table
CREATE TABLE Posts (
    post_id INT PRIMARY KEY,
    post_content TEXT,
    post_date DATETIME
);

-- Insert sample data into Posts Table
INSERT INTO Posts (post_id, post_content, post_date)
VALUES
    (1, 'Lorem ipsum dolor sit amet...', '2023-08-25 10:00:00'),
    (2, 'Exploring the beauty of nature...', '2023-08-26 15:30:00'),
    (3, 'Unveiling the latest tech trends...', '2023-08-27 12:00:00'),
    (4, 'Journey into the world of literature...', '2023-08-28 09:45:00'),
    (5, 'Capturing the essence of city life...', '2023-08-29 16:20:00');
    
SELECT * FROM POSTS;
    
DROP TABLE IF EXISTS UserReactions ;

-- Create User Reactions Table
CREATE TABLE UserReactions (
    reaction_id INT PRIMARY KEY,
    user_id INT,
    post_id INT,
    reaction_type ENUM('like', 'comment', 'share'),
    reaction_date DATETIME,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id)
);

-- Insert sample data into User Reactions Table
INSERT INTO UserReactions (reaction_id, user_id, post_id, reaction_type, reaction_date)
VALUES
    (1, 101, 1, 'like', '2023-08-25 10:15:00'),
    (2, 102, 1, 'comment', '2023-08-25 11:30:00'),
    (3, 103, 1, 'share', '2023-08-26 12:45:00'),
    (4, 101, 2, 'like', '2023-08-26 15:45:00'),
    (5, 102, 2, 'comment', '2023-08-27 09:20:00'),
    (6, 104, 2, 'like', '2023-08-27 10:00:00'),
    (7, 105, 3, 'comment', '2023-08-27 14:30:00'),
    (8, 101, 3, 'like', '2023-08-28 08:15:00'),
    (9, 103, 4, 'like', '2023-08-28 10:30:00'),
    (10, 105, 4, 'share', '2023-08-29 11:15:00'),
    (11, 104, 5, 'like', '2023-08-29 16:30:00'),
    (12, 101, 5, 'comment', '2023-08-30 09:45:00');
    
    SELECT * FROM UserReactions;

-- 1. Retrieve the comprehensive count of likes, comments, and shares garnered by a specific post identified by its unique post ID.
--    num_likes, num_comments, num_shares,post_content,post_id
SELECT 
    p.post_id,
    p.post_content,
    COUNT(CASE WHEN ur.reaction_type = 'like' THEN 1 END) AS num_likes,
    COUNT(CASE WHEN ur.reaction_type = 'comment' THEN 1 END) AS num_comments,
    COUNT(CASE WHEN  ur.reaction_type = 'share' THEN 1 END) AS num_shares
FROM 
   Posts p
LEFT JOIN 
  UserReactions ur ON p.post_id = ur.post_id
WHERE 
    p.post_id = 2 -- Replace with desired post_id 
GROUP BY 
   p.post_id,p.post_content;
 /*  
  # post_id	  post_content	                num_likes	num_comments	num_shares
      2	      Exploring the beauty of nature...	2	          1	            0
 */
 

-- *********************************************************************************

-- 2.Calculating the mean number of reactions, encompassing likes, comments, and shares, per distinct user within a designated time period:
-- Let's break down the question and analyze each word in order to formulate an SQL query.
-- encompassing likes, comments, and shares --> count(*) all reactions (likes,comments,shares)
-- per distinct user --> count(distinct (user_id))
-- between designated period --- > where date between '' and ''

SELECT
    DATE(ur.reaction_date) AS reaction_day,-- Converts timestamp to date datatype to get desired start and end dates  for the analysis
    COUNT(DISTINCT ur.user_id) AS distinct_users,
    COUNT(*) AS total_reactions,
    AVG(COUNT(*)) OVER (PARTITION BY DATE(ur.reaction_date)) AS avg_reactions_per_user
FROM
    UserReactions ur
WHERE
    ur.reaction_date BETWEEN '2023-08-25' AND '2023-08-31' -- Replace with desired time period
GROUP BY
    reaction_day;

/*
# reaction_day	distinct_users	total_reactions	avg_reactions_per_user
2023-08-25	          2	              2	              2.0000
2023-08-26	          2	              2	              2.0000
2023-08-27	          3	              3	              3.0000
2023-08-28            2	              2	              2.0000
2023-08-29	          2	              2	              2.0000
2023-08-30	          1	              1	              1.0000
*/

-- ******************************************************************************************************

-- 3.Identifying the three most engaging posts, measured by the aggregate sum of reactions, within the preceding week:

SELECT 
      p.post_id,
      p.post_content,
      SUM(
        CASE  WHEN ur.reaction_type = 'like' THEN 1 ELSE 0 END
        +
        CASE WHEN ur.reaction_type = 'comment' THEN 1 ELSE 0 END 
        + 
        CASE WHEN ur.reaction_type = 'share' THEN 1 ELSE 0 END
        )AS Total_reactions
FROM
    Posts p
LEFT JOIN
    UserReactions ur ON p.post_id = ur.post_id
WHERE 
    ur.reaction_date BETWEEN DATE_SUB(NOW(),INTERVAL 1 WEEK) AND NOW()
GROUP BY 
    p.post_id,p.post_content
ORDER BY 
    total_reactions DESC
LIMIT 3; -- Retrieve the top 3 most engaging posts

-- NOT GETTING RESULT AS ITS TAKING TODAY DATE THERE IS NO DATA AS PER CURRENT DATE IN TABLE 
-- LETS reaction_date BETWEEN '2023-08-25' AND '2023-08-31'
SELECT 
      p.post_id,
      p.post_content,
      SUM(
        CASE  WHEN ur.reaction_type = 'like' THEN 1 ELSE 0 END
        +
        CASE WHEN ur.reaction_type = 'comment' THEN 1 ELSE 0 END 
        + 
        CASE WHEN ur.reaction_type = 'share' THEN 1 ELSE 0 END
        )AS Total_reactions
FROM
    Posts p
LEFT JOIN
    UserReactions ur ON p.post_id = ur.post_id
WHERE 
    ur.reaction_date BETWEEN '2023-08-25' AND '2023-08-31' -- TAKING DATE AS IN DATA
GROUP BY 
    p.post_id,p.post_content
ORDER BY 
    total_reactions DESC
LIMIT 3; -- Retrieve the top 3 most engaging posts

/*
# post_id	  post_content	                   Total_reactions
     1	    Lorem ipsum dolor sit amet...	         3
     2	    Exploring the beauty of nature...	     3
     3	    Unveiling the latest tech trends...	     2
*/

-- IN SNOWFLAKE

-- ********** User Engagement Analysis: Problem Statement ************************

-- Write SQL queries to gain insights into user engagement by addressing the following problems:

DROP TABLE IF EXISTS Posts ;

-- Create Posts Table
CREATE OR REPLACE TABLE Posts (
    post_id INT PRIMARY KEY,
    post_content TEXT,
    post_date DATETIME
);

-- Insert sample data into Posts Table
INSERT INTO Posts (post_id, post_content, post_date)
VALUES
    (1, 'Lorem ipsum dolor sit amet...', '2023-08-25 10:00:00'),
    (2, 'Exploring the beauty of nature...', '2023-08-26 15:30:00'),
    (3, 'Unveiling the latest tech trends...', '2023-08-27 12:00:00'),
    (4, 'Journey into the world of literature...', '2023-08-28 09:45:00'),
    (5, 'Capturing the essence of city life...', '2023-08-29 16:20:00');
    
SELECT * FROM POSTS;
    
DROP TABLE IF EXISTS UserReactions ;

-- Create User Reactions Table
CREATE OR REPLACE TABLE UserReactions (
    reaction_id INT PRIMARY KEY,
    user_id INT,
    post_id INT,
    reaction_type STRING, -- Snowflake does not have an ENUM type, so using STRING
    reaction_date TIMESTAMP_NTZ, -- Assuming TIMESTAMP_NTZ for storing datetime
    FOREIGN KEY (post_id) REFERENCES Posts(post_id)
);

-- Insert sample data into User Reactions Table
INSERT INTO UserReactions (reaction_id, user_id, post_id, reaction_type, reaction_date)
VALUES
    (1, 101, 1, 'like', '2023-08-25 10:15:00'),
    (2, 102, 1, 'comment', '2023-08-25 11:30:00'),
    (3, 103, 1, 'share', '2023-08-26 12:45:00'),
    (4, 101, 2, 'like', '2023-08-26 15:45:00'),
    (5, 102, 2, 'comment', '2023-08-27 09:20:00'),
    (6, 104, 2, 'like', '2023-08-27 10:00:00'),
    (7, 105, 3, 'comment', '2023-08-27 14:30:00'),
    (8, 101, 3, 'like', '2023-08-28 08:15:00'),
    (9, 103, 4, 'like', '2023-08-28 10:30:00'),
    (10, 105, 4, 'share', '2023-08-29 11:15:00'),
    (11, 104, 5, 'like', '2023-08-29 16:30:00'),
    (12, 101, 5, 'comment', '2023-08-30 09:45:00');
    
    SELECT * FROM UserReactions;

-- 1. Retrieve the comprehensive count of likes, comments, and shares garnered by a specific post identified by its unique post ID.
SELECT 
    p.post_id,
    p.post_content,
    COUNT(CASE WHEN ur.reaction_type = 'like' THEN 1 END) AS num_likes,
    COUNT(CASE WHEN ur.reaction_type = 'comment' THEN 1 END) AS num_comments,
    COUNT(CASE WHEN  ur.reaction_type = 'share' THEN 1 END) AS num_shares
FROM 
   Posts p
LEFT JOIN 
  UserReactions ur ON p.post_id = ur.post_id
WHERE 
    p.post_id = 2 -- Replace with desired post_id 
GROUP BY 
   p.post_id,p.post_content;
 /*  
  # post_id	  post_content	                num_likes	num_comments	num_shares
      2	      Exploring the beauty of nature...	2	          1	            0
 */
 
-- OR

SELECT
    p.post_id,
    p.post_content,
    COUNT(IFF(ur.reaction_type = 'like', 1, NULL)) AS num_likes,
    COUNT(IFF(ur.reaction_type = 'comment', 1, NULL)) AS num_comments,
    COUNT(IFF(ur.reaction_type = 'share', 1, NULL)) AS num_shares
FROM
    Posts p
LEFT JOIN
    UserReactions ur ON p.post_id = ur.post_id
WHERE
    p.post_id = 2
GROUP BY
    p.post_id, p.post_content;

-- *********************************************************************************
-- 2.Calculating the mean number of reactions, encompassing likes, comments, and shares, per distinct user within a designated time period:
SELECT 
      DATE(ur.reaction_date) AS reaction_day,
      COUNT(DISTINCT(ur.user_id)) AS distinct_users,
      COUNT(*) AS Total_all_reactions,-- encompassing likes, comments, and shares
      AVG(COUNT(*)) OVER (PARTITION BY DATE(ur.reaction_date)) AS avg_reactions_per_user
FROM 
     USERREACTIONS  ur
WHERE 
     ur.reaction_date BETWEEN '2023-08-25' AND '2023-08-31'
GROUP BY 
      reaction_day;

/*
REACTION_DAY	DISTINCT_USERS	TOTAL_ALL_REACTIONS	AVG_REACTIONS_PER_USER
2023-08-25	         2	             2	                 2.000
2023-08-26	         2	             2	                 2.000
2023-08-27	         3	             3	                 3.000
2023-08-28	         2	             2	                 2.000
2023-08-29	         2	             2	                 2.000
2023-08-30	         1	             1	                 1.000
*/

-- ******************************************************************************************************
-- 3.Identifying the three most engaging posts, measured by the aggregate sum of reactions, within the preceding week:

-- three most engaging posts --LIMIT 3
-- SUM(LIKES+SHARES+COMMENTS) --- sum of reactions

SELECT 
      p.post_id,
      p.post_content,
      SUM(
        CASE  WHEN ur.reaction_type = 'like' THEN 1 ELSE 0 END
        +
        CASE WHEN ur.reaction_type = 'comment' THEN 1 ELSE 0 END 
        + 
        CASE WHEN ur.reaction_type = 'share' THEN 1 ELSE 0 END
        )AS Total_reactions
FROM
    Posts p
LEFT JOIN
    UserReactions ur ON p.post_id = ur.post_id
WHERE 
    ur.reaction_date BETWEEN DATEADD(WEEK, -1, CURRENT_TIMESTAMP()) AND CURRENT_TIMESTAMP()
GROUP BY 
    p.post_id,p.post_content
ORDER BY 
    total_reactions DESC
LIMIT 3; -- Retrieve the top 3 most engaging posts

-- NOT GETTING RESULT AS ITS TAKING TODAY DATE THERE IS NO DATA AS PER CURRENT DATE IN TABLE 

-- LETS reaction_date BETWEEN '2023-08-25' AND '2023-08-31'
SELECT 
      p.post_id,
      p.post_content,
      SUM(
        CASE  WHEN ur.reaction_type = 'like' THEN 1 ELSE 0 END
        +
        CASE WHEN ur.reaction_type = 'comment' THEN 1 ELSE 0 END 
        + 
        CASE WHEN ur.reaction_type = 'share' THEN 1 ELSE 0 END
        )AS Total_reactions
FROM
    Posts p
LEFT JOIN
    UserReactions ur ON p.post_id = ur.post_id
WHERE 
    ur.reaction_date BETWEEN '2023-08-25' AND '2023-08-31' -- TAKING DATE AS IN DATA
GROUP BY 
    p.post_id,p.post_content
ORDER BY 
    total_reactions DESC
LIMIT 3; -- Retrieve the top 3 most engaging posts

/*
POST_ID	   POST_CONTENT	                       TOTAL_REACTIONS
1	         Lorem ipsum dolor sit amet...	          3
2	         Exploring the beauty of nature...	      3
4	         Journey into the world of literature...	2
*/




 






















