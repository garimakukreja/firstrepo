{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  registration_id as integration_id
from {{ source("ebs", "xle_registrations") }}
