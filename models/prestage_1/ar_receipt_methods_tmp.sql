{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  receipt_method_id as integration_id
from {{ source("redshift_src", "ar_receipt_methods_tmp") }}
