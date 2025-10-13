{{ config(materialized="incremental", unique_key=["material_parameter_key"]) }}

select
  *,
  organization_id as material_parameter_key
from {{ source("redshift_src", "mtl_parameters") }}
