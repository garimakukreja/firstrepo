{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  lookup_code as integration_id
from {{ source("ebs", "ap_lookup_codes") }}
