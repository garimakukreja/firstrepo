{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  ORG_INFORMATION_ID as integration_id
from {{ source("redshift_src", "hr_organization_information") }}
