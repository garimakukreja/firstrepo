{{ config(materialized="view", unique_key="integration_id") }}

select
  *
from {{ source("redshift_src", "org_organization_definitions") }}
