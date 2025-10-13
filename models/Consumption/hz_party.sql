{{ config(materialized="incremental", unique_key=["hz_party_key"]) }}

select
  *,
  party_id as hz_party_key
from {{ source("redshift_src", "hz_parties") }}
