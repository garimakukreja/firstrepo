{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  term_id as integration_id
from {{ source("ebs", "ap_terms_tl") }}
