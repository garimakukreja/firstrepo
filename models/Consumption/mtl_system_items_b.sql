{{ config(materialized="view", unique_key="integration_id") }}

select
    *,
    -- ✅ Explicitly cast all components as VARCHAR and concatenate safely using ||
    CAST(INVENTORY_ITEM_ID AS VARCHAR) 
    || '~' || 
    CAST(ORGANIZATION_ID AS VARCHAR) 
    AS integration_id
from {{ source("redshift_src", "mtl_system_items_b") }}
