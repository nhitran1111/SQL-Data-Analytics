/* 
---------------------------------------------------------------------------------------------------------------------------------------------------------
CUSTOMER REPORT 
---------------------------------------------------------------------------------------------------------------------------------------------------------
Script purpose:
       - This report consolidates key customer metrics and behaviors

Highlights:
1. Gather essential feilds as name, age, transaction details
2. Segments customers into categories (VIP,Regular,New) and age groups.
3. Aggregate customer-level metrics:
	- Total orders
	- Total sales
	- Total quantity purchased
	- Total products
	- Lifespan (in months)
4. Calculates valuable KPIs:
	- Recency (months since last order)
	- Average orrder value
	- Average monthly spend
---------------------------------------------------------------------------------------------------------------------------------------------------------
*/

IF OBJECT_ID('gold.report_customers', 'V') IS NOT NULL
    DROP VIEW gold.report_customers;
GO
  
CREATE VIEW gold.report_customers AS

/*
==========================================================================
1) Base Query: Retrieves core columns from datasets
==========================================================================
*/ 
WITH order_info AS
    (SELECT 
    f.order_number,
    f.order_date,
    f.sales_amount,
    f.quantity,
    f.product_key,
    c.customer_key,
    c.customer_number,
    CONCAT(first_name,'',last_name) AS customer_name,
    DATEDIFF(YEAR, c.birthdate, GETDATE()) AS age
    FROM gold.fact_sales f LEFT JOIN gold.dim_customers c 
    ON f.customer_key = c.customer_key
    WHERE order_date IS NOT NULL
    )
/*
==========================================================================
2) Customer Aggregations: Summarizes key metrics at the customer level
==========================================================================
*/ 
, customer_aggregation AS
    (SELECT 
    customer_key,
    customer_number,
    customer_name,
    age,
    COUNT(DISTINCT order_number) AS total_orders,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
    MAX(order_date) AS last_order_date,
    MIN(order_date) AS first_order_date,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
    FROM order_info
    GROUP BY
    customer_key,
    customer_number,
    customer_name,
    age
    )
/*
==========================================================================
3) Customer Segmentaion: Group customers into 3 segments and calculate AOV
==========================================================================
*/ 
SELECT 
customer_key,
customer_number,
customer_name,
age,
CASE WHEN age < 20 THEN 'Under 20'
     WHEN age < 30 THEN '20-29'
	   WHEN age < 40 THEN '30-39'
	   WHEN age < 50 THEN '40-49'
	   ELSE '50 and above' 
END AS age_group,
CASE WHEN lifespan >= 12 AND total_sales >  5000 THEN 'VIP'
	   WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
	   ELSE 'New'
END AS customer_segment,
lifespan,
last_order_date,
DATEDIFF(MONTH,last_order_date,GETDATE()) AS recency,
total_orders,
total_sales,
total_quantity,
CASE WHEN total_orders = 0 THEN 0
	   ELSE total_sales/total_orders
END AS avg_order_value,
CASE WHEN lifespan = 0 THEN total_sales
	   ELSE total_sales/lifespan
END AS avg_monthly_spend
FROM customer_aggregation
