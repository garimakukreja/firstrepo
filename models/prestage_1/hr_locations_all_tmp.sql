{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  location_id as integration_id
from {{ source("redshift_src", "hr_locations_all_tmp") }}
