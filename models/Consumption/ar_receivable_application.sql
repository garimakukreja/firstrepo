{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  receivable_application_id as integration_id
from {{ source("ebs", "ar_receivable_applications_all") }}
