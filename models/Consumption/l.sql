{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  i as integration_id
from {{ source("ebs", "po_line_locations_all") }}
