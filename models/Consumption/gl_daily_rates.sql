{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  ['FROM_CURRENCY', 'TO_CURRENCY', 'CONVERSION_DATE', 'CONVERSION_TYPE'] as integration_id
from {{ source("redshift_src", "gl_daily_rates") }}
