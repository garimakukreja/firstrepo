{{ config(materialized="table", unique_key="integration_id") }}

        {% do mkTruncate_stage_table() %}

        {% set src_tables = ['ap_invoice_payments_all', 'ap_invoices_all', 'ap_checks_all', 'ap_payment_schedules_all', 'ap_lookup_codes', 'ce_payment_documents', 'iby_payment', 'ap_terms_tl', 'gl_ledger', 'gl_code_combination', 'iby_payment_method_translation', 'fnd_lookup_values', 'po_headers_all'] %}
        {% set last_update_date = mkget_last_update_date(src_tables) %}

        with
            ap_invoice_payments_all as (
    select * from {{ ref("ap_invoice_payments_all") }}
),
ap_invoices_all as (
    select * from {{ ref("ap_invoices_all") }}
),
ap_checks_all as (
    select * from {{ ref("ap_checks_all") }}
),
ap_payment_schedules_all as (
    select * from {{ ref("ap_payment_schedules_all") }}
),
ap_lookup_codes as (
    select * from {{ ref("ap_lookup_codes") }}
),
ce_payment_documents as (
    select * from {{ ref("ce_payment_documents") }}
),
iby_payment as (
    select * from {{ ref("iby_payment") }}
),
ap_terms_tl as (
    select * from {{ ref("ap_terms_tl") }}
),
gl_ledger as (
    select * from {{ ref("gl_ledger") }}
),
gl_code_combination as (
    select * from {{ ref("gl_code_combination") }}
),
iby_payment_method_translation as (
    select * from {{ ref("iby_payment_method_translation") }}
),
fnd_lookup_values as (
    select * from {{ ref("fnd_lookup_values") }}
),
po_headers_all as (
    select * from {{ ref("po_headers_all") }}
),
fact_ap_payments_f_stg as (
select concat(coalesce(appayments_f_join_a.vendor_id, '0'), '~', coalesce(appayments_f_join_a.vendor_site_id, '0')) as supplier_id, coalesce(appayments_f_join_a.set_of_books_id, 0) as ledger_id, coalesce(appayments_f_join_a.org_id, 0) as bu_id, coalesce(appayments_f_join_a.legal_entity_id, 0) as legal_entity_id, coalesce(appayments_f_join_a.accts_pay_code_combination_id, 0) as glcc_id, appayments_f_join_a.org_id as org_id, coalesce(cast(to_char(appayments_f_join_a.invoice_date, 'yyyymmdd') as numeric), 0) as invoice_dt_id, coalesce(cast(to_char(appayments_f_join_a.payment_date, 'yyyymmdd') as numeric), 0) as payment_dt_id, cast(to_char(appayments_f_join_a.gl_date, 'yyyymmdd') as numeric) as gl_dt_id, cast(to_char(appayments_f_join_a.accounting_date, 'yyyymmdd') as numeric) as accounting_dt_id, to_char(appayments_f_join_a.accounting_date, 'mon-yy') as period_name, extract(year from appayments_f_join_a.accounting_date) as period_year, extract(month from appayments_f_join_a.accounting_date) as period_num, cast(null as varchar) as supplier_contact, appayments_f_join_a.name as ledger_name, appayments_f_join_a.check_id, appayments_f_join_a.check_number as check_num, appayments_f_join_a.check_voucher_num, appayments_f_join_a.check_date as check_dt, appayments_f_join_a.payment_currency_code, appayments_f_join_a.currency_code as ledger_curr_code, appayments_f_join_a.invoice_date as gl_dt, appayments_f_join_a.accounting_date as accounting_dt, appayments_f_join_a.invoice_date as invoice_dt, appayments_f_join_a.invoice_id, appayments_f_join_a.invoice_num, appayments_f_join_a.invoice_currency_code as inv_curr_code, appayments_f_join_a.due_date as payment_due_dt, appayments_f_join_a.po_number, appayments_f_join_a.payee_name, appayments_f_join_a.payee_supplier_site_name as payee_site_name, appayments_f_join_a.displayed_field as check_status, case appayments_f_join_a.payment_status_flag when 'y' then 'paid' when 'n' then 'not paid' when 'p' then 'partially paid' else null end as payment_status, appayments_f_join_a.payment_status_flag, appayments_f_join_a.stopped_date as payment_stopped_dt, appayments_f_join_a.void_date as payment_void_dt, appayments_f_join_a.released_date as payment_released_dt, appayments_f_join_a.ext_bank_account_number as remit_to_bank_account_no, appayments_f_join_a.ext_bank_name as remit_to_bank_name, appayments_f_join_a.ext_bank_branch_name as remit_to_branch_name, appayments_f_join_a.payee_address_concat as remit_to_address, appayments_f_join_a.beneficiary_name, appayments_f_join_a.payment_method_name, appayments_f_join_a.cancelled_date as cancelled_dt, appayments_f_join_a.cancelled_by, appayments_f_join_a.accrual_posted_flag, appayments_f_join_a.cash_posted_flag, appayments_f_join_a.posted_flag, coalesce(appayments_f_join_a.invoice_amount, 0) as invoice_amount, coalesce(appayments_f_join_a.amount, 0) as check_amount, coalesce(appayments_f_join_a.amount_1, 0) as payment_amount, coalesce(appayments_f_join_a.amount_remaining, 0) as invoice_due_amt, 0 as invoice_amount_usd, 0 as check_amount_usd, 0 as payment_amount_usd, 0 as invoice_due_amt_usd, 0 as conv_pymt_rate_to_usd, cast(null as varchar) as conv_pymt_rate_type, 0 as conv_inv_rate_to_usd, cast(null as varchar) as conv_inv_rate_type, appayments_f_join_a.creation_date as creation_dt, appayments_f_join_a.last_update_date as last_update_dt, appayments_f_join_a.created_by, appayments_f_join_a.last_updated_by, concat(coalesce(appayments_f_join_a.invoice_payment_id, 0), '~', coalesce(appayments_f_join_a.check_id, 0), '~', coalesce(appayments_f_join_a.payment_id, 0)) as integration_id, 1000 as datasource_num_id, 'n' as delete_flag, appayments_f_join_a.meaning as payment_type, appayments_f_join_a.payment_date, appayments_f_join_a.payment_terms, appayments_f_join_a.discount_amount_taken, appayments_f_join_a.amount_applicable_to_discount, case when (current_date > appayments_f_join_a.due_date) then 'y' else 'n' end as over_due_flag, case when appayments_f_join_a.payment_date > appayments_f_join_a.due_date then 'y' else 'n' end as payment_late_flag from ( select checks_all.amount, checks_all.check_date, checks_all.check_id, checks_all.check_number, checks_all.check_voucher_num, checks_all.void_date, checks_all.vendor_id, checks_all.vendor_site_id, checks_all.released_date, checks_all.stopped_date, invoice_payments_all.accounting_date, invoice_payments_all.accrual_posted_flag, invoice_payments_all.amount as amount_1, invoice_payments_all.cash_posted_flag, invoice_payments_all.invoice_payment_id, invoice_payments_all.last_updated_by, invoice_payments_all.last_update_date, invoice_payments_all.posted_flag, invoice_payments_all.set_of_books_id, invoice_payments_all.created_by, invoice_payments_all.creation_date, invoice_payments_all.org_id, invoices_all.invoice_id, invoices_all.invoice_num, invoices_all.invoice_currency_code, invoices_all.invoice_amount, invoices_all.invoice_date, invoices_all.accts_pay_code_combination_id, invoices_all.cancelled_date, invoices_all.cancelled_by, invoices_all.gl_date, payment_schedules_all.due_date, payment_schedules_all.payment_status_flag, lookup_codes.displayed_field, iby_payments_all.payment_id, iby_payments_all.payment_currency_code, checks_all.legal_entity_id, iby_payments_all.payment_date, iby_payments_all.ext_bank_account_number, iby_payments_all.payee_name, iby_payments_all.ext_bank_name, iby_payments_all.ext_bank_branch_name, iby_payments_all.payee_address_concat, iby_payments_all.beneficiary_name, iby_payments_all.payee_supplier_site_name, gl_ledger.name, gl_ledger.currency_code, iby_payment_method_translation.payment_method_name, fnd_lookup_values.meaning, po_headers_all.segment1 as po_number, terms_tl.name as payment_terms, payment_schedules_all.amount_remaining, invoices_all.discount_amount_taken, invoices_all.amount_applicable_to_discount from ap_invoice_payments_all invoice_payments_all join ap_invoices_all invoices_all on invoice_payments_all.invoice_id = invoices_all.invoice_id left join ap_checks_all checks_all on invoice_payments_all.check_id = checks_all.check_id left join ap_payment_schedules_all payment_schedules_all on invoice_payments_all.invoice_id = payment_schedules_all.invoice_id and invoice_payments_all.payment_num = payment_schedules_all.payment_num left join ap_lookup_codes lookup_codes on lookup_codes.lookup_type = 'check state' and lookup_codes.lookup_code = checks_all.status_lookup_code left join ce_payment_documents ce_payment_documents on checks_all.payment_document_id = ce_payment_documents.payment_document_id left join iby_payments_all iby_payments_all on checks_all.payment_id = iby_payments_all.payment_id left join ap_terms_tl terms_tl on invoices_all.terms_id = terms_tl.term_id and coalesce(terms_tl.language, 'us') = 'us' left join gl_ledger gl_ledger on gl_ledger.ledger_id = invoice_payments_all.set_of_books_id left join gl_code_combinations gl_code_combinations on gl_code_combinations.code_combination_id = invoices_all.accts_pay_code_combination_id left join iby_payment_method_translation iby_payment_method_translation on iby_payments_all.payment_method_code = iby_payment_method_translation.payment_method_code and coalesce(iby_payment_method_translation.language, 'us') = 'us' left join fnd_lookup_values fnd_lookup_values on fnd_lookup_values.lookup_type = 'invoice type' and fnd_lookup_values.language = 'us' and invoices_all.invoice_type_lookup_code = fnd_lookup_values.lookup_code left join po_headers_all po_headers_all on invoices_all.po_header_id = po_headers_all.po_header_id where ( cast(invoice_payments_all.last_update_date as date) >= cast('$last_run_date$' as date) or cast(checks_all.last_update_date as date) >= cast('$last_run_date$' as date) or cast(iby_payments_all.last_update_date as date) >= cast('$last_run_date$' as date) or cast(invoices_all.last_update_date as date) >= cast('$last_run_date$' as date) ) ) appayments_f_join_a
)

        select *
        from fact_ap_payments_f_stg;
