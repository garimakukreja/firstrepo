{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  id as integration_id
from {{ source("redshift_src", "po_distributions_all_all_tmp") }}
