{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  VENDOR_ID as integration_id
from {{ source("redshift_src", "ap_suppliers") }}
