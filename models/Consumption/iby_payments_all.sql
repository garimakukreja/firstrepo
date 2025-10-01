{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  PAYMENT_ID as integration_id
from {{ source("redshift_src", "iby_payments_all") }}
