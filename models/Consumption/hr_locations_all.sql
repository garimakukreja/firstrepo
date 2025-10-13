{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  location_id as integration_id
from {{ source("ebs", "hr_locations_all") }}
