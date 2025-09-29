{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  cust_trx_line_gl_dist_id as integration_id
from {{ source("redshift_src", "ra_cust_trx_line_gl_dist_all") }}
