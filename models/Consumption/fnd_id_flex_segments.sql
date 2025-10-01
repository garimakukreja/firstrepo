{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  ['APPLICATION_ID', 'ID_FLEX_CODE', 'ID_FLEX_NUM', 'APPLICATION_COLUMN_NAME'] as integration_id
from {{ source("redshift_src", "fnd_id_flex_segments") }}
