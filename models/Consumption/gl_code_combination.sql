{{ config(materialized="incremental", unique_key=["gl_code_combination_key"]) }}

select
  *,
  code_combination_id as gl_code_combination_key
from {{ source("redshift_src", "gl_code_combinations") }}
