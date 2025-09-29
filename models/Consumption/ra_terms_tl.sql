{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  term_id||language as integration_id
from {{ source("redshift_src", "ra_terms_tl") }}
