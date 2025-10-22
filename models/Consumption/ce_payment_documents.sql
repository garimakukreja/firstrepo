{{ config(materialized="incremental", unique_key="integration_id") }}

select
  *,
  payment_document_id as integration_id
from {{ source("ebs", "ce_payment_documents") }}
