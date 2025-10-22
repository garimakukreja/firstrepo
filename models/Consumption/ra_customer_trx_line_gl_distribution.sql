{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  cust_trx_line_gl_dist_id as integration_id
from {{ source("ebs", "ra_cust_trx_line_gl_dist_all") }}
