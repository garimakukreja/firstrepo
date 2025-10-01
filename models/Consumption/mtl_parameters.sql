{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  ORGANIZATION_ID as integration_id
from {{ source("redshift_src", "mtl_parameters") }}
