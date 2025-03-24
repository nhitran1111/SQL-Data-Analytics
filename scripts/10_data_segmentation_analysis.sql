/*
---------------------------------------------------------------------------------------------------------------------------------------------------------
Data Segmentation Analysis
---------------------------------------------------------------------------------------------------------------------------------------------------------
Scripts purpose:
        - To segment customer into meaningful groups for targeted insights.

Assumption:
        Group customers into three segment based on their spending behavior
	- VIP: customers with at least 12 months of history and spending more than 5000
	- Regular: customers with at least 12 months of history and spending 5000 or less
	- New: customers with a lifespan less than 12 months
---------------------------------------------------------------------------------------------------------------------------------------------------------
*/

--find the total number of customers by each group
*/
WITH customer_spending AS
     (SELECT 
      c.customer_key,
      SUM(f.sales_amount) AS total_spending,
      MIN(f.order_date) AS first_order,
      MAX(order_date) AS last_order,
      DATEDIFF(MONTH,MIN(order_date), MAX(order_date)) AS lifespan
      FROM gold.fact_sales f LEFT JOIN gold.dim_customers c ON f.customer_key=c.customer_key
      GROUP BY c.customer_key
      )

, customer_segment AS
     (SELECT
      customer_key,
      CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
           WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
           ELSE 'New' 
      END AS customer_segment
      FROM customer_spending
      )

SELECT
customer_segment,
COUNT(customer_key) AS total_customers
FROM customer_segment
GROUP BY customer_segment
ORDER BY COUNT(customer_key) DESC
