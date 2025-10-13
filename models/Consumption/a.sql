{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  d as integration_id
from {{ source("ebs", "ar_adjustments_all") }}
