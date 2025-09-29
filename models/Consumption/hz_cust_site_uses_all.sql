{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  site_use_id as integration_id
from {{ source("redshift_src", "hz_cust_site_uses_all") }}
