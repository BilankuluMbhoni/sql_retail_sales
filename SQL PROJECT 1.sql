 DROP TABLE IF EXISTS retail_sales;
 CREATE TABLE retail_sales (
transactions_id	INT PRIMARY KEY,
sale_date    DATE,
sale_time   TIME,
customer_id  INT,
gender   VARCHAR(15),
age    INT,
category VARCHAR(15),	
quantiy INT,
price_per_unit	FLOAT,
cogs	FLOAT,
total_sale FLOAT

 )
 ;



 SELECT  COUNT(*) 
 FROM retail_sales

-- DATA CLEANING

 SELECT *
FROM retail_sales
WHERE
      transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantiy IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;


 DELETE FROM retail_sales
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantiy IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

  -- DATA EXPLORATION

-- how many sales we have ?
SELECT COUNT(*) 
AS total_sales 
FROM retail_sales;

-- how many customers we have ?
SELECT COUNT(DISTINCT customer_id)
AS total_customers
FROM retail_sales;

-- how many category do we have ?
SELECT DISTINCT category
FROM retail_sales

-- data analysis and business key problems and answers

--Q.1 write a sql query to retrive all columns for sales made on '2022-11-05'

SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';

--Q.2 write a sql query to retrive all transactions  where the category  is 'Clothing' and the quantiy sold is more than 3 in the month of november-2022

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantiy > 3
  AND sale_date >= '2022-11-01'
  AND sale_date < '2022-12-01';

--Q.3  write a sql query to  calculate the total sales for each category

SELECT category,
SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY category;

--Q.4 write a sql query to find the avarage age of customers who purchased items from 'Beauty' category

SELECT ROUND(AVG(age),2) AS average_age
FROM retail_sales
WHERE category = 'Beauty';

-- Q.5 write a sql query to find all transactions where the total_sale is greater than 1000

SELECT *
FROM retail_sales 
WHERE total_sale > 1000;

SELECT * FROM retail_sales WHERE total_sale > 1000;


--Q6 write a sql query to find the total number of transactions made by each gender to each category

SELECT
gender, 
category,
COUNT(transactions_id) AS total_transactions
FROM retail_sales
GROUP BY gender, category;

--Q7 write a sql query to calculate the avarage sale for each month, find the best selling month in each year

SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    AVG(total_sale) AS average_sale
FROM 
    retail_sales
GROUP BY 
    year, month
HAVING 
    AVG(total_sale) = (
        SELECT 
            MAX(avg_monthly_sale)
			
        FROM (
            SELECT 
                EXTRACT(YEAR FROM sale_date) AS year,
                EXTRACT(MONTH FROM sale_date) AS month,
                AVG(total_sale) AS avg_monthly_sale
            FROM 
                retail_sales
            GROUP BY 
                year, month
        ) AS monthly_sales
        WHERE 
            monthly_sales.year = year
    )
ORDER BY 
    year, month;

-- Q.8 write a sql query to find the top 5 customers based on the highest total sales 

SELECT customer_id, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

--Q.9 write a sql query to find the number of unique customers who purchased items rom each category

SELECT category, COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category


--Q.10 write a sql query to create each shift and number of orders(example morning <<12 afternoon between 12 and 17, evening > 17)

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift

	-- END OF PROJECT
  






	 
