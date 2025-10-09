{{ config(materialized="incremental", unique_key=["person_key"]) }}

select
  *,
  person_id||'~'||effective_start_date||'~'||effective_end_date as person_key
from {{ source("redshift_src", "per_all_people_f") }}
