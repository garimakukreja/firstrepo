{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  org_information_id as integration_id
from {{ source("ebs", "hr_organization_information") }}
