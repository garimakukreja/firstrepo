{{ config(materialized="table", unique_key="integration_id") }}

        {% do mkTruncate_stage_table() %}

        {% set src_tables = ['ap_invoices_all', 'ap_invoice_lines_all', 'ap_invoice_distributions_all', 'ap_batches_all', 'IBY_PAYMENT_METHOD_TRANSLATION', 'ap_lookup_codes', 'po_distributions_all', 'fnd_lookup_values', 'po_lines_all', 'po_line_locations_all', 'po_headers_all', 'gl_ledger', 'ap_terms_tl', 'ap_payment_schedules_all'] %}
        {% set last_update_date = mkget_last_update_date(src_tables) %}

        with
            ap_invoices_all as (
    select * from {{ ref("ap_invoices_all") }}
),
ap_invoice_lines_all as (
    select * from {{ ref("ap_invoice_lines_all") }}
),
ap_invoice_distributions_all as (
    select * from {{ ref("ap_invoice_distributions_all") }}
),
ap_batches_all as (
    select * from {{ ref("ap_batches_all") }}
),
iby_payment_method_translation as (
    select * from {{ ref("IBY_PAYMENT_METHOD_TRANSLATION") }}
),
ap_lookup_codes as (
    select * from {{ ref("ap_lookup_codes") }}
),
po_distributions_all as (
    select * from {{ ref("po_distributions_all") }}
),
fnd_lookup_values as (
    select * from {{ ref("fnd_lookup_values") }}
),
po_lines_all as (
    select * from {{ ref("po_lines_all") }}
),
po_line_locations_all as (
    select * from {{ ref("po_line_locations_all") }}
),
po_headers_all as (
    select * from {{ ref("po_headers_all") }}
),
gl_ledger as (
    select * from {{ ref("gl_ledger") }}
),
ap_terms_tl as (
    select * from {{ ref("ap_terms_tl") }}
),
ap_payment_schedules_all as (
    select * from {{ ref("ap_payment_schedules_all") }}
),
fact_ap_trans_f_stg as (
SELECT concat( COALESCE(ap_invoices_all.vendor_id::varchar, '0'), '~', COALESCE(ap_invoices_all.vendor_site_id::varchar, '0') ) AS supplier_id, ap_invoices_all.set_of_books_id AS ledger_id, ap_invoices_all.legal_entity_id AS legal_entity_id, cast(to_char(ap_invoices_all.invoice_date, 'YYYYMMDD') as int) AS invoice_dt_id, cast(to_char(orm.due_date, 'YYYYMMDD') as int) AS payment_due_dt_id, cast(to_char(ap_invoices_all.gl_date, 'YYYYMMDD') as int) AS gl_dt_id, cast(to_char(ap_invoice_distributions_all.accounting_date, 'YYYYMMDD') as int) AS accounting_dt_id, COALESCE(ap_invoices_all.accts_pay_code_combination_id, 0) AS glcc_liab_id, COALESCE(ap_invoice_distributions_all.dist_code_combination_id, 0) AS glcc_expense_id, ap_invoices_all.org_id AS bu_id, ap_invoices_all.org_id AS org_id, ap_invoices_all.project_id AS project_id, ap_invoices_all.task_id AS task_id, COALESCE(ap_invoice_lines_all.inventory_item_id, 0) AS product_id, to_char(ap_invoices_all.invoice_date, 'Mon-YY') AS period_name, extract(year from ap_invoices_all.invoice_date) AS period_year, extract(month from ap_invoices_all.invoice_date) AS period_num, '' AS supplier_num, '' AS supplier_name, '' AS supplier_site_num, '' AS supplier_site_name, '' AS supplier_contact, cledgers.name AS ledger_name, ap_invoices_all.invoice_id AS invoice_id, ap_invoices_all.invoice_num AS invoice_num, ap_invoices_all.description AS invoice_desc, ap_invoice_lines_all.line_number AS invoice_line_num, ap_invoice_distributions_all.distribution_line_number AS dist_line_num, ap_invoices_all.invoice_currency_code AS inv_curr_code, cledgers.currency_code AS ledger_curr_code, ap_invoices_all.payment_currency_code AS payment_curr_code, ap_invoices_all.invoice_date AS invoice_dt, ap_invoices_all.gl_date AS gl_dt, ap_invoice_distributions_all.accounting_date AS accounting_dt, orm.due_date AS payment_due_dt, '' AS org_num, '' AS org_name, '' AS bu_num, '' AS bu_name, '' AS legal_entity_num, '' AS legal_entity_name, '' AS legal_entity_name, '' AS glcc_liab_concat, '' AS liab_segment1, '' AS liab_segment2, '' AS liab_segment3, '' AS liab_segment4, '' AS liab_segment5, '' AS liab_segment6, '' AS liab_segment7, '' AS liab_segment8, '' AS liab_segment9, '' AS glcc_exp_concat, '' AS exp_segment1, '' AS exp_segment2, '' AS exp_segment3, '' AS exp_segment4, '' AS exp_segment5, '' AS exp_segment6, '' AS exp_segment7, '' AS exp_segment8, '' AS exp_segment9, ap_invoices_all.source AS inv_source, ap_invoices_all.invoice_type_lookup_code AS inv_type_code, ap_lookup_codes.displayed_field AS inv_type_name, '' AS transaction_sub_type, ap_terms_tl.name AS payment_terms, ap_invoices_all.payment_method_code AS payment_method_code, iby_payment_methods_tl.payment_method_name AS payment_method_desc, ap_invoices_all.payment_status_flag AS payment_status_flag, CASE WHEN ap_invoices_all.payment_status_flag = 'Y' THEN 'Paid' WHEN ap_invoices_all.payment_status_flag = 'N' THEN 'Not Paid' WHEN ap_invoices_all.payment_status_flag = 'P' THEN 'Partially paid' END AS payment_status, ap_invoices_all.wfapproval_status AS approval_status, ap_invoices_all.goods_received_date AS goods_received_dt, ap_invoices_all.invoice_received_date AS invoice_received_dt, ap_invoices_all.exchange_rate AS exch_rate, ap_invoices_all.attribute_category AS header_category_code, ap_invoices_all.cancelled_date AS cancelled_dt, ap_invoices_all.cancelled_by AS cancelled_by, '' AS project_name, '' AS task_name, ap_invoice_lines_all.line_type_lookup_code AS line_type_lookup_code, ap_lookup_codes3.displayed_field AS line_type_lookup_desc, ap_invoice_lines_all.line_source AS line_source, '' AS line_source_desc, '-' AS product_num, '-' AS product_name, '-' AS product_desc, po_line_locations_all.unit_meas_lookup_code AS uom_code, '-' AS uom_desc, ap_invoice_lines_all.cancelled_flag AS line_cancelled_flag, ap_invoice_distributions_all.type_1099 AS type_1099, '-' AS line_category_code, '-' AS accrual_posted_flag, '-' AS cash_posted_flag, '-' AS dist_glcc_concat, ap_invoice_distributions_all.posted_flag AS posted_flag, '-' AS dist_category_code, po_headers_all.po_header_id AS po_header_id, po_headers_all.segment1 AS po_number, po_lines_all.po_line_id AS po_line_id, po_lines_all.line_num AS po_line_num, po_line_locations_all.line_location_id AS po_line_location_id, '-' AS po_shipment_num, ap_invoice_distributions_all.po_distribution_id AS po_distribution_id, '' AS rcv_transaction_id, '-' AS po_receipt_num, ap_invoice_distributions_all.dist_match_type AS match_type, '' AS po_release_id, COALESCE(ap_invoice_distributions_all.unit_price, 0) AS unit_price, COALESCE(ap_invoice_distributions_all.quantity_invoiced, 0) AS quantity_invoiced, COALESCE(ap_invoices_all.invoice_amount, 0) AS inv_amount, COALESCE(ap_invoice_lines_all.amount, 0) AS inv_line_amount, COALESCE(ap_invoice_distributions_all.amount, 0) AS inv_dist_line_amount, CASE WHEN ap_invoices_all.invoice_currency_code = cledgers.currency_code THEN COALESCE(ap_invoices_all.invoice_amount, 0) ELSE COALESCE(ap_invoices_all.invoice_amount, 0) * ap_invoices_all.exchange_rate END AS inv_ledger_amount, COALESCE(ap_invoices_all.amount_paid, 0) AS paid_amount, COALESCE(orm.amount_remaining, 0) AS remaining_due_amount, COALESCE(ap_invoices_all.amount_applicable_to_discount, 0) AS amt_applicable_to_disc, COALESCE(ap_invoices_all.base_amount, 0) AS base_amount, 0 AS inv_amount_usd, 0 AS inv_line_amount_usd, 0 AS inv_dist_line_amount_usd, 0 AS inv_ledger_amount_usd, 0 AS paid_amount_usd, 0 AS remaining_due_amount_usd, 0 AS conv_rate_to_usd, '' AS conv_rate_type, ap_invoices_all.creation_date AS creation_dt, ap_invoices_all.last_update_date AS last_update_dt, ap_invoices_all.created_by AS created_by, ap_invoices_all.last_updated_by AS last_updated_by, coalesce(ap_invoice_distributions_all.invoice_distribution_id, 0) AS integration_id, 1000 AS datasource_num_id, '' AS trans_amt, '' AS transaction_status, fnd_lookup_values.meaning AS transaction_type, COALESCE(ap_invoices_all.discount_amount_taken, 0) AS discount_amount_taken, ap_invoices_all.doc_sequence_value AS voucher_num, 'N' AS delete_flag, current_date AS w_insert_dt, current_date AS w_update_dt FROM apps.ap_invoices_all ap_invoices_all inner join apps.ap_invoice_lines_all ap_invoice_lines_all on ap_invoices_all.invoice_id = ap_invoice_lines_all.invoice_id inner join apps.ap_invoice_distributions_all ap_invoice_distributions_all on ap_invoice_lines_all.invoice_id = ap_invoice_distributions_all.invoice_id and ap_invoice_lines_all.line_number = ap_invoice_distributions_all.distribution_line_number left join apps.ap_batches_all ap_batches_all on ap_invoices_all.batch_id = ap_batches_all.batch_id left join apps.iby_payment_methods_tl iby_payment_methods_tl on ap_invoices_all.payment_method_code = iby_payment_methods_tl.payment_method_code and coalesce(iby_payment_methods_tl.language, 'US') = 'US' left join apps.ap_lookup_codes ap_lookup_codes on ap_lookup_codes.lookup_type = 'INVOICE TYPE' and ap_lookup_codes.lookup_code = ap_invoices_all.invoice_type_lookup_code left join apps.po_distributions_all po_distributions_all on ap_invoice_distributions_all.po_distribution_id = po_distributions_all.po_distribution_id left join apps.fnd_lookup_values fnd_lookup_values on fnd_lookup_values.lookup_type = 'INVOICE TYPE' and fnd_lookup_values.language = 'US' and ap_invoices_all.invoice_type_lookup_code = fnd_lookup_values.lookup_code left join apps.po_lines_all po_lines_all on po_distributions_all.po_line_id = po_lines_all.po_line_id left join apps.po_line_locations_all po_line_locations_all on po_line_locations_all.line_location_id = po_distributions_all.line_location_id left join apps.ap_lookup_codes ap_lookup_codes1 on ap_lookup_codes1.lookup_type = 'POSTING STATUS' and ap_lookup_codes1.lookup_code = ap_invoice_distributions_all.posted_flag left join apps.ap_lookup_codes ap_lookup_codes2 on ap_lookup_codes2.lookup_type = 'INVOICE DISTRIBUTION TYPE' and ap_lookup_codes2.lookup_code = ap_invoice_distributions_all.line_type_lookup_code left join apps.ap_lookup_codes ap_lookup_codes3 on ap_lookup_codes3.lookup_type = 'INVOICE LINE TYPE' and ap_lookup_codes3.lookup_code = ap_invoice_lines_all.line_type_lookup_code left join apps.po_headers_all po_headers_all on po_distributions_all.po_header_id = po_headers_all.po_header_id left join apps.gl_ledgers cledgers on cledgers.ledger_id = ap_invoices_all.set_of_books_id left join apps.ap_terms_tl ap_terms_tl on ap_invoices_all.terms_id = ap_terms_tl.term_id and coalesce(ap_terms_tl.language, 'US') = 'US' left join ( select apsa.invoice_id, apsa.amount_remaining, apsa.due_date from apps.ap_payment_schedules_all apsa where apsa.payment_num = ( select max(payment_num) from apps.ap_payment_schedules_all where apsa.invoice_id = ap_payment_schedules_all.invoice_id ) ) orm on ap_invoices_all.invoice_id = orm.invoice_id WHERE 1=1 AND ( ap_invoices_all.last_update_date::date >= substring('$LAST_RUN_DATE$',1,10)::date OR ap_invoice_lines_all.last_update_date::date >= substring('$LAST_RUN_DATE$',1,10)::date OR ap_invoice_distributions_all.last_update_date::date >= substring('$LAST_RUN_DATE$',1,10)::date )
)

        select *
        from fact_ap_trans_f_stg;
