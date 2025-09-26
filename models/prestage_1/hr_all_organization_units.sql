{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  organization_id as integration_id
from {{ source("redshift_src", "hr_all_organization_units") }}
