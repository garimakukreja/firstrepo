{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  legal_entity_id as integration_id
from {{ source("redshift_src", "xle_entity_profiles_tmp") }}
