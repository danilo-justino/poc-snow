-- TASK CUSTOMERS 
-- Task Bronze Customers
CREATE OR REPLACE TASK task_bronze_customers
    WAREHOUSE = COMPUTE_WH
    SCHEDULE = 'USING CRON 5 0 * * * UTC'
AS CALL load_bronze_customers();


-- Task Silver Customers
CREATE OR REPLACE TASK task_silver_customers
    WAREHOUSE = COMPUTE_WH
    AFTER task_bronze_customers
AS CALL load_silver_customers();

-- Task Gold Customers
CREATE OR REPLACE TASK task_gold_customers
    WAREHOUSE = COMPUTE_WH
    AFTER task_silver_customers
AS CALL load_gold_dim_customers();
