-- SQL Retail Sales Analysis P1

create database sql_project_p1;

-- create table

create table retail_sales
		(
			transactions_id	int,
			sale_date	date,
			sale_time	time,
			customer_id	int,
			gender	varchar (15),
			age	int,
			category varchar (25),
			quantiy	int,
			price_per_unit float,
			cogs	float,
			total_sale float
		);
        
ALTER TABLE retail_sales
CHANGE COLUMN quantiy quantity int not null;
        
SELECT * FROM retail_sales;

SELECT *
FROM retail_sales
WHERE total_sale is null;

-- Data Exploration 
-- How many sales we have?

SELECT COUNT(*) AS total_sales
FROM retail_sales;

-- How many unique customers we have?

SELECT COUNT(DISTINCT customer_id)
FROM retail_sales;

-- Data Analysis & Business Key Problems and Answers

-- Q1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'

SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q2 Write a SQL query to retrieve all transactions where category is 'Clothing' and the quantity sold is 
-- more than 10 in the month of Nov-2022

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
AND sale_date BETWEEN '2022-11-01' AND '2022-11-30'
AND quantiy >= 4;

-- Q3 Write a SQL query to calculate the total sales (total_sale) for each category

SELECT category, 
SUM(total_sale) AS Net_sales,
COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

-- Q4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category

SELECT ROUND(AVG(age),2) AS average_age_of_customers
FROM retail_sales
WHERE category = 'Beauty';

-- Q5 Write a SQL query to find all transactions where the total_sale is greater than 1000

SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- Q6 Write a SQL query to find the total number of transactions(transaction_id) made by each gender in each category

SELECT category, gender, COUNT(*) AS Total_number_of_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category;

-- Q7 Write a SQL query to calculate the average sale for each month. Find out the best selling month in each year.

SELECT Year, Month, Average_sales
 FROM
(
SELECT YEAR(sale_date) AS Year,
MONTH(sale_date) AS Month,
ROUND(AVG(total_sale),2) AS Average_sales,
RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS rank_num
FROM retail_sales
GROUP BY 1,2) AS T1
WHERE rank_num = 1;

-- Q8 Write a SQL query to find top 5 customers based on the highest total sales

SELECT customer_id,
SUM(total_sale) AS Highest_total_sales
FROM retail_sales 
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC
LIMIT 5;

-- Q9 Write a SQL query to find the number of unique customers who purchased items from each category

SELECT category, COUNT(DISTINCT customer_id) AS Unique_customers
FROM retail_sales
GROUP BY category; 

-- Q10 Write a SQL query to create each shift and number of orders (Example morning <= 12, Afternoon Between 12 & 
-- 17, Evening >17)

WITH hourly_sales
AS 
(
SELECT *,
	CASE WHEN HOUR(sale_time) < 12 THEN 'Morning'
    WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
    END AS Shift
    FROM retail_sales
    )
SELECT shift,
	COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shift;

-- End of Project

