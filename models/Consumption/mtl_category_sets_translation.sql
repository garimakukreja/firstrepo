{{ config(materialized="incremental", unique_key=["mtl_category_sets_translation_key"]) }}

select
  *,
  category_set_id||'~'||language as mtl_category_sets_translation_key
from {{ source("redshift_src", "mtl_category_sets_tl") }}
