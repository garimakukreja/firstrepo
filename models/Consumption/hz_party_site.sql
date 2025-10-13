{{ config(materialized="incremental", unique_key=["hz_party_site_key"]) }}

select
  *,
  party_site_id as hz_party_site_key
from {{ source("redshift_src", "hz_party_sites") }}
