{{ config(materialized="incremental", unique_key=["fnd_flex_value_sets_key"]) }}

select
  *,
  flex_value_set_id as fnd_flex_value_sets_key
from {{ source("redshift_src", "fnd_flex_value_sets") }}
