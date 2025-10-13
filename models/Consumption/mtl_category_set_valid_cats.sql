{{ config(materialized="incremental", unique_key=["mtl_category_set_valid_cats_key"]) }}

select
  *,
  category_set_id||'~'||category_id as mtl_category_set_valid_cats_key
from {{ source("redshift_src", "mtl_category_set_valid_cats") }}
