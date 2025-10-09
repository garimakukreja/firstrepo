{{ config(materialized="incremental", unique_key=["ra_customer_trx_line_key"]) }}

select
  *,
  customer_trx_line_id as ra_customer_trx_line_key
from {{ source("redshift_src", "ra_customer_trx_lines_all") }}
