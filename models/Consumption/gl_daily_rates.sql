{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  CAST(from_currency AS VARCHAR) || '~' ||
  CAST(to_currency AS VARCHAR) || '~' ||
  TO_CHAR(conversion_date, 'YYYYMMDD') || '~' ||
  CAST(conversion_type AS VARCHAR) AS integration_id
from {{ source("redshift_src", "gl_daily_rates") }}
