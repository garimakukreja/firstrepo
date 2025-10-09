{{ config(materialized="incremental", unique_key=["xle_entity_profiles_key"]) }}

select
  *,
  legal_entity_id as xle_entity_profiles_key
from {{ source("redshift_src", "xle_entity_profiles") }}
