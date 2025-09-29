{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  unit_of_measure as integration_id
from {{ source("redshift_src", "mtl_units_of_measure_tl") }}
