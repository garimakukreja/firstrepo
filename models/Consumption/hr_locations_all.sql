{{ config(materialized="incremental", unique_key=["hr_locations_all_key"]) }}

select
  *,
  location_id as hr_locations_all_key
from {{ source("redshift_src", "hr_locations_all") }}
