{{ config(materialized="incremental", unique_key=["per_jobs_key"]) }}

select
  *,
  job_id as per_jobs_key
from {{ source("redshift_src", "per_jobs") }}
