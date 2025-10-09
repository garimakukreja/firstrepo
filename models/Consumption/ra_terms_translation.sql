{{ config(materialized="incremental", unique_key=["ra_terms_translation_key"]) }}

select
  *,
  term_id as ra_terms_translation_key
from {{ source("redshift_src", "ra_terms_tl") }}
