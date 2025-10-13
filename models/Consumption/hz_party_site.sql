{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  party_site_id as integration_id
from {{ source("ebs", "hz_party_sites") }}
