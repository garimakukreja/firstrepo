{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  registration_id as integration_id
from {{ source("redshift_src", "xle_registrations") }}
