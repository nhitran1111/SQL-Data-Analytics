/*
---------------------------------------------------------------------------------------------------------------------------------------------------------
Part-to-Whole Analysis
---------------------------------------------------------------------------------------------------------------------------------------------------------
Scripts purpose:
        - To compare metrics across dimensions or time periods to overall metrics
---------------------------------------------------------------------------------------------------------------------------------------------------------
*/

--which categories contribute the most to overall sales
WITH sales_by_cat AS
    (SELECT
    p.category,
    SUM(f.sales_amount) AS sales_amount
    FROM gold.fact_sales f LEFT JOIN gold.dim_products p 
    ON f.product_key=p.product_key
    GROUP BY p.category
    )

SELECT 
category,
sales_amount,
SUM(sales_amount) OVER() AS overal_sales,
CONCAT(ROUND((CAST(sales_amount AS FLOAT)/SUM(sales_amount) OVER())*100,2),'%') AS percentage_of_total
FROM sales_by_cat
ORDER BY sales_amount DESC
