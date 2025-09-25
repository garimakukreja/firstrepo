{{ config(materialized='incremental') }}

select
    {{ oracle_nextval('staging', 'orders_seq') }} as order_sk,
    order_id,
    order_date,
    customer_id
from {{ source('raw', 'orders') }}

{% if is_incremental() %}
  where order_date > (select max(order_date) from {{ this }})
{% endif %}
