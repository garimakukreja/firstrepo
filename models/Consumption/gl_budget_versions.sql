{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  BUDGET_VERSION_ID as integration_id
from {{ source("redshift_src", "gl_budget_versions") }}
