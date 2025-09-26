{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  entity_id as integration_id
from {{ source("redshift_src", "xla_transaction_entities_tmp") }}
