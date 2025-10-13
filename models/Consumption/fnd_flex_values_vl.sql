{{ config(materialized="incremental", unique_key=["fnd_flex_values_vl_key"]) }}

select
  *,
  flex_value_id as fnd_flex_values_vl_key
from {{ source("redshift_src", "fnd_flex_values_vl") }}
