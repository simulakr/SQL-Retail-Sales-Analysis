--SQL RETAIL SALES ANALYSIS--
--Renaming Table
ALTER TABLE "SQLRetailSalesAnalysis_utf" RENAME TO sales

--Overview
SELECT * FROM sales
SELECT COUNT(*) FROM SALES

--Categories
SELECT DISTINCT category FROM sales

--Head of Table
SELECT * FROM sales LIMIT 5

--NULL VALUES
SELECT 
    SUM(CASE WHEN transactions_id IS NULL THEN 1 ELSE 0 END) AS transactions_id_nulls,
    SUM(CASE WHEN sale_date IS NULL THEN 1 ELSE 0 END) AS sale_date_nulls,
    SUM(CASE WHEN sale_time IS NULL THEN 1 ELSE 0 END) AS sale_time_nulls,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS customer_id_nulls,
    SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS gender_nulls,
    SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS age_nulls,
    SUM(CASE WHEN category IS NULL THEN 1 ELSE 0 END) AS category_nulls,
    SUM(CASE WHEN quantiy IS NULL THEN 1 ELSE 0 END) AS quantity_nulls,
    SUM(CASE WHEN price_per_unit IS NULL THEN 1 ELSE 0 END) AS price_per_unit_nulls,
    SUM(CASE WHEN cogs IS NULL THEN 1 ELSE 0 END) AS cogs_nulls,
    SUM(CASE WHEN total_sale IS NULL THEN 1 ELSE 0 END) AS total_sale_nulls
FROM sales;

SELECT * FROM sales 
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
        OR total_sale IS NULL 
        
--Data Cleaning 
DELETE FROM sales
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
        OR total_sale IS NULL 
      
-- Date and Time Variables
ALTER TABLE sales 
ALTER COLUMN sale_date TYPE DATE USING sale_date::DATE,
ALTER COLUMN sale_time TYPE TIME USING sale_time::TIME;
--
SELECT sale_date, sale_time FROM sales LIMIT 5;

--Data Exploration
--How many sales we have?
 SELECT COUNT(*) FROM SALES
 
--How many customers we have?
SELECT COUNT(DISTINCT customer_id) FROM sales

--Number of Category and names
SELECT COUNT(DISTINCT category) FROM sales
SELECT DISTINCT category from sales

--Data Analysis & Business Key Problem & Answers
--Date Interval
SELECT MIN(sale_date), MAX(sale_date) FROM SALES
--Sales made on last day
SELECT * FROM sales where sale_date = (SELECT max(sale_date) FROM sales) 

--Clothing Sales in November 2022
SELECT category, SUM(quantiy) FROM sales
	where category='Clothing' AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-10'
GROUP BY 1

--Clothing Sales quantity more than 3 in November 2022
SELECT category, quantiy FROM sales
	where category='Clothing' AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-10' and
    quantiy > 3

--Total sales each category
SELECT category, count(total_sale) as total_orders,
	sum(total_sale) as net_sales
    from sales
    GROUP by category

-- Age of Customer shopping in the beauty category
SELECT AVG(age) as avg_age
from sales where category='Beauty' --40.41

SELECT AVG(age) from sales --41.35

--Gender of Customers shopping in the beauty categorysales
SELECT  gender, count(*)
	from sales 
	WHERE category='Beauty'
    GROUP by category, gender

-- 	Transactransactions_id that	total	sale greater than 1000
SELECT transactions_id , total_sale FROM sales
	WHERE total_sale > 1000
  
-- Number of gender each category
SELECT category, gender, COUNT(*)
	FROM sales
	GROUP by category , gender
    ORDER by 3 DESC
    
--Average sale of each month and each year
SELECT EXTRACT(YEAR from sale_date) as YEAR_,
		EXTRACT(MONTH FROM sale_date) as month_,
        sum(total_sale) from sales
        GROUP by 1 , 2
        ORDER by 1 , 2

--MSSQL Query
SELECT YEAR(sale_date) AS year_,
       MONTH(sale_date) AS month_,
       SUM(total_sale) AS total_sales
FROM sales
GROUP BY YEAR(sale_date), MONTH(sale_date)
ORDER BY YEAR(sale_date), MONTH(sale_date);


--Top 3
SELECT EXTRACT(YEAR from sale_date) as YEAR_,
		EXTRACT(MONTH FROM sale_date) as month_,
        sum(total_sale) from sales
        GROUP by 1 , 2
        ORDER by 3 DESC
        LIMIT 3

--The highest sales months of 2022 and 2023
SELECT * from
(SELECT EXTRACT(YEAR from sale_date) as YEAR_,
		EXTRACT(MONTH FROM sale_date) as month_,
        sum(total_sale) ,
        rank() over(PARTITION by EXTRACT(YEAR from sale_date) ORDER by sum(total_sale) deSC) as rank
        from sales
        GROUP by 1 , 2) as t1 
        WHERE rank=1

--Top 5 customers have highest total sale 
SELECT  customer_id, 
		sum(total_sale)
		FROM sales
        GROUP by customer_id
        ORDER by 2 desc
LIMIT 5

--Unique customers from each category

SELECT DISTINCT category,
		COUNT(DISTINCT customer_id)
        FROM sales 
        GROUP by category
        
--Create new columns. 
	--(Morning, afternoon, evening)
WITH hourly_sale
as
(
SELECT *,
	case 
    	when EXTRACT(hour from sale_time) < 12 then 'Morning' 
        when EXTRACT(hour from sale_time) BETWEEN 12 and 17 THEN 'Afternoon'
        ELSE 'Evening'
    end as shift
 from sales
  )
SELECT shift, 
		COUNT(*)
		from hourly_sale
  		GROUP by shift
        
        
--End of the Project 
