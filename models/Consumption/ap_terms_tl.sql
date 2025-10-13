{{ config(materialized="incremental", unique_key=["ap_terms_tl_key"]) }}

select
  *,
  term_id||'~'||language as ap_terms_tl_key
from {{ source("redshift_src", "ap_terms_tl") }}
