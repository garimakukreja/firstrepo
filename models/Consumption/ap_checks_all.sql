{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  check_id as integration_id
from {{ source("ebs", "ap_checks_all") }}
