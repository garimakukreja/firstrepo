{{ config(materialized="incremental", unique_key=["hz_location_key"]) }}

select
  *,
  location_id as hz_location_key
from {{ source("redshift_src", "hz_locations") }}
