-- TASK PRODUCTS 
-- Task Bronze Products
CREATE OR REPLACE TASK task_bronze_products
    WAREHOUSE = COMPUTE_WH
    SCHEDULE = 'USING CRON 5 0 * * * UTC'
AS CALL load_bronze_products();

-- Task Silver Products
CREATE OR REPLACE TASK task_silver_products
    WAREHOUSE = COMPUTE_WH
    AFTER task_bronze_products
AS CALL load_silver_products();

-- Task Gold Products
CREATE OR REPLACE TASK task_gold_products
    WAREHOUSE = COMPUTE_WH
    AFTER task_silver_products
AS CALL gold_dim_customers();
