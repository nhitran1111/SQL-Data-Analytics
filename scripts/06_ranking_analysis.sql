/*
---------------------------------------------------------------------------------------------------------------------------------------------------------
Ranking Analysis
---------------------------------------------------------------------------------------------------------------------------------------------------------
Scripts purpose:
       - To identify top performers based on specific metrics.
---------------------------------------------------------------------------------------------------------------------------------------------------------
*/

--top 5 products generated the highest revenue
SELECT TOP 5
p.product_name,
SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f LEFT JOIN gold.dim_products p
ON f.product_key=p.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC

--find the 5 worst-performing product in the terms of sales
SELECT TOP 5
p.product_name,
SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f LEFT JOIN gold.dim_products p
ON f.product_key=p.product_key
GROUP BY p.product_name
ORDER BY total_revenue 

--find top 10 cusotmers who have generated the highest revenue 
SELECT TOP 10
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

-- 3 customers with the fewest orders placed
SELECT TOP 5
c.customer_key,
c.first_name,
c.last_name,
COUNT(DISTINCT f.order_number) AS total_orders_placed
FROM gold.fact_sales f LEFT JOIN gold.dim_customers c
ON f.customer_key=c.customer_key
GROUP BY 
c.customer_key,
c.first_name,
c.last_name
ORDER BY total_orders_placed
