{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  ['PERIOD_SET_NAME', 'PERIOD_NAME', 'PERIOD_TYPE'] as integration_id
from {{ source("redshift_src", "gl_periods") }}
