{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  a as integration_id
from {{ source("ebs", "ap_batches_all") }}
