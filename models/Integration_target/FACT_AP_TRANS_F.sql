{{ config(materialized="table", unique_key="integration_id") }}

{#
{% do mkTruncate_stage_table() %}
{% set src_tables = ['fact_ap_trans_f_stg', 'dim_gl_account_stg', 'dim_supplier_stg', 'dim_gl_ledgers_stg', 'dim_legal_entity_stg', 'dim_org_stg', 'dim_business_unit_stg', 'dim_product_stg', 'dim_gl_daily_rates_stg'] %}
{% set last_update_date = mkget_last_update_date(src_tables) %}
#}

with
    fact_ap_trans_f_stg as (
        select * from {{ ref("fact_ap_trans_f_stg") }}
    ),
    dim_gl_account_stg as (
        select * from {{ ref("dim_gl_account_stg") }}
    ),
    dim_supplier_stg as (
        select * from {{ ref("dim_supplier_stg") }}
    ),
    dim_gl_ledgers_stg as (
        select * from {{ ref("dim_gl_ledgers_stg") }}
    ),
    dim_legal_entity_stg as (
        select * from {{ ref("dim_legal_entity_stg") }}
    ),
    dim_org_stg as (
        select * from {{ ref("dim_org_stg") }}
    ),
    dim_business_unit_stg as (
        select * from {{ ref("dim_business_unit_stg") }}
    ),
    dim_product_stg as (
        select * from {{ ref("dim_product_stg") }}
    ),
    dim_gl_daily_rates_stg as (
        select * from {{ ref("dim_gl_daily_rates_stg") }}
    ),

fact_ap_trans_f as (
    select
        -- 🔹 Cast all keys to VARCHAR before COALESCE
        coalesce(cast(dim_supplier_stg.integration_id as varchar), '0') as supplier_key,
        coalesce(cast(cgl_ledgers_d.integration_id as varchar), '0') as ledger_key,
        coalesce(cast(clegal_entity_d.integration_id as varchar), '0') as legal_entity_key,
        cast(coalesce(fact_ap_trans_f_stg.invoice_dt_id, 0) as numeric) as invoice_dt_key,
        cast(coalesce(fact_ap_trans_f_stg.payment_due_dt_id, 0) as numeric) as payment_due_dt_key,
        cast(coalesce(fact_ap_trans_f_stg.gl_dt_id, 0) as numeric) as gl_dt_key,
        cast(coalesce(fact_ap_trans_f_stg.accounting_dt_id, 0) as numeric) as accounting_dt_key,
        coalesce(cast(cgl_account_d.integration_id as varchar), '0') as glcc_liab_key,
        coalesce(cast(cgl_account_d1.integration_id as varchar), '0') as glcc_expense_key,
        coalesce(cast(dim_business_unit_stg.integration_id as varchar), '0') as bu_key,
        coalesce(cast(dim_org_stg.integration_id as varchar), '0') as org_key,
        coalesce(cast(fact_ap_trans_f_stg.project_id as varchar), '0') as project_id,
        coalesce(cast(fact_ap_trans_f_stg.task_id as varchar), '0') as task_id,
        coalesce(cast(dim_product_stg.integration_id as varchar), '0') as product_key,

        fact_ap_trans_f_stg.period_name,
        fact_ap_trans_f_stg.period_year,
        fact_ap_trans_f_stg.period_num,
        fact_ap_trans_f_stg.supplier_contact,
        fact_ap_trans_f_stg.ledger_name,
        fact_ap_trans_f_stg.invoice_id,
        fact_ap_trans_f_stg.invoice_num,
        fact_ap_trans_f_stg.invoice_desc,
        fact_ap_trans_f_stg.invoice_line_num,
        fact_ap_trans_f_stg.dist_line_num,
        fact_ap_trans_f_stg.inv_curr_code,
        cgl_ledgers_d.ledger_curr_code,
        fact_ap_trans_f_stg.payment_curr_code,
        fact_ap_trans_f_stg.invoice_dt,
        fact_ap_trans_f_stg.gl_dt,
        fact_ap_trans_f_stg.accounting_dt,
        fact_ap_trans_f_stg.payment_due_dt,
        fact_ap_trans_f_stg.inv_source,
        fact_ap_trans_f_stg.inv_type_code,
        fact_ap_trans_f_stg.inv_type_name,
        fact_ap_trans_f_stg.inv_type_name as transaction_sub_type,
        fact_ap_trans_f_stg.payment_terms,
        fact_ap_trans_f_stg.payment_method_code,
        fact_ap_trans_f_stg.payment_method_desc,
        fact_ap_trans_f_stg.payment_status_flag,
        fact_ap_trans_f_stg.payment_status,
        fact_ap_trans_f_stg.approval_status,
        fact_ap_trans_f_stg.goods_received_dt,
        fact_ap_trans_f_stg.invoice_received_dt,
        fact_ap_trans_f_stg.exch_rate,
        fact_ap_trans_f_stg.header_category_code,
        fact_ap_trans_f_stg.cancelled_dt,
        fact_ap_trans_f_stg.cancelled_by,
        fact_ap_trans_f_stg.project_name,
        fact_ap_trans_f_stg.task_name,
        fact_ap_trans_f_stg.line_type_lookup_code,
        fact_ap_trans_f_stg.line_type_lookup_desc,
        fact_ap_trans_f_stg.line_source,
        fact_ap_trans_f_stg.line_source_desc,
        fact_ap_trans_f_stg.uom_code,
        fact_ap_trans_f_stg.uom_desc,
        fact_ap_trans_f_stg.line_cancelled_flag,
        fact_ap_trans_f_stg.type_1099,
        fact_ap_trans_f_stg.line_category_code,
        fact_ap_trans_f_stg.accrual_posted_flag,
        fact_ap_trans_f_stg.cash_posted_flag,
        fact_ap_trans_f_stg.dist_glcc_concat,
        fact_ap_trans_f_stg.posted_flag,
        fact_ap_trans_f_stg.dist_category_code,
        fact_ap_trans_f_stg.po_header_id,
        fact_ap_trans_f_stg.po_number,
        fact_ap_trans_f_stg.po_line_id,
        fact_ap_trans_f_stg.po_line_num,
        fact_ap_trans_f_stg.po_line_location_id,
        fact_ap_trans_f_stg.po_shipment_num,
        fact_ap_trans_f_stg.po_distribution_id,
        fact_ap_trans_f_stg.rcv_transaction_id,
        fact_ap_trans_f_stg.po_receipt_num,
        fact_ap_trans_f_stg.match_type,
        fact_ap_trans_f_stg.po_release_id,
        fact_ap_trans_f_stg.unit_price,
        fact_ap_trans_f_stg.quantity_invoiced,
        fact_ap_trans_f_stg.inv_amount,
        fact_ap_trans_f_stg.inv_line_amount,
        fact_ap_trans_f_stg.inv_dist_line_amount,
        fact_ap_trans_f_stg.inv_ledger_amount,
        fact_ap_trans_f_stg.paid_amount,
        fact_ap_trans_f_stg.remaining_due_amount,
        fact_ap_trans_f_stg.amt_applicable_to_disc,
        fact_ap_trans_f_stg.base_amount,

        -- 🔹 Handle conversion safely
        fact_ap_trans_f_stg.inv_amount * coalesce(dim_gl_daily_rates_stg.conversion_rate, 1) as inv_amount_usd,
        fact_ap_trans_f_stg.inv_line_amount * coalesce(dim_gl_daily_rates_stg.conversion_rate, 1) as inv_line_amount_usd,
        fact_ap_trans_f_stg.inv_dist_line_amount * coalesce(dim_gl_daily_rates_stg.conversion_rate, 1) as inv_dist_line_amount_usd,
        fact_ap_trans_f_stg.inv_ledger_amount * coalesce(dim_gl_daily_rates_stg.conversion_rate, 1) as inv_ledger_amount_usd,
        fact_ap_trans_f_stg.paid_amount * coalesce(dim_gl_daily_rates_stg.conversion_rate, 1) as paid_amount_usd,
        fact_ap_trans_f_stg.remaining_due_amount * coalesce(dim_gl_daily_rates_stg.conversion_rate, 1) as remaining_due_amount_usd,
        coalesce(dim_gl_daily_rates_stg.conversion_rate, 1) as conv_rate_to_usd,

        fact_ap_trans_f_stg.conv_rate_type,
        fact_ap_trans_f_stg.creation_dt,
        fact_ap_trans_f_stg.last_update_dt,
        fact_ap_trans_f_stg.created_by,
        fact_ap_trans_f_stg.last_updated_by,
        fact_ap_trans_f_stg.integration_id,
        fact_ap_trans_f_stg.datasource_num_id,
        fact_ap_trans_f_stg.inv_line_amount as trans_amt,
        fact_ap_trans_f_stg.transaction_status,
        fact_ap_trans_f_stg.transaction_type,
        fact_ap_trans_f_stg.discount_amount_taken,
        fact_ap_trans_f_stg.delete_flag,
        fact_ap_trans_f_stg.w_insert_dt,
        fact_ap_trans_f_stg.w_update_dt,
        cast(null as varchar) as payment_number,
        cast(null as varchar) as hold_flag,
        cast(null as varchar) as remit_to_supplier_name,
        cast(null as varchar) as remit_to_address_name,
        cast(null as varchar) as remit_to_supplier_id,
        fact_ap_trans_f_stg.voucher_num

    from fact_ap_trans_f_stg
    left join dim_gl_account_stg cgl_account_d 
        on fact_ap_trans_f_stg.glcc_liab_id = cgl_account_d.integration_id
        and fact_ap_trans_f_stg.datasource_num_id = cgl_account_d.datasource_num_id
    left join dim_supplier_stg 
        on fact_ap_trans_f_stg.supplier_id = dim_supplier_stg.integration_id
        and fact_ap_trans_f_stg.datasource_num_id = dim_supplier_stg.datasource_num_id
    left join dim_gl_account_stg cgl_account_d1
        on fact_ap_trans_f_stg.glcc_expense_id = cgl_account_d1.integration_id
        and fact_ap_trans_f_stg.datasource_num_id = cgl_account_d1.datasource_num_id
    left join dim_gl_ledgers_stg cgl_ledgers_d
        on fact_ap_trans_f_stg.ledger_id = cgl_ledgers_d.integration_id
        and fact_ap_trans_f_stg.datasource_num_id = cgl_ledgers_d.datasource_num_id
    left join dim_legal_entity_stg clegal_entity_d
        on cast(fact_ap_trans_f_stg.legal_entity_id as varchar) = cast(clegal_entity_d.integration_id as varchar)
        and fact_ap_trans_f_stg.datasource_num_id = clegal_entity_d.datasource_num_id
    left join dim_org_stg
        on cast(fact_ap_trans_f_stg.org_id as varchar) = cast(dim_org_stg.integration_id as varchar)
        and fact_ap_trans_f_stg.datasource_num_id = dim_org_stg.datasource_num_id
    left join dim_business_unit_stg
        on fact_ap_trans_f_stg.bu_id = dim_business_unit_stg.integration_id
        and fact_ap_trans_f_stg.datasource_num_id = dim_business_unit_stg.datasource_num_id
    left join dim_product_stg
        on fact_ap_trans_f_stg.product_id = dim_product_stg.integration_id
        and fact_ap_trans_f_stg.datasource_num_id = dim_product_stg.datasource_num_id
    left join dim_gl_daily_rates_stg
        on fact_ap_trans_f_stg.inv_curr_code = dim_gl_daily_rates_stg.from_currency
        and cast(dim_gl_daily_rates_stg.conversion_dt as date) = cast(fact_ap_trans_f_stg.invoice_dt as date)
        and dim_gl_daily_rates_stg.to_currency = 'usd'
        and dim_gl_daily_rates_stg.conversion_type = 'corporate'
    where 1=1
)

select *
from fact_ap_trans_f
