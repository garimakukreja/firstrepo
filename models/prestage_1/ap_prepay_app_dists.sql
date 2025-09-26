{{{{ config(materialized="incremental", unique_key="integration_id") }}}}

select
  *,
  prepay_app_dist_id as integration_id
from {{ source("redshift_src", "ap_prepay_app_dists") }}
