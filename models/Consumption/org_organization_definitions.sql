{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  organization_id as integration_id
from {{ source("ebs", "org_organization_definitions") }}
