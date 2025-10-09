{{ config(materialized="incremental", unique_key=["fnd_lookup_value_key"]) }}

select
  *,
  lookup_type as fnd_lookup_value_key
from {{ source("redshift_src", "fnd_lookup_values") }}
