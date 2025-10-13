{{ config(materialized="incremental", unique_key=["per_periods_of_service_key"]) }}

select
  *,
  period_of_service_id as per_periods_of_service_key
from {{ source("redshift_src", "per_periods_of_service") }}
