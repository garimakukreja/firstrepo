{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  VENDOR_SITE_ID as integration_id
from {{ source("redshift_src", "ap_supplier_sites_all") }}
