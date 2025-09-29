{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  invoice_id as integration_id
from {{ source("redshift_src", "ap_payment_schedules_all") }}
