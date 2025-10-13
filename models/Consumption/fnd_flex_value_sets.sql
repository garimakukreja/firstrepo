{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  flex_value_set_id as integration_id
from {{ source("ebs", "fnd_flex_value_sets") }}
