{{ config(materialized="incremental", unique_key=["gl_daily_rate_key"]) }}

select
  *,
  from_currency||'~'||to_currency||'~'||conversion_date||'~'||conversion_type as gl_daily_rate_key
from {{ source("redshift_src", "gl_daily_rates") }}
