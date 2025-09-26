{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  code_combination_id as integration_id
from {{ source("redshift_src", "gl_code_combinations_tmp") }}
