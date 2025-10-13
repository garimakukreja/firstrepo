{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  line_location_id as integration_id
from {{ source("ebs", "po_line_locations_all") }}
