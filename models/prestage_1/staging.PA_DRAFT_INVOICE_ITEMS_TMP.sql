select *
from `dev.staging.staging.PA_DRAFT_INVOICE_ITEMS_TMP`
{% if is_incremental() %}
  where LASTUPDATEDATE >= (
    select coalesce(max(LASTUPDATEDATE), timestamp('1900-01-01 00:00:00'))
    from {{ this }}
  )
{% endif %}
