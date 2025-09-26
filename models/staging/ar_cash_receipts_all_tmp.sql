{{{{ config(
  materialized='incremental',
  unique_key='cash_receipt_id'
) }}}}

select *
from { source('redshift_src', 'ar_cash_receipts_all_tmp') }
{{% if is_incremental() %}}
  where last_update_date >= (
    select coalesce(max(last_update_date), to_timestamp('1900-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'))
    from {{ this }}
  )
{{% endif %}}
