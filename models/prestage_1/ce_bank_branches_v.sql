{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  id as integration_id
from {{ source("redshift_src", "ce_bank_branches_v") }}
