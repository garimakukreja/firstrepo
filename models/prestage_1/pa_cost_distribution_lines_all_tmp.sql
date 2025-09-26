{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  id as integration_id
from {{ source("redshift_src", "pa_cost_distribution_lines_all_tmp") }}
