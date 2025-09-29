{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  invoice_payment_id as integration_id
from {{ source("redshift_src", "ap_invoice_payments_all") }}
