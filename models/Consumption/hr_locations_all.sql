{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  LOCATION_ID as integration_id
from {{ source("redshift_src", "hr_locations_all") }}
