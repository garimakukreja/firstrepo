{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  hold_lookup_code as integration_id
from {{ source("ebs", "ap_hold_codes") }}
