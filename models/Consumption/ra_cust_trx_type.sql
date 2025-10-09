{{ config(materialized="incremental", unique_key=["ra_cust_trx_type_key"]) }}

select
  *,
  cust_trx_type_id as ra_cust_trx_type_key
from {{ source("redshift_src", "ra_cust_trx_types_all") }}
