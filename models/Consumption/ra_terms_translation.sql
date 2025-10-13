{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  term_id||language as integration_id
from {{ source("ebs", "ra_terms_tl") }}
