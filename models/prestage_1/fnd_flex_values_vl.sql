{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  flex_value_id as integration_id
from {{ source("redshift_src", "fnd_flex_values_vl") }}
