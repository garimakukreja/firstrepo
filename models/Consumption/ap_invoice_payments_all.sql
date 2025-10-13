{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  invoice_payment_id as integration_id
from {{ source("ebs", "ap_invoice_payments_all") }}
