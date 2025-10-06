{{ config(materialized="view") }}

select
  *,
  CAST(application_id AS VARCHAR) || '~' ||
  id_flex_code || '~' ||
  CAST(id_flex_num AS VARCHAR) || '~' ||
  application_column_name AS integration_id
from {{ source("redshift_src", "fnd_id_flex_segments") }}
