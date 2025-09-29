{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  source_id||source_table||source_type as integration_id
from {{ source("redshift_src", "ar_distributions_all") }}
