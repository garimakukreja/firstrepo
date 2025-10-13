{{ config(materialized="incremental", unique_key=["hz_customer_site_use_key"]) }}

select
  *,
  site_use_id as hz_customer_site_use_key
from {{ source("redshift_src", "hz_cust_site_uses_all") }}
