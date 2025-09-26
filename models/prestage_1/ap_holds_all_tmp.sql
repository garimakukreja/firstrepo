{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  hold_id as integration_id
from {{ source("redshift_src", "ap_holds_all_tmp") }}
