{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  ['ORGANIZATION_ID', 'LANGUAGE'] as integration_id
from {{ source("redshift_src", "hr_all_organization_units_tl") }}
