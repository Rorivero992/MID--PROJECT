-- --------------------------------------------------------------------------------

--                     MID PROJECT SQL QUESTIONS - REGRESSION

-- --------------------------------------------------------------------------------

-- INSTRUCTIONS
-- (Use sub queries or views wherever necessary)


-- 1. Create a database called house_price_regression.

CREATE DATABASE IF NOT EXISTS house_price_regression;

USE house_price_regression;


-- 2. Create a table house_price_data with the same columns as given in the csv file. 
-- Please make sure you use the correct data types for the columns.

DROP TABLE IF EXISTS house_price_data;

CREATE TABLE house_price_data (
    property_id BIGINT DEFAULT NULL,
    date TEXT DEFAULT NULL,
    bedrooms INT DEFAULT NULL,
    bathrooms DOUBLE DEFAULT NULL,
    sqft_living INT DEFAULT NULL,
    sqft_lot INT DEFAULT NULL,
    floors INT DEFAULT NULL,
    waterfront INT DEFAULT NULL,
    `view` INT DEFAULT NULL,
    `condition` INT DEFAULT NULL,
    grade INT DEFAULT NULL,
    sqft_above INT DEFAULT NULL,
    sqft_basement INT DEFAULT NULL,
    yr_built INT DEFAULT NULL,
    yr_renovated INT DEFAULT NULL,
    zip_code INT DEFAULT NULL,
    lat DOUBLE DEFAULT NULL,
    lon DOUBLE DEFAULT NULL,
    sqft_living15 INT DEFAULT NULL,
    sqft_lot15 INT DEFAULT NULL,
    price INT DEFAULT NULL
);

SELECT * FROM house_price_data;
ALTER TABLE house_price_data ADD COLUMN id INT NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;

-- Change column names that are reserved words in MySQL

ALTER TABLE house_price_data CHANGE COLUMN `view` house_view INT;
ALTER TABLE house_price_data CHANGE COLUMN `condition` house_condition INT;

-- 6) Use sql query to find how many rows of data you have.
SELECT count(*) as count_rows FROM house_price_data;

/* 7) Now we will try to find the unique values in some of the categorical columns:

What are the unique values in the column bedrooms?
What are the unique values in the column bathrooms?
What are the unique values in the column floors?
What are the unique values in the column condition?
What are the unique values in the column grade? */ 

SELECT DISTINCT(bedrooms) FROM house_price_data;
SELECT DISTINCT(bathrooms) FROM house_price_data;
SELECT DISTINCT(floors) FROM house_price_data;
SELECT DISTINCT(house_condition) FROM house_price_data
ORDER BY house_condition DESC;
SELECT DISTINCT(grade) FROM house_price_data 
ORDER BY grade DESC;

-- 8) Arrange the data in a decreasing order by the price of the house. Return only the IDs of the top 10 most expensive houses in your data.

SELECT * FROM house_price_data
ORDER BY price DESC
LIMIT 10;

-- 9) What is the average price of all the properties in your data?

SELECT ROUND(AVG(price), 2) AS AVERAGE_PRICE FROM house_price_data;

/* 10) In this exercise we will use simple group by to check the properties of some of the categorical variables in our data

A) What is the average price of the houses grouped by bedrooms? The returned result should have only two columns, bedrooms and Average of the prices. Use an alias to change the name of the second column.
B) What is the average sqft_living of the houses grouped by bedrooms? The returned result should have only two columns, bedrooms and Average of the sqft_living. Use an alias to change the name of the 
second column.
C) What is the average price of the houses with a waterfront and without a waterfront? The returned result should have only two columns, waterfront and Average of the prices. Use an alias to change the 
name of the second column.
D) Is there any correlation between the columns condition and grade? You can analyse this by grouping the data by one of the variables and then aggregating the results of the other column. Visually check 
if there is a positive correlation or negative correlation or no correlation between the variables. */ 

-- A)
SELECT bedrooms, ROUND(AVG(price),2) AS Average_price
FROM house_price_data
GROUP BY bedrooms
order by bedrooms;

-- B)
SELECT bedrooms, ROUND(AVG(sqft_living),2) AS Average_sqft_living
FROM house_price_data
GROUP BY bedrooms
order by bedrooms;

-- C)
SELECT waterfront, ROUND(AVG(price),2) AS Average_price
FROM house_price_data
GROUP BY waterfront;

-- D)
SELECT house_condition, AVG(grade) 
FROM house_price_data
GROUP BY house_condition
ORDER BY house_condition;

/* 11) One of the customers is only interested in the following houses:

- Number of bedrooms either 3 or 4
- Bathrooms more than 3
- One Floor
- No waterfront
- Condition should be 3 at least
- Grade should be 5 at least
- Price less than 300000
- For the rest of the things, they are not too concerned. Write a simple query to find what are the options available for them? */

SELECT *
FROM house_price_data
WHERE (Bathrooms > 3 AND Bathrooms < 4) AND (Floors=1) AND (waterfront=0) AND (house_condition >= 3) AND (Grade >= 5) AND (Price < 300000);

-- 12) Your manager wants to find out the list of properties whose prices are twice more than the average of all the properties in the database. Write a query to show them the list of such properties. 
-- You might need to use a sub query for this problem.

SELECT *
FROM house_price_data
WHERE price >= (SELECT 2 * AVG(price) FROM house_price_data);

-- 13) Since this is something that the senior management is regularly interested in, create a view of the same query.

CREATE VIEW properties_twice_average AS
SELECT *
FROM house_price_data
WHERE price >= (SELECT 2 * AVG(price) FROM house_price_data);

-- 14) Most customers are interested in properties with three or four bedrooms. What is the difference in average prices of the properties with three and four bedrooms?

SELECT t1.bedrooms, t1.avg_price, t2.avg_price AS avg_price_4_bedrooms, ROUND(t2.avg_price - t1.avg_price, 2) AS price_difference
FROM (SELECT bedrooms, ROUND(AVG(price), 2) AS avg_price
    FROM house_price_data
    WHERE bedrooms IN (3, 4)
    GROUP BY bedrooms) t1
JOIN (SELECT bedrooms, ROUND(AVG(price), 2) AS avg_price
    FROM house_price_data
    WHERE bedrooms IN (3, 4)
    GROUP BY bedrooms) t2
ON t1.bedrooms = 3 AND t2.bedrooms = 4;

-- 15) What are the different locations where properties are available in your database? (distinct zip codes)

SELECT DISTINCT(zip_code)
FROM house_price_data;

-- 16) Show the list of all the properties that were renovated.
SELECT * 
FROM house_price_data
WHERE yr_renovated <> 0;

-- 17) Provide the details of the property that is the 11th most expensive property in your database.

SELECT * 
FROM house_price_data
ORDER BY price DESC
LIMIT 1 OFFSET 10;



