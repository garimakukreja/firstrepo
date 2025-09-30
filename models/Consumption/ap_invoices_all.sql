{{ config(materialized="view") }}

select
  *,
  invoice_id as integration_id
from {{ source("redshift_src", "ap_invoices_all") }}
