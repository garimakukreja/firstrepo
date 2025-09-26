{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  hold_code as integration_id
from {{ source("redshift_src", "ap_hold_codes") }}
