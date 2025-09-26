{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  term_id as integration_id
from {{ source("redshift_src", "ap_terms_vl") }}
