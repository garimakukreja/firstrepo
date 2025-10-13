{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  u as integration_id
from {{ source("ebs", "gl_budget_versions") }}
