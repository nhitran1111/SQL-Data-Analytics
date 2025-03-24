/*
---------------------------------------------------------------------------------------------------------------------------------------------------------
Key Metrics Exploration
---------------------------------------------------------------------------------------------------------------------------------------------------------
Scripts purpose:
         - To calculate aggregated metrics (e.g totals, averages) for quick insights.
---------------------------------------------------------------------------------------------------------------------------------------------------------
*/

--find the total sales
SELECT SUM(sales_amount) AS total_sales FROM gold.fact_sales

--find how many items are sold
SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales

--find the average selling price
SELECT AVG(price) AS avg_price FROM gold.fact_sales

--find the total number of orders
SELECT COUNT(order_number) AS total_orders FROM gold.fact_sales
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales

--find the total number of products
SELECT COUNT(product_id) AS total_products FROM gold.dim_products
SELECT COUNT(DISTINCT product_id) AS total_orders FROM gold.dim_products

--find the total number of customers
SELECT COUNT(customer_key) AS total_customers FROM gold.dim_customers
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM gold.dim_customers

-- a report shows all key metrics of the business
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity' AS measure_name, SUM(quantity) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Average Price' AS measure_name, AVG(price) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total No.Orders' AS measure_name, COUNT(DISTINCT order_number) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total No.Products' AS measure_name, COUNT(DISTINCT product_key) AS measure_value FROM gold.dim_products
UNION ALL
SELECT 'Total No.Customers' AS measure_name, COUNT(DISTINCT customer_key) AS measure_value FROM gold.dim_customers
