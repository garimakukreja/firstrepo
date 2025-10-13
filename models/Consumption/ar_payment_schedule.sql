{{ config(materialized="incremental", unique_key=["ar_payment_schedule_key"]) }}

select
  *,
  payment_schedule_id as ar_payment_schedule_key
from {{ source("redshift_src", "ar_payment_schedules_all") }}
