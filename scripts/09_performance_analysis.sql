/*
---------------------------------------------------------------------------------------------------------------------------------------------------------
Performance Analysis
---------------------------------------------------------------------------------------------------------------------------------------------------------
Scripts purpose:
        - To calculate the performance of specific dimensions over time and track periodic trends
---------------------------------------------------------------------------------------------------------------------------------------------------------
*/

--analyze yearly performance of products by comparing their sales to both the average sales performance of the product and the previous year's sales
WITH yearly_product_sales AS
    (SELECT
     YEAR(f.order_date) as order_year,
     SUM(f.sales_amount) AS current_sales,
     p.product_name
     FROM gold.fact_sales f LEFT JOIN gold.dim_products p ON f.product_key=p.product_key
     WHERE order_date IS NOT NULL
     GROUP BY YEAR(f.order_date), p.product_name
    )

SELECT 
order_year,
product_name,
current_sales,
AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg,
CASE WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above average'
	 WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below avergae'
	 ELSE 'Average' 
END AS avg_change,
LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS py_sales,
current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS diff_py, 
CASE WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
	 WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
	 ELSE 'No change' 
END AS py_change
FROM yearly_product_sales
ORDER BY product_name, order_year
