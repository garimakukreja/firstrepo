{{{{ config(
  materialized='incremental',
  unique_key=['ledger_id','code_combination_id','period_name','currency_code']
) }}}}

select *
from { source('redshift_src', 'gl_balances') }
{{% if is_incremental() %}}
  where last_update_date >= (
    select coalesce(max(last_update_date), to_timestamp('1900-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'))
    from {{ this }}
  )
{{% endif %}}
