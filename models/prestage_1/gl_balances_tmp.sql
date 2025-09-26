{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  ledger_id, code_combination_id, period_name, currency_code as integration_id
from {{ source("redshift_src", "gl_balances_tmp") }}
