{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  ['INVENTORY_ITEM_ID', 'ORGANIZATION_ID'] as integration_id
from {{ source("redshift_src", "mtl_system_items_b") }}
