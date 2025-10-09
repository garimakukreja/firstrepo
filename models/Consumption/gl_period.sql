{{ config(materialized="incremental", unique_key=["gl_period_key"]) }}

select
  *,
  period_set_name||'~'||period_name as gl_period_key
from {{ source("redshift_src", "gl_periods") }}
