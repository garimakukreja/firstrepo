{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  id_flex_num, application_id, id_flex_code, segment_num as integration_id
from {{ source("redshift_src", "fnd_id_flex_segments") }}
