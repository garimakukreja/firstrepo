{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  adjustment_id as integration_id
from {{ source("ebs", "ar_adjustments_all") }}
