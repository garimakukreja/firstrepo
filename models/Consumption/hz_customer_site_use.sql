{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  site_use_id as integration_id
from {{ source("ebs", "hz_cust_site_uses_all") }}
