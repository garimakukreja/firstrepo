{{{{ config(
  materialized='incremental',
  unique_key='batch_id'
) }}}}

select *
from `dev.staging.staging.ap_batches_all`
{% if is_incremental() %}
  where LASTUPDATEDATE >= (
    select coalesce(max(LASTUPDATEDATE), timestamp('1900-01-01 00:00:00'))
    from {{ this }}
  )
{% endif %}
