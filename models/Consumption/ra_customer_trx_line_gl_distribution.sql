{{ config(materialized="incremental", unique_key=["ra_customer_trx_line_gl_distribution_key"]) }}

select
  *,
  cust_trx_line_gl_dist_id as ra_customer_trx_line_gl_distribution_key
from {{ source("redshift_src", "ra_cust_trx_line_gl_dist_all") }}
