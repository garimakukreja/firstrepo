{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  collector_id as integration_id
from {{ source("ebs", "ar_collectors") }}
