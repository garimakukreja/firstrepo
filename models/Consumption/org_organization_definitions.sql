{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  ABC as integration_id
from {{ source("redshift_src", "org_organization_definitions") }}
