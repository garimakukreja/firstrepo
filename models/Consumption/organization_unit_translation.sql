{{ config(materialized="incremental", unique_key=["organization_unit_translation_key"]) }}

select
  *,
  organization_id||'~'||language as organization_unit_translation_key
from {{ source("redshift_src", "hr_all_organization_units_tl") }}
