{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  from_currency||'~'||to_currency||'~'||conversion_date||'~'||conversion_type as integration_id
from {{ source("ebs", "gl_daily_rates") }}
