{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  inventory_item_id||'~'||organization_id as integration_id
from {{ source("ebs", "mtl_system_items_b") }}
