{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  vendor_site_id as integration_id
from {{ source("redshift_src", "ap_supplier_sites_all_tmp") }}
