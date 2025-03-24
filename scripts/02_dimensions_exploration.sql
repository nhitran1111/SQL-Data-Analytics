/*
---------------------------------------------------------------------------------------------------------------------------------------------------------
Dimensions Exploration
---------------------------------------------------------------------------------------------------------------------------------------------------------
Scripts purpose:
        - To explore the structure of dimension tables.
---------------------------------------------------------------------------------------------------------------------------------------------------------
*/

--explore all countries our customers come from
SELECT DISTINCT country 
FROM gold.dim_customers

--explore all categpories of the products
SELECT DISTINCT category,subcategory,product_name 
FROM gold.dim_products
ORDER BY 1,2,3
