{{ config(materialized="incremental", unique_key=["mtl_secondary_inventories_key"]) }}

select
  *,
  secondary_inventory_name||'~'||organization_id as mtl_secondary_inventories_key
from {{ source("redshift_src", "mtl_secondary_inventories") }}
