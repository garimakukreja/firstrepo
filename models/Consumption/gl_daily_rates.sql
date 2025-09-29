{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  batch_id as integration_id
from {{ source("redshift_src", "gl_daily_rates") }}
