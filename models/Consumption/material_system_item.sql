{{ config(materialized="incremental", unique_key=["material_system_item_key"]) }}

select
  *,
  inventory_item_id||'~'||organization_id as material_system_item_key
from {{ source("redshift_src", "mtl_system_items_b") }}
