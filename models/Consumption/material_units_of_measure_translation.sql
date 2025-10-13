{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  unit_of_measure as integration_id
from {{ source("ebs", "mtl_units_of_measure_tl") }}
