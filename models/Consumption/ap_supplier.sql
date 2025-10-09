{{ config(materialized="incremental", unique_key=["ap_supplier_key"]) }}

select
  *,
  vendor_id as ap_supplier_key
from {{ source("redshift_src", "ap_suppliers") }}
