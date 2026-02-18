-- Task Gold Dim Calendar
CREATE OR REPLACE TASK task_gold_dim_calendar
    WAREHOUSE = COMPUTE_WH
    AFTER task_gold_fact_orders
AS
CALL gold_dim_calendar();
