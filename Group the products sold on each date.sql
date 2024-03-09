-- IN MYSQL

-- Group Sold Products by Date using SQL

-- You are given a table named Activities. Each row in the table represents a sales activity, and the columns contain essential details as shown below:
/*
+------------+---------+
| sell_date  | product |
+------------+---------+
| 2020-05-30 | Apples  |
| 2020-06-01 | Milk    |
| 2020-06-02 | Bread   |
| 2020-05-30 | Bananas |
| 2020-06-01 | Cereal  |
| 2020-06-02 | Bread   |
| 2020-05-30 | Oranges |
+------------+---------+
*/
-- The task is to organize and present this sales data in a meaningful format. 
-- The goal is to group the products that were sold on each date and calculate the total number of products sold on that date.
-- Solving this problem requires grouping the data based on the dates and aggregating the number of products sold on each date. 
-- Additionally, the unique product names for each date need to be combined into a single string, separated by commas.
use salesdata;

CREATE TABLE Activities (
    sell_date DATE,
    product VARCHAR(50)
);

INSERT INTO Activities (sell_date, product)
VALUES
    ('2020-05-30', 'Apples'),
    ('2020-06-01', 'Milk'),
    ('2020-06-02', 'Bread'),
    ('2020-05-30', 'Bananas'),
    ('2020-06-01', 'Cereal'),
    ('2020-06-02', 'Bread'),
    ('2020-05-30', 'Oranges');
    
 SELECT 
      sell_date,
      COUNT(*) AS num_sold,
      group_concat(DISTINCT PRODUCT ORDER BY PRODUCT ASC) AS PRODUSCTS
FROM 
    activities
GROUP BY 
    sell_date
ORDER BY 
    sell_date;
    
/*    
# sell_date	num_sold	PRODUSCTS
2020-05-30	3	Apples,Bananas,Oranges
2020-06-01	2	Cereal,Milk
2020-06-02	2	Bread

*/
    
-- *****************************************************************************************   
    
 -- IN SNOWFLAKE 

-- In Snowflake, the LISTAGG() function is commonly used to concatenate values from multiple rows into a single string within a group. Here's an example --- of how you can use LISTAGG() to achieve similar functionality to GROUP_CONCAT() in other database systems:

-- Sample table and data
CREATE TABLE sample_data (
    group_id INT,
    value VARCHAR(50)
);

INSERT INTO sample_data (group_id, value)
VALUES
    (1, 'A'),
    (1, 'B'),
    (1, 'C'),
    (2, 'X'),
    (2, 'Y'),
    (2, 'Z');

-- Query using LISTAGG for concatenation
SELECT
    group_id,
    LISTAGG(value, ', ') WITHIN GROUP (ORDER BY value) AS concatenated_values
FROM
    sample_data
GROUP BY
    group_id;
CREATE TABLE Activities (
    sell_date DATE,
    product VARCHAR(50)
);

INSERT INTO Activities (sell_date, product)
VALUES
    ('2020-05-30', 'Apples'),
    ('2020-06-01', 'Milk'),
    ('2020-06-02', 'Bread'),
    ('2020-05-30', 'Bananas'),
    ('2020-06-01', 'Cereal'),
    ('2020-06-02', 'Bread'),
    ('2020-05-30', 'Oranges');

select 
      sell_date,
      count(*) AS num_sold,
        LISTAGG(product, ', ') WITHIN GROUP (ORDER BY product) AS products
from 
     activities
group by 
     sell_date
order by 
     sell_date;

/*
SELL_DATE	NUM_SOLD	PRODUCTS
2020-05-30	3	        Apples, Bananas, Oranges
2020-06-01	2	        Cereal, Milk
2020-06-02	2	        Bread, Bread
*/
     














   






