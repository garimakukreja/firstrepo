{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  bank_account_id as integration_id
from {{ source("redshift_src", "ce_bank_accounts") }}
