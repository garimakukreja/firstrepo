{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  invoice_distribution_id as integration_id
from {{ source("redshift_src", "ap_invoice_distributions_all_tmp") }}
