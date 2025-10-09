{{ config(materialized="incremental", unique_key=["hr_operating_units_key"]) }}

select
  *,
  organization_id as hr_operating_units_key
from {{ source("redshift_src", "hr_operating_units") }}
