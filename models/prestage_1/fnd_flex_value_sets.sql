{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  flex_value_set_id as integration_id
from {{ source("redshift_src", "fnd_flex_value_sets") }}
