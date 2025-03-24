/*
---------------------------------------------------------------------------------------------------------------------------------------------------------
Change Over Time Analysis
---------------------------------------------------------------------------------------------------------------------------------------------------------
Scripts purpose:
        - To find overview insight that helps with decison-making.
        - To discover seasonality in the dataset.
        - To track change over specific periods.
---------------------------------------------------------------------------------------------------------------------------------------------------------
*/

--Changes over years (high level overview insight that helps with decison-making)
SELECT 
YEAR(order_date) AS order_year,
SUM(sales_amount) AS total_sales,
SUM(quantity) AS total_quantity,
COUNT(DISTINCT customer_key) AS total_customers,
SUM(sales_amount)/COUNT(DISTINCT customer_key) AS sale_per_customer
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date)

--Changes over months ( Details insight to discover seasonality in the dataset)
SELECT 
MONTH(order_date) AS order_month,
SUM(sales_amount) AS total_sales,
COUNT(quantity) AS total_quantity,
COUNT(DISTINCT customer_key) AS total_customers,
SUM(sales_amount)/COUNT(DISTINCT customer_key) AS sales_per_customer
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY MONTH(order_date)
ORDER BY MONTH(order_date)

--Changes over specific months in a each year 
SELECT 
DATETRUNC(MONTH,order_date) AS order_month,
SUM(sales_amount) AS total_sales,
SUM(quantity) AS total_quantity,
COUNT(DISTINCT customer_key) AS total_customers,
SUM(sales_amount)/COUNT(DISTINCT customer_key) AS sales_per_customer
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(MONTH,order_date)
ORDER BY DATETRUNC(MONTH,order_date)
