{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  lookup_code as integration_id
from {{ source("redshift_src", "fnd_lookup_values") }}
