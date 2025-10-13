{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  organization_id||'~'||language as integration_id
from {{ source("ebs", "hr_all_organization_units_tl") }}
