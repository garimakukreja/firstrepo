{{ config(materialized="incremental", unique_key=["mtl_categories_b_key"]) }}

select
  *,
  category_id as mtl_categories_b_key
from {{ source("redshift_src", "mtl_categories_b") }}
