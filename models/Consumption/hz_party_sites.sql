{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  party_site_id as integration_id
from {{ source("redshift_src", "hz_party_sites") }}
