{{ config(materialized="incremental", unique_key=["application_lookup_reference_std_key"]) }}

select
  *,
  application_id as application_lookup_reference_std_key
from {{ source("redshift_src", "hr_standard_lookups") }}
