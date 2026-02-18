CREATE OR REPLACE PROCEDURE load_gold_dim_customers()
RETURNS STRING 
LANGUAGE SQL
AS

$$

BEGIN 

    TRUNCATE TABLE gold_dim_customers; 


--- Merge com Hash

merge into gold_dim_customers g 
using (
select 
            customer_id,
            company_name,
            contact_name,
            contact_title,
            address,
            city,
            postal_code,
            country,
            phone,           
            MD5(
                NVL(company_name,'')  || '|' ||
                NVL(contact_name,'')  || '|' ||
                NVL(contact_title,'') || '|' ||
                NVL(address,'')       || '|' ||
                NVL(city,'')          || '|' ||
                NVL(postal_code,'')   || '|' ||
                NVL(country,'')       || '|' ||
                NVL(phone,'')                       
            ) AS hash_diff
from silver_customers ) s

on g.customer_id = s.customer_id

when matched 
    and g.hash_diff != s.hash_diff then 
    update set 
        g.company_name = s.company_name,
        g.contact_name  = s.contact_name,
        g.contact_title = s.contact_title,
        g.address       = s.address,
        g.city          = s.city,
        g.postal_code   = s.postal_code,
        g.country       = s.country,
        g.phone         = s.phone,        
        g.hash_diff     = s.hash_diff

when not matched then 
    insert (
            customer_id,
            company_name,
            contact_name,
            contact_title,
            address,
            city,
            postal_code,
            country,
            phone,            
            hash_diff
    )
values 
    (
            s.customer_id,
            s.company_name,
            s.contact_name,
            s.contact_title,
            s.address,
            s.city,
            s.postal_code,
            s.country,
            s.phone,            
            s.hash_diff
    )

;
RETURN 'Load Gold Dim Customers table successfully';

END;

$$;
