{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  lookup_type, lookup_code as integration_id
from {{ source("redshift_src", "fnd_lookup_values_tmp") }}
