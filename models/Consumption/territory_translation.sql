{{ config(materialized="incremental", unique_key=["territory_translation_key"]) }}

select
  *,
  territory_code||'~'||language as territory_translation_key
from {{ source("redshift_src", "fnd_territories_tl") }}
