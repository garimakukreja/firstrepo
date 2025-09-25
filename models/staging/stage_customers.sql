{{ config(materialized='incremental') }}

select
    {{ oracle_nextval('staging', 'customers_seq') }} as customer_sk,
    customer_id,
    customer_name,
    customer_email
from {{ source('raw', 'customers') }}
