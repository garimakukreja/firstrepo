{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  batch_source_id as integration_id
from {{ source("ebs", "ra_batch_sources_all") }}
