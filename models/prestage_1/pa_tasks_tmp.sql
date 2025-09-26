{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  task_id as integration_id
from {{ source("redshift_src", "pa_tasks_tmp") }}
