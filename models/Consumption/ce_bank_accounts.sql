{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  bank_account_id as integration_id
from {{ source("ebs", "ce_bank_accounts") }}
