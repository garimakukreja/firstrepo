{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  line_id as integration_id
from {{ source("redshift_src", "oe_order_lines_all_tmp") }}
