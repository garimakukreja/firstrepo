{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  collector_id as integration_id
from {{ source("redshift_src", "ar_collectors") }}
