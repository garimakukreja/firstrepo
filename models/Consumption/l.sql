{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  o as integration_id
from {{ source("ebs", "fnd_lookup_values") }}
