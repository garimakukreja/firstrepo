{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  shipment_line_id as integration_id
from {{ source("redshift_src", "rcv_shipment_lines") }}
