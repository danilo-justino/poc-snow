-- PROCEDURE SILVER ORDERS DETAILS

CREATE OR REPLACE PROCEDURE load_silver_orders_details()
RETURNS STRING
LANGUAGE SQL
AS
$$

BEGIN
    TRUNCATE TABLE SILVER_ORDERS_DETAILS;

    INSERT INTO SILVER_ORDERS_DETAILS
    Select
        $1:"order_id"::NUMBER                                          AS order_id,
        $1:"product_id"::NUMBER                                        AS product_id,
        $1:"quantity"::NUMBER                                          AS quantity,
        $1:"unit_price"::FLOAT                                         AS unit_price,
        $1:"discount"::FLOAT                                           AS discount,
        ($1:"quantity"::NUMBER * $1:"unit_price"::FLOAT)               AS total,  
        CURRENT_TIMESTAMP()                                            AS created_at  
    from BRONZE_ORDERS_DETAILS;

     RETURN 'Load Silver Orders Details table successfully';
END;
$$;
