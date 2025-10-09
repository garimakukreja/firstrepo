{{ config(materialized="incremental", unique_key=["per_all_assignments_f_key"]) }}

select
  *,
  assignment_id||'~'||effective_start_date||'~'||effective_end_date as per_all_assignments_f_key
from {{ source("redshift_src", "per_all_assignments_f") }}
