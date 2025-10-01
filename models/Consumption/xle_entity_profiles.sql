{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  LEGAL_ENTITY_ID as integration_id
from {{ source("redshift_src", "xle_entity_profiles") }}
