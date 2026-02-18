-- TASK ORDERS DETAILS
-- Task Bronze Orders Details
CREATE OR REPLACE TASK task_bronze_orders_details
    WAREHOUSE = COMPUTE_WH
    SCHEDULE = 'USING CRON 5 0 * * * UTC'
AS CALL load_bronze_orders_details();

-- Task Silver Orders Details
CREATE OR REPLACE TASK task_silver_orders_details
    WAREHOUSE = COMPUTE_WH
    AFTER task_bronze_orders_details
AS CALL load_silver_orders_details();
