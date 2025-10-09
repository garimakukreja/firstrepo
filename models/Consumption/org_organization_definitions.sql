{{ config(materialized="incremental", unique_key=["org_organization_definitions_key"]) }}

select
  *,
  organization_id as org_organization_definitions_key
from {{ source("redshift_src", "org_organization_definitions") }}
