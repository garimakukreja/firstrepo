{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  batch_source_id as integration_id
from {{ source("redshift_src", "ra_batch_sources_all") }}
