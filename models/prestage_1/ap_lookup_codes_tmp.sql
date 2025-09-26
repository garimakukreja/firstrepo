{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  lookup_code as integration_id
from {{ source("redshift_src", "ap_lookup_codes_tmp") }}
