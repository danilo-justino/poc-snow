-- PROCEDURE GOLD TABLE PRODUCTS

CREATE OR REPLACE PROCEDURE gold_dim_products()
RETURNS STRING
LANGUAGE SQL
AS
$$

BEGIN

merge into GOLD_DIM_PRODUCTS AS p 
using (
    select        
        product_id,
        product_name ,
        supplier_id ,
        category_id ,
        quantity_per_unit,
        unit_price,
        units_in_stock,
        units_on_order,
        reorder_level,
        discontinued,
        MD5(
            NVL(product_name, '')              || '|' ||
            NVL(TO_CHAR(supplier_id), '')      || '|' ||
            NVL(TO_CHAR(category_id), '')      || '|' ||
            NVL(quantity_per_unit, '')         || '|' ||
            NVL(TO_CHAR(unit_price), '')       || '|' ||
            NVL(TO_CHAR(units_in_stock), '')   || '|' ||
            NVL(TO_CHAR(units_on_order), '')   || '|' ||
            NVL(TO_CHAR(reorder_level), '')    || '|' ||
            NVL(TO_CHAR(discontinued), '')
        ) AS hash_diff
         
    from SILVER_PRODUCTS
) AS s
ON p.product_id = s.product_id

WHEN MATCHED 
        AND p.hash_diff != s.hash_diff THEN
        UPDATE SET 
        p.product_id        = s.product_id,
        p.product_name      = s.product_name,
        p.supplier_id       = s.supplier_id,
        p.category_id       = s.category_id,
        p.quantity_per_unit = s.quantity_per_unit,
        p.unit_price        = s.unit_price,
        p.units_in_stock    = s.units_in_stock,
        p.units_on_order    = s.units_on_order,
        p.reorder_level     = s.reorder_level,
        p.discontinued      = s.discontinued,
        p.hash_diff         = s.hash_diff

 WHEN NOT MATCHED THEN
        INSERT(
            product_id,
            product_name ,
            supplier_id ,
            category_id ,
            quantity_per_unit,
            unit_price,
            units_in_stock,
            units_on_order,
            reorder_level,
            discontinued,
            hash_diff
        )
        VALUES(
            s.product_id,
            s.product_name,
            s.supplier_id,
            s.category_id,
            s.quantity_per_unit,
            s.unit_price,
            s.units_in_stock,
            s.units_on_order,
            s.reorder_level,
            s.discontinued,
            s.hash_diff
        )
;

        Return 'Load Gold Dim Products table successfully';

    END;
    $$;
