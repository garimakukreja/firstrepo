{{ config(materialized="incremental", unique_key=["ra_customer_trx_key"]) }}

select
  *,
  customer_trx_id as ra_customer_trx_key
from {{ source("redshift_src", "ra_customer_trx_all") }}
