{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  customer_trx_line_id as integration_id
from {{ source("ebs", "ra_customer_trx_lines_all") }}
