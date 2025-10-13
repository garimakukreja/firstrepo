{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  code_combination_id as integration_id
from {{ source("ebs", "gl_code_combinations") }}
