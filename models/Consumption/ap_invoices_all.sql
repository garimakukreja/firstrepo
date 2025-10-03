{{ config(materialized="view", unique_key="integration_id") }}

select
  *
from {{ source("redshift_src", "ap_invoices_all") }}
