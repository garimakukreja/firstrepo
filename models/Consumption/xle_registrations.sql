{{ config(materialized="incremental", unique_key=["xle_registrations_key"]) }}

select
  *,
  registration_id as xle_registrations_key
from {{ source("redshift_src", "xle_registrations") }}
