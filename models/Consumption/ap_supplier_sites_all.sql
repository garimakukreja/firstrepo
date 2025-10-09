{{ config(materialized="incremental", unique_key=["ap_supplier_sites_all_key"]) }}

select
  *,
  vendor_site_id as ap_supplier_sites_all_key
from {{ source("redshift_src", "ap_supplier_sites_all") }}
