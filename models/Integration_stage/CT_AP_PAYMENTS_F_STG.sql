{{ config(materialized='table') }}


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
iby_payments_all as (
    select * from {{ ref("iby_payments_all") }}
),
ap_terms_tl as (
    select * from {{ ref("ap_terms_tl") }}
),
gl_ledgers as (
    select * from {{ ref("gl_ledgers") }}
),
gl_code_combinations as (
    select * from {{ ref("gl_code_combinations") }}
),
iby_payment_methods_tl as (
    select * from {{ ref("iby_payment_methods_tl") }}
),
fnd_lookup_values as (
    select * from {{ ref("fnd_lookup_values") }}
),
po_headers_all as (
    select * from {{ ref("po_headers_all") }}
),
ct_ap_payments_f_stg as (
    SELECT concat(coalesce(appayments_f_join_a.vendor_id, '0'), '~', coalesce(appayments_f_join_a.vendor_site_id, '0')) AS supplier_id, coalesce(appayments_f_join_a.set_of_books_id, 0) AS ledger_id, coalesce(appayments_f_join_a.org_id, 0) AS bu_id, coalesce(appayments_f_join_a.legal_entity_id, 0) AS legal_entity_id, coalesce(appayments_f_join_a.accts_pay_code_combination_id, 0) AS glcc_id, appayments_f_join_a.org_id AS org_id, coalesce(CAST(TO_CHAR(appayments_f_join_a.invoice_date, 'YYYYMMDD') AS NUMERIC), 0) AS invoice_dt_id, coalesce(CAST(TO_CHAR(appayments_f_join_a.payment_date, 'YYYYMMDD') AS NUMERIC), 0) AS payment_dt_id, CAST(TO_CHAR(appayments_f_join_a.gl_date, 'YYYYMMDD') AS NUMERIC) AS gl_dt_id, CAST(TO_CHAR(appayments_f_join_a.accounting_date, 'YYYYMMDD') AS NUMERIC) AS accounting_dt_id, TO_CHAR(appayments_f_join_a.accounting_date, 'Mon-YY') AS period_name, EXTRACT(YEAR FROM accounting_date) AS period_year, EXTRACT(MONTH FROM accounting_date) AS period_num, CAST(NULL AS VARCHAR) AS supplier_contact, appayments_f_join_a.name AS ledger_name, appayments_f_join_a.check_id, appayments_f_join_a.check_number AS check_num, appayments_f_join_a.check_voucher_num, appayments_f_join_a.check_date AS check_dt, appayments_f_join_a.payment_currency_code, appayments_f_join_a.currency_code AS ledger_curr_code, appayments_f_join_a.invoice_date AS gl_dt, appayments_f_join_a.accounting_date AS accounting_dt, appayments_f_join_a.invoice_date AS invoice_dt, appayments_f_join_a.invoice_id, appayments_f_join_a.invoice_num, appayments_f_join_a.invoice_currency_code AS inv_curr_code, appayments_f_join_a.due_date AS payment_due_dt, appayments_f_join_a.po_number, appayments_f_join_a.payee_name, appayments_f_join_a.payee_supplier_site_name AS payee_site_name, appayments_f_join_a.displayed_field AS check_status, CASE appayments_f_join_a.payment_status_flag WHEN 'Y' THEN 'Paid' WHEN 'N' THEN 'Not Paid' WHEN 'P' THEN 'Partially paid' ELSE NULL END AS payment_status, appayments_f_join_a.payment_status_flag, appayments_f_join_a.stopped_date AS payment_stopped_dt, appayments_f_join_a.void_date AS payment_void_dt, appayments_f_join_a.released_date AS payment_released_dt, appayments_f_join_a.ext_bank_account_number AS remit_to_bank_account_no, appayments_f_join_a.ext_bank_name AS remit_to_bank_name, appayments_f_join_a.ext_bank_branch_name AS remit_to_branch_name, appayments_f_join_a.payee_address_concat AS remit_to_address, appayments_f_join_a.beneficiary_name, appayments_f_join_a.payment_method_name, appayments_f_join_a.cancelled_date AS cancelled_dt, appayments_f_join_a.cancelled_by, appayments_f_join_a.accrual_posted_flag, appayments_f_join_a.cash_posted_flag, appayments_f_join_a.posted_flag, coalesce(appayments_f_join_a.invoice_amount, 0) AS invoice_amount, coalesce(appayments_f_join_a.amount, 0) AS check_amount, coalesce(appayments_f_join_a.amount_1, 0) AS payment_amount, coalesce(appayments_f_join_a.amount_remaining, 0) AS invoice_due_amt, 0 AS invoice_amount_usd, 0 AS check_amount_usd, 0 AS payment_amount_usd, 0 AS invoice_due_amt_usd, 0 AS conv_pymt_rate_to_usd, CAST(NULL AS VARCHAR) AS conv_pymt_rate_type, 0 AS conv_inv_rate_to_usd, CAST(NULL AS VARCHAR) AS conv_inv_rate_type, appayments_f_join_a.creation_date AS creation_dt, appayments_f_join_a.last_update_date AS last_update_dt, appayments_f_join_a.created_by, appayments_f_join_a.last_updated_by, concat(coalesce(appayments_f_join_a.invoice_payment_id, 0), '~', coalesce(appayments_f_join_a.check_id, 0), '~', coalesce(appayments_f_join_a.payment_id, 0)) AS integration_id, 1000 AS datasource_num_id, 'N' AS delete_flag, appayments_f_join_a.meaning AS payment_type, appayments_f_join_a.payment_date, appayments_f_join_a.payment_terms, appayments_f_join_a.discount_amount_taken, appayments_f_join_a.amount_applicable_to_discount, CASE WHEN (CURRENT_DATE > appayments_f_join_a.due_date) THEN 'Y' ELSE 'N' END AS over_due_flag, CASE WHEN appayments_f_join_a.payment_date > appayments_f_join_a.due_date THEN 'Y' ELSE 'N' END AS payment_late_flag FROM ( SELECT checks_all.amount, checks_all.check_date, checks_all.check_id, checks_all.check_number, checks_all.check_voucher_num, checks_all.void_date, checks_all.vendor_id, checks_all.vendor_site_id, checks_all.released_date, checks_all.stopped_date, invoice_payments_all.accounting_date, invoice_payments_all.accrual_posted_flag, invoice_payments_all.amount AS amount_1, invoice_payments_all.cash_posted_flag, invoice_payments_all.invoice_payment_id, invoice_payments_all.last_updated_by, invoice_payments_all.last_update_date, invoice_payments_all.posted_flag, invoice_payments_all.set_of_books_id, invoice_payments_all.created_by, invoice_payments_all.creation_date, invoice_payments_all.org_id, invoices_all.invoice_id, invoices_all.invoice_num, invoices_all.invoice_currency_code, invoices_all.invoice_amount, invoices_all.invoice_date, invoices_all.accts_pay_code_combination_id, invoices_all.cancelled_date, invoices_all.cancelled_by, invoices_all.gl_date, payment_schedules_all.due_date, payment_schedules_all.payment_status_flag, lookup_codes.displayed_field, iby_payments_all.payment_id, iby_payments_all.payment_currency_code, checks_all.legal_entity_id, iby_payments_all.payment_date, iby_payments_all.ext_bank_account_number, iby_payments_all.payee_name, iby_payments_all.ext_bank_name, iby_payments_all.ext_bank_branch_name, iby_payments_all.payee_address_concat, iby_payments_all.beneficiary_name, iby_payments_all.payee_supplier_site_name, gl_ledgers.name, gl_ledgers.currency_code, iby_payment_methods_tl.payment_method_name, fnd_lookup_values.meaning, po_headers_all.segment1 AS po_number, terms_tl.name AS payment_terms, payment_schedules_all.amount_remaining, invoices_all.discount_amount_taken, invoices_all.amount_applicable_to_discount FROM ap_invoice_payments_all invoice_payments_all JOIN ap_invoices_all invoices_all ON invoice_payments_all.invoice_id = invoices_all.invoice_id LEFT JOIN ap_checks_all checks_all ON invoice_payments_all.check_id = checks_all.check_id LEFT JOIN ap_payment_schedules_all payment_schedules_all ON invoice_payments_all.invoice_id = payment_schedules_all.invoice_id AND invoice_payments_all.payment_num = payment_schedules_all.payment_num LEFT JOIN ap_lookup_codes lookup_codes ON lookup_codes.lookup_type = 'CHECK STATE' AND lookup_codes.lookup_code = checks_all.status_lookup_code LEFT JOIN ce_payment_documents ce_payment_documents ON checks_all.payment_document_id = ce_payment_documents.payment_document_id LEFT JOIN iby_payments_all iby_payments_all ON checks_all.payment_id = iby_payments_all.payment_id LEFT JOIN ap_terms_tl terms_tl ON invoices_all.terms_id = terms_tl.term_id AND coalesce(terms_tl.language, 'US') = 'US' LEFT JOIN gl_ledgers gl_ledgers ON gl_ledgers.ledger_id = invoice_payments_all.set_of_books_id LEFT JOIN gl_code_combinations gl_code_combinations ON gl_code_combinations.code_combination_id = invoices_all.accts_pay_code_combination_id LEFT JOIN iby_payment_methods_tl iby_payment_methods_tl ON iby_payments_all.payment_method_code = iby_payment_methods_tl.payment_method_code AND coalesce(iby_payment_methods_tl.language, 'US') = 'US' LEFT JOIN fnd_lookup_values fnd_lookup_values ON fnd_lookup_values.lookup_type = 'INVOICE TYPE' AND fnd_lookup_values.language = 'US' AND invoices_all.invoice_type_lookup_code = fnd_lookup_values.lookup_code LEFT JOIN po_headers_all po_headers_all ON invoices_all.po_header_id = po_headers_all.po_header_id WHERE ( CAST(invoice_payments_all.last_update_date AS DATE) >= CAST('$LAST_RUN_DATE$' AS DATE) OR CAST(checks_all.last_update_date AS DATE) >= CAST('$LAST_RUN_DATE$' AS DATE) OR CAST(iby_payments_all.last_update_date AS DATE) >= CAST('$LAST_RUN_DATE$' AS DATE) OR CAST(invoices_all.last_update_date AS DATE) >= CAST('$LAST_RUN_DATE$' AS DATE) ) ) appayments_f_join_a
)
    select * from ct_ap_payments_f_stg;
