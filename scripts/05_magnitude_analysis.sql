/*
---------------------------------------------------------------------------------------------------------------------------------------------------------
Magnitude Analysis
---------------------------------------------------------------------------------------------------------------------------------------------------------
Scripts purpose:
        - To quantify data and group results by specific dimensions.
---------------------------------------------------------------------------------------------------------------------------------------------------------
*/

--find total customers by countries
SELECT 
country,
COUNT(DISTINCT customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY COUNT(DISTINCT customer_key) DESC

--find total customer by genders
SELECT 
gender,
COUNT(DISTINCT customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY COUNT(DISTINCT customer_key) DESC

--find total product by category
SELECT 
category,
COUNT(DISTINCT product_key) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY COUNT(DISTINCT product_key) DESC

--find the average cost in each category
SELECT 
category,
AVG(cost) AS avg_cost
FROM gold.dim_products
GROUP BY category
ORDER BY AVG(cost) DESC

--find the total revenue generated for each category
SELECT
p.category,
SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f LEFT JOIN gold.dim_products p
ON f.product_key=p.product_key
GROUP BY p.category
ORDER BY total_revenue DESC

--find the total revenue generated for each customer
SELECT
c.customer_key,
c.first_name,
c.last_name,
SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f LEFT JOIN gold.dim_customers c
ON f.customer_key=c.customer_key
GROUP BY 
c.customer_key,
c.first_name,
c.last_name
ORDER BY total_revenue DESC

--find the distribution of sold items across countries
SELECT
c.country,
SUM(quantity) AS total_sold_items
FROM gold.fact_sales f LEFT JOIN gold.dim_customers c
ON f.product_key=c.customer_key
GROUP BY c.country
ORDER BY total_sold_items DESC
