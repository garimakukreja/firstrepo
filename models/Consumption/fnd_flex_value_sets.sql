{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  FLEX_VALUE_SET_ID as integration_id
from {{ source("redshift_src", "fnd_flex_value_sets") }}
