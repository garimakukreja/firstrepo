{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  legal_entity_id as integration_id
from {{ source("ebs", "xle_entity_profiles") }}
