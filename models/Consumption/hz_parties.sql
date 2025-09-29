{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  party_id as integration_id
from {{ source("redshift_src", "hz_parties") }}
