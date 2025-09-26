{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  project_id as integration_id
from {{ source("redshift_src", "pa_projects_all_tmp") }}
