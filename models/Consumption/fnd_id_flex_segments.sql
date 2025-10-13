{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  application_id||'~'||id_flex_code||'~'||id_flex_num||'~'||application_column_name as integration_id
from {{ source("ebs", "fnd_id_flex_segments") }}
