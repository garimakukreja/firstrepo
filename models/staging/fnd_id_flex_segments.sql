{{{{ config(
  materialized='incremental',
  unique_key=['id_flex_num','application_id','id_flex_code','segment_num']
) }}}}

select *
from { source('redshift_src', 'fnd_id_flex_segments') }
{{% if is_incremental() %}}
  where last_update_date >= (
    select coalesce(max(last_update_date), to_timestamp('1900-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'))
    from {{ this }}
  )
{{% endif %}}
