/*
-------------------------------------------------------------------------------------------------------
Database Exploration
-------------------------------------------------------------------------------------------------------
Script Purpose:
    - To explore the structure of the database, including the list of tables and their schemas.
    - To inspect the columns and metadata for specific tables.
-------------------------------------------------------------------------------------------------------
*/

-- explore all objects in the database
SELECT * FROM INFORMATION_SCHEMA.TABLES

--explore all columns in the database
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_products' --view all columns of a specific table (eg. dim_products)
