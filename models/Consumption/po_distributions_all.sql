{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  po_distribution_id as integration_id
from {{ source("ebs", "po_distributions_all") }}
