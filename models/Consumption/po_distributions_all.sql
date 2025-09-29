{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  po_distribution_id as integration_id
from {{ source("redshift_src", "po_distributions_all") }}
