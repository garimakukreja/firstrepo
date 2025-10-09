{{ config(materialized="incremental", unique_key=["organization_information_key"]) }}

select
  *,
  organization_id||'~'||language as organization_information_key
from {{ source("redshift_src", "hr_organization_information") }}
