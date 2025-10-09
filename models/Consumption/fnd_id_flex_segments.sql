{{ config(materialized="incremental", unique_key=["fnd_id_flex_segments_key"]) }}

select
  *,
  application_id||'~'||id_flex_code||'~'||id_flex_num||'~'||application_column_name as fnd_id_flex_segments_key
from {{ source("redshift_src", "fnd_id_flex_segments") }}
