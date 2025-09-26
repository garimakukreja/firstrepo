{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  payment_schedule_id as integration_id
from {{ source("redshift_src", "ar_payment_schedules_all") }}
