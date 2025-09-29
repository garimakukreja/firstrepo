{{ config(materialized="view", unique_key="integration_id") }}

select
  *,
  payment_document_id as integration_id
from {{ source("redshift_src", "ce_payment_documents") }}
