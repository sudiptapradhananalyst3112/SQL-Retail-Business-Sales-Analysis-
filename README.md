# 🛒 SQL Retail Sales Analysis Project

## 📌 Project Overview
This project demonstrates an end-to-end data analyst workflow using **SQL (Structured Query Language)** to build, clean, and analyze a retail sales database. The goal is to transform raw transactional records into actionable business insights by answering key operational and strategic retail questions.

This project is perfect for showcasing data pipeline setup, comprehensive data cleansing, and analytical query writing.

---

## 🛠️ Database Schema & Table Architecture

First, we set up the database environment and build the structure to hold our transactional records.

```sql
-- Create the project database
CREATE DATABASE sql_project_p2;

-- Drop table if it already exists to start fresh
DROP TABLE IF EXISTS retail_sales;

-- Create the master data table
CREATE TABLE retail_sales (
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
```

---

## 🧼 Data Cleansing & Quality Control
Before running analytical business logic, the dataset must be audited for missing records. Rows containing critical `NULL` data fields are isolated and removed to ensure analytical integrity.

```sql
-- 1. Scan the dataset for any structural NULL entries
SELECT * FROM retail_sales
WHERE 
    transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL 
    OR gender IS NULL OR category IS NULL OR quantity IS NULL 
    OR price_per_unit IS NULL OR cogs IS NULL OR total_sale IS NULL;

-- 2. Purge rows containing NULL fields
DELETE FROM retail_sales
WHERE 
    transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL 
    OR gender IS NULL OR category IS NULL OR quantity IS NULL 
    OR price_per_unit IS NULL OR cogs IS NULL OR total_sale IS NULL;
```

---

## 🔍 Exploratory Data Analysis (EDA)
Quick investigative summaries to understand the total operational scale:

* **Total Sales Records Logged:**
  ```sql
  SELECT COUNT(*) AS total_sale FROM retail_sales;
  ```
* **Unique Active Customers:**
  ```sql
  SELECT COUNT(DISTINCT customer_id) AS total_sale FROM retail_sales;
  ```
* **Available Product Categories:**
  ```sql
  SELECT DISTINCT category FROM retail_sales;
  ```

---

## 🧠 Business-Key Problems & SQL Solutions

Here are the specific analytics queries written to solve explicit retail business questions:

### Q1: Sales Breakdown by Specific Calendar Date
* **Objective:** Retrieve all transaction details recorded on `2022-11-05`.
```sql
SELECT *
FROM retail_sales 
WHERE sale_date = '2022-11-05';
```

### Q2: High-Volume Clothing Sales Finder
* **Objective:** Extract all clothing transactions where the customer bought 4 or more items during November 2022.
```sql
SELECT *
FROM retail_sales 
WHERE category = 'Clothing'
  AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
  AND quantity >= 4;
```

### Q3: Total Revenue & Volume by Product Category
* **Objective:** Calculate total net revenue (`net_sale`) and total order counts for each distinct product category.
```sql
SELECT 
    category, 
    SUM(total_sale) AS net_sale,
    COUNT(*) AS total_orders 
FROM retail_sales 
GROUP BY 1;
```

### Q4: Customer Demographics for Beauty Products
* **Objective:** Find the average age of shoppers who purchased items from the 'Beauty' department.
```sql
SELECT ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';
```

### Q5: High-Value Premium Transaction Audit
* **Objective:** Find all independent invoices where the total transaction amount exceeded $1,000.
```sql
SELECT * 
FROM retail_sales 
WHERE total_sale > 1000;
```

### Q6: Departmental Transaction Split by Gender
* **Objective:** Log the total order transaction count grouped by gender roles across all product verticals.
```sql
SELECT 
    category,
    gender,
    COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY 1;
```

### Q7: Peak Monthly Revenue Performance by Year
* **Objective:** Discover the average transaction cost for every single month and identify the single highest-selling month within each calendar year.
```sql
SELECT year, month, avg_sale
FROM (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date) 
            ORDER BY AVG(total_sale) DESC
        ) AS rank 
    FROM retail_sales
    GROUP BY 1, 2
) AS t1
WHERE rank = 1;
```

### Q8: Top 5 VIP Clients (Lifetime Spending)
* **Objective:** Profile and list the top 5 highest-valued clients based on total lifetime revenue contribution.
```sql
SELECT customer_id, SUM(total_sale) AS total_sale 
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC 
LIMIT 5;
```

### Q9: Unique Customer Footprint per Sector
* **Objective:** Find the exact number of unique, individual customers who interact with each specific product category.
```sql
SELECT category, COUNT(DISTINCT customer_id) AS unique_cx 
FROM retail_sales
GROUP BY category;
```

### Q10: Hourly Order Trajectory & Shift Distribution
* **Objective:** Categorize sales timestamps into fixed operational shifts (**Morning <=12**, **Afternoon 12-17**, **Evening >17**) to pinpoint exactly when orders spike.
```sql
WITH hourly_sale AS (
    SELECT *,
        CASE 
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift 
    FROM retail_sales 
)
SELECT shift, COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;
```

---

## 📈 Summary Findings & Strategic Takeaways
* **Operational Peak Hours:** The daily shift distribution helps store managers optimize staffing windows during the highest operational transaction hours (e.g., Afternoon shifts).
* **Target Audience Alignment:** The demographic age and gender profiling allows marketing teams to deploy highly personalized promotional ads matching categorical preferences.
* **Customer Retention (VIPs):** Identifying high lifetime value (LTV) clients provides clear parameters for launch-ready, invite-only loyalty initiatives.
