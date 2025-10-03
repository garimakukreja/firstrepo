{{ config(materialized="view") }}

select
  *
from {{ source("redshift_src", "hr_all_organization_units_tl") }}
