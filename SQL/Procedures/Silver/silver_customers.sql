-- Procedure Silver_Customers

CREATE OR REPLACE PROCEDURE load_silver_customers()
RETURNS STRING 
LANGUAGE SQL
AS

$$

BEGIN 

    TRUNCATE TABLE SILVER_CUSTOMERS;

-- Insere dados na tabela
    insert into SILVER_CUSTOMERS
        select 
            coalesce(upper($1:"customer_id"::string), 'N/A')                     as customer_id,
            coalesce(upper($1:"company_name"::string), 'N/A')                    as company_name,
            coalesce(upper($1:"contact_name"::string), 'N/A')                    as contact_name,
            coalesce(upper($1:"contact_title"::string), 'N/A')                   as contact_title,
            coalesce(upper($1:"country"::string), 'N/A')                         as country,
            coalesce(upper($1:"city"::string), 'N/A')                            as city,
            coalesce(upper($1:"address"::string), 'N/A')                         as address,
            coalesce(upper($1:"phone"::string), 'N/A')                           as phone,
            coalesce(upper($1:"postal_code"::string), 'N/A')                     as postal_code,
            filename,
            current_timestamp as created_at
            --current_user     
        from bronze_customers;

        RETURN 'Load Silver Customers table successfully';
END;
$$;
