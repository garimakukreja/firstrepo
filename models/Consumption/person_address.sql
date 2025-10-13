{{ config(materialized="incremental", unique_key=["person_address_key"]) }}

select
  *,
  address_id as person_address_key
from {{ source("redshift_src", "per_addresses") }}
