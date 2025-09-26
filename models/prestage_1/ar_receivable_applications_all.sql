{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  receivable_application_id as integration_id
from {{ source("redshift_src", "ar_receivable_applications_all") }}
