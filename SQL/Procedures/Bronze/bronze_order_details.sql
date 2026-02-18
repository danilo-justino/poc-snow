-- PROCEDURE BRONZE ORDERS DETAILS

CREATE OR REPLACE PROCEDURE load_bronze_orders_details()
RETURNS STRING
LANGUAGE SQL
AS
$$

BEGIN

    COPY INTO BRONZE_ORDERS_DETAILS (raw_data, filename, created_at)
        FROM (
            SELECT
                Cast($1 as variant) AS raw_data,                               -- conteúdo do parquet
                METADATA$FILENAME AS filename,                -- nome do arquivo
                CURRENT_TIMESTAMP() AS created_at             -- timestamp de carga
            FROM @PUBLIC.NORTH/orders_details/ 
        )
        FILE_FORMAT = (FORMAT_NAME = 'PARQUET_FORMAT');

        RETURN 'Load Bronze Orders Details table successfully';
END;
$$;
