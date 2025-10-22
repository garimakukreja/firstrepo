{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  budget_version_id as integration_id
from {{ source("ebs", "gl_budget_versions") }}
