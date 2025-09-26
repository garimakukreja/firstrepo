{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  header_id as integration_id
from {{ source("redshift_src", "oe_order_headers_all") }}
