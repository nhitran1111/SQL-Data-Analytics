/*
---------------------------------------------------------------------------------------------------------------------------------------------------------
Cumulative Analysis
---------------------------------------------------------------------------------------------------------------------------------------------------------
Scripts purpose:
        - To track performance over time cumulatively.
---------------------------------------------------------------------------------------------------------------------------------------------------------
*/

--running total of sales over months (the running total sale reset in the first month of the years)
WITH salesbymonth AS
(
SELECT 
DATETRUNC(MONTH,order_date) AS order_month,
SUM(sales_amount) AS total_sales,
SUM(quantity) AS total_quantity,
COUNT(DISTINCT customer_key) AS total_customers
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH, order_date)
)

SELECT 
order_month,
total_sales,
total_quantity,
total_customers,
SUM(total_sales) OVER (PARTITION BY YEAR(order_month) ORDER BY order_month) AS running_total_sales,
SUM(total_quantity) OVER (PARTITION BY YEAR(order_month) ORDER BY order_month) AS running_total_quantity
FROM salesbymonth
