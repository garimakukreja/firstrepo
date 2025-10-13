{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  batch_id as integration_id
from {{ source("ebs", "ap_batches_all") }}
