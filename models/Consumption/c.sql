{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  h as integration_id
from {{ source("ebs", "ap_checks_all") }}
