{{ config(materialized="incremental", unique_key=["organization_unit_key"]) }}

select
  *,
  organization_id as organization_unit_key
from {{ source("redshift_src", "hr_all_organization_units") }}
