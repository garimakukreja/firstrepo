{{{{ config(
  materialized='incremental',
  unique_key='flex_value_id'
) }}}}

select *
from { source('redshift_src', 'fnd_flex_values_vl') }
{{% if is_incremental() %}}
  where last_update_date >= (
    select coalesce(max(last_update_date), to_timestamp('1900-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'))
    from {{ this }}
  )
{{% endif %}}
