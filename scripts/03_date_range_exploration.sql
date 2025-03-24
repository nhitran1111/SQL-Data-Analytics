/*
---------------------------------------------------------------------------------------------------------------------------------------------------------
Date Range Exploration 
---------------------------------------------------------------------------------------------------------------------------------------------------------
Scripts purpose:
        - To determine the range of historical data.
---------------------------------------------------------------------------------------------------------------------------------------------------------
*/

-- find the date of first and last order
SELECT
MIN(order_date) AS first_order,
MAX(order_date) AS last_order,
DATEDIFF(MONTH,MIN(order_date),MAX(order_date)) AS order_range_month -- how many year of sales are available
FROM gold.fact_sales

--find the youngest and oldest customer
SELECT
MIN(birthdate) AS oldest_customer,
DATEDIFF(YEAR,MIN(birthdate),GETDATE()) AS oldest_age,
MAX(birthdate) AS youngest_customer,
DATEDIFF(YEAR,MAX(birthdate),GETDATE()) AS youngest_age
FROM gold.dim_customers
