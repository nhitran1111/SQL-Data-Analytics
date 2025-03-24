/*
---------------------------------------------------------------------------------------------------------------------------------------------------------
PRODUCT REPORT
---------------------------------------------------------------------------------------------------------------------------------------------------------
Script purpose:
	    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
		  - Total orders
      - Total sales
		  - Total quantity sold
		  - Total customers (unique)
		  - Lifespan (in months)
    4. Calculates valuable KPIs:
      - recency (months since last sale)
      - average order revenue (AOR)
      -  average monthly revenue
---------------------------------------------------------------------------------------------------------------------------------------------------------
*/
IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
    DROP VIEW gold.report_products;
GO

CREATE VIEW gold.report_products AS
/*
==========================================================================
1) Base Query: Retrieves core columns from datasets
==========================================================================
*/ 
WITH order_info AS
    (SELECT
    f.order_number,
    f.order_date,
    f.customer_key,
    f.sales_amount,
    f.quantity,
    p.product_key,
    p.product_name,
    p.category,
    p.subcategory,
    p.cost
    FROM gold.fact_sales f LEFT JOIN gold.dim_products p
    ON f.product_key = p.product_key
    WHERE order_date IS NOT NULL
    )
/*
==========================================================================
2) Product Aggregations: Summarizes key metrics at the product level
==========================================================================
*/ 
, product_aggregation AS
    (SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan,
    MAX(order_date) AS last_order_date,
    COUNT(DISTINCT order_number) AS total_orders,
    COUNT(DISTINCT customer_key) AS total_customer,
    SUM(sales_amount) AS total_sales,
    SUM(quantity) AS total_quantity,
    ROUND(AVG(CAST(sales_amount AS FLOAT)/NULLIF(quantity,0)),1) AS avg_selling_price
    FROM order_info
    GROUP BY 
    product_key,
    product_name,
    category,
    subcategory,
    cost
    )
/*
============================================================================
3) Product Segmentation: Group product into 3 segments based on their
   performance and calculate AOR
============================================================================
*/ 
SELECT
product_key,
product_name,
category,
subcategory,
cost,
last_order_date,
DATEDIFF(MONTH,last_order_date, GETDATE()) AS recency_in_months,
CASE WHEN total_sales > 50000 THEN 'High-Performer'
	   WHEN total_sales >= 10000 THEN 'Mid-Range'
	   ELSE 'Low-Performer'
END AS product_segment,
lifespan,
total_orders,
total_sales,
total_quantity,
total_customer,
avg_selling_price,
CASE WHEN total_orders = 0 THEN 0
	   ELSE total_sales/total_orders
END AS avg_order_revenue,
CASE WHEN lifespan = 0 THEN total_sales
	   ELSE total_sales/lifespan
END AS avg_monthly_revenue
FROM product_aggregation
