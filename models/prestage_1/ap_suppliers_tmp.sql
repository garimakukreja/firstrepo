{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  vendor_id as integration_id
from {{ source("redshift_src", "ap_suppliers_tmp") }}
