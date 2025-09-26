{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  cash_receipt_id as integration_id
from {{ source("redshift_src", "ar_cash_receipts_all") }}
