-- TASK ORDERS 
-- Task Bronze Orders 
CREATE OR REPLACE TASK task_bronze_orders
    WAREHOUSE = COMPUTE_WH
    SCHEDULE = 'USING CRON 5 0 * * * UTC'
AS CALL load_bronze_orders();

-- Task Silver Orders 
CREATE OR REPLACE TASK task_silver_orders
    WAREHOUSE = COMPUTE_WH
    AFTER task_bronze_orders
AS CALL task_silver_orders();

-- Task Gold Orders
CREATE OR REPLACE TASK task_gold_fact_orders
    WAREHOUSE = COMPUTE_WH
    AFTER task_silver_orders,
          task_silver_orders_details
AS CALL task_gold_fact_orders();
