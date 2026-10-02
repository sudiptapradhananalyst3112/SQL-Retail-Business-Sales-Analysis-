-- SQL Retail Sales Analysis - P1

create database sql_project_p2;

-- Create Table 
DROP TABLE IF EXISTS retail_sales;
Create Table retail_sales
(
transactions_id INT PRIMARY KEY,
sale_date DATE,
sale_time TIME,
customer_id INT,
gender VARCHAR(15),
age INT,
category VARCHAR(15),
quantity INT,
price_per_unit FLOAT,
cogs FLOAT,
total_sale FLOAT 

);

select *  from retail_sales
limit 10;

select COUNT(*)  from retail_sales
;
-- FROM THIS COUNT FUNCTION I KNOW THE DATA SET COUNT IS CORRECT AND IT IS  ONE OF THE MOST IMPORTANT PART.

select *  from retail_sales
WHERE transactions_id IS NULL 

select *  from retail_sales
WHERE sale_date IS NULL 

select *  from retail_sales
WHERE sale_time IS NULL 

-- Data Cleaning 

select *  from retail_sales
WHERE
		transactions_id IS NULL 
		OR  sale_date IS NULL 
		OR sale_time IS NULL 
		OR gender IS NULL  
		OR category IS NULL 
		OR quantiy IS NULL 
		OR price_per_unit IS NULL 
		OR cogs	IS NULL 
		OR total_sale IS NULL ;
		-- Here We can see there r 3 null values so now what i should do is i have to delete these rows TATA BYE BYE !

		DELETE from retail_sales
		WHERE
		transactions_id IS NULL 
		OR  sale_date IS NULL 
		OR sale_time IS NULL 
		OR gender IS NULL  
		OR category IS NULL 
		OR quantiy IS NULL 
		OR price_per_unit IS NULL 
		OR cogs	IS NULL 
		OR total_sale IS NULL ;
		
 		-- All NULL Records Are deleted so Now its chill bro..Data Cleaning is Done bro..

 -- Data Exploration 
   -- How Many Sales we have ?
   select count(*) 
   as total_sale
   from retail_sales ;

   -- How Many UNIQUE Customers we have?
   select count(DISTINCT customer_id) 
   as total_sale
   from retail_sales ;
   --BY DISTINCT FUNCTION HERE WE CAN SEE THE ACTUAL NO OF CUSTOMERS WITHOUT DUPLICATE.

	 -- How Many UNIQUE Category we have?
	  select count(DISTINCT category) 
   		as total_sale
   		from retail_sales ;

 	   select DISTINCT category 
   		from retail_sales ;

-- Main Data Analysis & Business Key Problems 
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)



-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

select *
from retail_sales 
where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

Select *
from retail_sales 
where 
category = 'Clothing'
and 
to_char(sale_date, 'YYYY-MM') = '2022-11'
and 
quantity >=4

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
    category, 
    SUM(total_sale) AS net_sale,
	count(*) as total_orders 
FROM retail_sales 
GROUP BY 1;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

Select *
from retail_sales
where category = 'Beauty';


Select
round(avg(age),2) as avg_age
from retail_sales
where category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * 
from retail_sales 
where total_sale >1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

Select 
category,
gender,
count(*) as total_transactions
from retail_sales
group by 
category,
gender
order by 1

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

select 
extract (YEAR from sale_date) as year,
extract (MONTH from sale_date ) as month,
avg(total_sale) as Avg_Sale
From retail_sales
group by 1,2
order by 1,2

select 
extract (YEAR from sale_date) as year,
extract (MONTH from sale_date ) as month,
avg(total_sale) as Avg_Sale
From retail_sales
group by 1,2
order by 1,3 DESC



Select * From 
(
select 
extract (YEAR from sale_date) as year,
extract (MONTH from sale_date ) as month,
avg(total_sale) as Avg_Sale,
Rank () OVER (Partition by extract (YEAR from sale_date) order by avg(total_sale) DESC ) as Rank 
From retail_sales
group by 1,2
)
as t1
where Rank = 1 ;


 Select 
	year,
	month,
	avg_sale
	From
		(
		select 
		extract (YEAR from sale_date) as year,
		extract (MONTH from sale_date ) as month,
		avg(total_sale) as Avg_Sale,
		Rank () OVER (Partition by extract (YEAR from sale_date) order by avg(total_sale) DESC ) as Rank 
		From retail_sales
		group by 1,2
		)
		as t1
		where Rank = 1 ;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

Select 
	customer_id,
	sum(total_sale) as total_sale 
	From retail_sales
	group by 1
	order by 2 desc 
	limit 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

Select 
	category,
	count( Distinct customer_id) as unique_cx 
	From retail_sales
	group by category

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


with hourly_sale
As
(
 Select *,
 case 
	 when extract (hour from sale_time)< 12 then 'Morning'
	 when extract (hour from sale_time) between 12 and 17 then 'Afternoon'
	 else 'Evening'
 end as shift 
 from retail_sales 
 )
 select
 shift,
 count(*) as total_orders
 from hourly_sale
 group by shift 
	
