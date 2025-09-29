{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  adjustment_id as integration_id
from {{ source("redshift_src", "ar_adjustments_all") }}
