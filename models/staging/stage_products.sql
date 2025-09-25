{{ config(materialized='incremental') }}

select
    {{ oracle_nextval('staging', 'products_seq') }} as product_sk,
    product_id,
    product_name,
    product_price
from {{ source('raw', 'products') }}
