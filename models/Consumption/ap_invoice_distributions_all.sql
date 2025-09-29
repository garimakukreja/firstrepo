{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  distribution_line_number as integration_id
from {{ source("redshift_src", "ap_invoice_distributions_all") }}
