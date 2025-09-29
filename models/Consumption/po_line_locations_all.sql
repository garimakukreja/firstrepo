{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  line_location_id as integration_id
from {{ source("redshift_src", "po_line_locations_all") }}
