{{ config(materialized="incremental", unique_key=["per_all_positions_key"]) }}

select
  *,
  job_id as per_all_positions_key
from {{ source("redshift_src", "per_all_positions") }}
