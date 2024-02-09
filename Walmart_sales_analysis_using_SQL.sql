CREATE DATABASE IF NOT EXISTS Walmart;
CREATE TABLE IF NOT EXISTS sales(
invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
branch VARCHAR(5) NOT NULL,
city VARCHAR(30) NOT NULL,
customer_type VARCHAR(100) NOT NULL,
gender VARCHAR(50) NOT NULL,
productline VARCHAR(50) NOT NULL,
unit_price DECIMAL(10,2) NOT NULL,
quantity INT NOT NULL,
VAT FLOAT NOT NULL,
total DECIMAL(12,5) NOT NULL,
date DATETIME NOT NULL,
time TIME NOT NULL,
payment_method VARCHAR(50) NOT NULL,
cogs DECIMAL(10,2) NOT NULL,
gross_margin_pct FLOAT NOT NULL,
gross_income DECIMAL (11,4) NOT NULL,
rating FLOAT NOT NULL
);
SELECT * FROM sales;
---------------------------------------------------------------------------------------------
-------------------------------------- Feature Engineering-----------------------------------
-- time_of_day
SELECT time,(CASE WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
ELSE 'Evening'
END) AS time_of_day
FROM sales;
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR (20) NOT NULL;
UPDATE sales
SET time_of_day = (CASE WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
ELSE 'Evening'
END);
-- day name
SELECT date,DAYNAME(date) 'day_name'  FROM sales;
ALTER TABLE sales ADD COLUMN day_name VARCHAR(50) NOT NULL;
SELECT*FROM sales;
UPDATE sales
SET day_name= DAYNAME(date);
-- month name
SELECT date,MONTHNAME(date) 'month_name'
 FROM sales;
 ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);
 UPDATE sales SET month_name=MONTHNAME(date);
 -----------------------------------------------------------------------------------------
 ----------------------------------------- GENERIC -------------------------------------
 -- Display the unique cities in the data
 SELECT DISTINCT city FROM sales;
 -- Display the unique branches in the data
  SELECT DISTINCT branch FROM sales;
  -- Which city has which branch
  SELECT DISTINCT city, branch FROM sales;
  -----------------------------------------------------------------------------------------
------------------------------------------- PRODUCT ------------------------------------
  SELECT * FROM sales;
  -- Display the count of unique product
  SELECT 
  COUNT(DISTINCT productline) FROM sales;
  
  -- What is the most common payment method
  SELECT payment_method,COUNT(payment_method) 'count' FROM sales 
  GROUP BY payment_method ORDER BY COUNT(payment_method) DESC;
  -- Most selling product line
  SELECT productline,COUNT(productline) 'count' FROM sales 
  GROUP BY productline ORDER BY count DESC;
  -- What is the total revenue by month
  SELECT month_name,SUM(total) 'total_revenue'
  FROM sales GROUP BY month_name ORDER BY total_revenue DESC;
  -- Which month had the largest COGS
  SELECT month_name, SUM(cogs) 'total_COGS'
  FROM sales GROUP BY month_name ORDER BY total_COGS DESC;
  -- What productline had the largest revenue
  SELECT productline, SUM(total) 'total_revenue'
  FROM sales GROUP BY productline ORDER BY total_revenue;
  -- Which city had the largest revenue
    SELECT city,branch,SUM(total) 'total_revenue'
  FROM sales GROUP BY city,branch ORDER BY total_revenue DESC;
  -- What product line had the largest VAT
  SELECT productline,AVG(VAT) 'AVG_VAT'
  FROM sales
  GROUP BY productline ORDER BY AVG_VAT DESC;
  -- Which branch sold more products than average product sold
  SELECT branch, SUM(quantity) 'qty'
  FROM sales GROUP BY branch HAVING SUM(quantity) > (SELECT AVG(quantity)FROM sales);
-- What is the most common product line by gender
SELECT gender,productline,COUNT(gender) 'total_cnt'
FROM sales GROUP BY gender,productline ORDER BY total_cnt DESC;
-- What is the average rating of  each product line
SELECT AVG(rating) 'avg_rating',productline 
 FROM sales GROUP BY productline ORDER BY avg_rating DESC;
  -------------------------------------------------------------------------------------------
  ----------------------------------------- Sales --------------------------------------------
   -- Number of sales made in each time of the day per weekday
   SELECT time_of_day, COUNT(*) 'Total_sales' FROM sales 
   WHERE day_name ='Monday' GROUP BY time_of_day
   ORDER BY  total_sales DESC;
   -- Which of the customer types bring the most revenue
   SELECT customer_type,SUM(total) 'total_revenue' FROM sales
   GROUP BY customer_type ORDER BY total_revenue DESC;
   -- Which city has the largest VAT
   SELECT city, SUM(VAT) 'total_VAT' FROM sales GROUP BY city ORDER BY total_VAT DESC;
   -- Which customer type pays the highest VAT 
   SELECT customer_type, SUM(VAT) 'VAT' FROM sales GROUP BY customer_type
   ORDER BY VAT DESC;
   ----------------------------------------------------------------------------------------
   ------------------------------------ CUSTOMERS ------------------------------------------
   -- How many unique customers types does the data have
   SELECT DISTINCT(customer_type) FROM sales;
   -- How many unique payment methods does the data have
   SELECT DISTINCT payment_method FROM sales;
   -- What is the most common customer type
   SELECT customer_type, COUNT(*) 'count_type' FROM sales
   GROUP BY customer_type ORDER BY Count_type DESC;
   -- Which customer type buys the most
   SELECT customer_type,COUNT(*) 'count' FROM sales GROUP BY customer_type 
   ORDER BY count DESC;
-- Most common gender
SELECT gender,COUNT(*) 'count' FROM sales GROUP BY gender
ORDER BY count DESC;
-- What is the gender distribution the most common branch
SELECT gender, COUNT(*) 'gender_cnt' FROM sales WHERE branch = 'C' 
GROUP BY gender ORDER BY gender_cnt DESC;
-- Which time of the day do customers give most ratings
SELECT time_of_day, AVG(rating) 'rating_AVG' FROM sales GROUP BY time_of_day
 ORDER BY rating_AVG DESC;
-- Which time of the day do customers give the most rating in each branch
SELECT time_of_day, AVG(rating) 'rating_AVG' FROM sales WHERE branch ='A' GROUP BY time_of_day
 ORDER BY rating_AVG DESC;
SELECT time_of_day, AVG(rating) 'rating_AVG' FROM sales WHERE branch ='B' GROUP BY time_of_day
 ORDER BY rating_AVG DESC;
SELECT time_of_day, AVG(rating) 'rating_AVG' FROM sales WHERE branch ='C' GROUP BY time_of_day
 ORDER BY rating_AVG DESC;
 -- Which day of the week has the best avg ratings?
 SELECT day_name, AVG(rating) 'avg_rating' FROM sales GROUP BY day_name ORDER BY avg_rating DESC;
-- Which day of the week has the best average ratings per branch?
 SELECT day_name, AVG(rating) 'avg_rating' FROM sales WHERE branch ='A'  GROUP BY day_name
 ORDER BY avg_rating DESC;
  SELECT day_name, AVG(rating) 'avg_rating' FROM sales WHERE branch ='B'  GROUP BY day_name
 ORDER BY avg_rating DESC;
 SELECT day_name, AVG(rating) 'avg_rating' FROM sales WHERE branch ='C'  GROUP BY day_name
 ORDER BY avg_rating DESC;
 


   
   
   