{{ config(materialized='table') }}

    with
    invoice_date as (
    select * from {{ ref("invoice_date") }}
),
ap_invoices_all as (
    select * from {{ ref("ap_invoices_all") }}
),
ap_batches_all as (
    select * from {{ ref("ap_batches_all") }}
),
iby_payment_methods_tl as (
    select * from {{ ref("iby_payment_methods_tl") }}
),
ap_lookup_codes as (
    select * from {{ ref("ap_lookup_codes") }}
),
ap_invoice_lines_all as (
    select * from {{ ref("ap_invoice_lines_all") }}
),
ap_invoice_distributions_all as (
    select * from {{ ref("ap_invoice_distributions_all") }}
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
gl_ledgers as (
    select * from {{ ref("gl_ledgers") }}
),
ap_terms_tl as (
    select * from {{ ref("ap_terms_tl") }}
),
ap_payment_schedules_all as (
    select * from {{ ref("ap_payment_schedules_all") }}
),
ct_ap_trans_f_stg as (
    SELECT COALESCE(CAST(ap_invoices_all.vendor_id AS VARCHAR), '0') || '~' || COALESCE(CAST(ap_invoices_all.vendor_site_id AS VARCHAR), '0') AS supplier_id, CAST(ap_invoices_all.set_of_books_id AS VARCHAR) AS ledger_id, CAST(ap_invoices_all.legal_entity_id AS VARCHAR) AS legal_entity_id, CAST(TO_CHAR(ap_invoices_all.invoice_date, 'YYYYMMDD') AS INT) AS invoice_dt_id, CAST(TO_CHAR(orm.due_date, 'YYYYMMDD') AS INT) AS payment_due_dt_id, CAST(TO_CHAR(ap_invoices_all.gl_date, 'YYYYMMDD') AS INT) AS gl_dt_id, CAST(TO_CHAR(ap_invoice_distributions_all.accounting_date, 'YYYYMMDD') AS INT) AS accounting_dt_id, COALESCE(CAST(ap_invoices_all.accts_pay_code_combination_id AS VARCHAR), '0') AS glcc_liab_id, COALESCE(CAST(ap_invoice_distributions_all.dist_code_combination_id AS VARCHAR), '0') AS glcc_expense_id, CAST(ap_invoices_all.org_id AS VARCHAR) AS bu_id, CAST(ap_invoices_all.org_id AS VARCHAR) AS org_id, ap_invoices_all.project_id, ap_invoices_all.task_id, COALESCE(CAST(ap_invoice_lines_all.inventory_item_id AS VARCHAR), '0') AS product_id, TO_CHAR(ap_invoices_all.invoice_date, 'Mon-YY') AS period_name, EXTRACT(YEAR FROM invoice_date) AS period_year, EXTRACT(MONTH FROM invoice_date) AS period_num, '' AS supplier_num, '' AS supplier_name, '' AS supplier_site_num, '' AS supplier_site_name, '' AS supplier_contact, cledgers.name AS ledger_name, ap_invoices_all.invoice_id, ap_invoices_all.invoice_num, ap_invoices_all.description AS invoice_desc, ap_invoice_lines_all.line_number AS invoice_line_num, ap_invoice_distributions_all.distribution_line_number AS dist_line_num, ap_invoices_all.invoice_currency_code AS inv_curr_code, cledgers.currency_code AS ledger_curr_code, ap_invoices_all.payment_currency_code, ap_invoices_all.invoice_date AS invoice_dt, ap_invoices_all.gl_date AS gl_dt, ap_invoice_distributions_all.accounting_date, orm.due_date AS payment_due_dt, '' AS org_num, '' AS org_name, '' AS bu_num, '' AS bu_name, '' AS legal_entity_num, '' AS legal_entity_name, '' AS glcc_liab_concat, '' AS liab_segment1, '' AS liab_segment2, '' AS liab_segment3, '' AS liab_segment4, '' AS liab_segment5, '' AS liab_segment6, '' AS liab_segment7, '' AS liab_segment8, '' AS liab_segment9, '' AS glcc_exp_concat, '' AS exp_segment1, '' AS exp_segment2, '' AS exp_segment3, '' AS exp_segment4, '' AS exp_segment5, '' AS exp_segment6, '' AS exp_segment7, '' AS exp_segment8, '' AS exp_segment9, ap_invoices_all.source AS inv_source, ap_invoices_all.invoice_type_lookup_code AS inv_type_code, ap_lookup_codes.displayed_field AS inv_type_name, '' AS transaction_sub_type, ap_terms_tl.name AS payment_terms, ap_invoices_all.payment_method_code, iby_payment_methods_tl.payment_method_name AS payment_method_desc, ap_invoices_all.payment_status_flag, CASE WHEN ap_invoices_all.payment_status_flag = 'Y' THEN 'Paid' WHEN ap_invoices_all.payment_status_flag = 'N' THEN 'Not Paid' WHEN ap_invoices_all.payment_status_flag = 'P' THEN 'Partially paid' END AS payment_status, ap_invoices_all.wfapproval_status AS approval_status, ap_invoices_all.goods_received_date, ap_invoices_all.invoice_received_date, ap_invoices_all.exchange_rate, ap_invoices_all.attribute_category AS header_category_code, ap_invoices_all.cancelled_date, ap_invoices_all.cancelled_by, '' AS project_name, '' AS task_name, ap_invoice_lines_all.line_type_lookup_code, ap_lookup_codes3.displayed_field AS line_type_lookup_desc, ap_invoice_lines_all.line_source, '' AS line_source_desc, '-' AS product_num, '-' AS product_name, '-' AS product_desc, po_line_locations_all.unit_meas_lookup_code AS uom_code, '-' AS uom_desc, ap_invoice_lines_all.cancelled_flag AS line_cancelled_flag, ap_invoice_distributions_all.type_1099, '-' AS line_category_code, '-' AS accrual_posted_flag, '-' AS cash_posted_flag, '-' AS dist_glcc_concat, ap_invoice_distributions_all.posted_flag, '-' AS dist_category_code, po_headers_all.po_header_id, po_headers_all.segment1 AS po_number, po_lines_all.po_line_id, po_lines_all.line_num AS po_line_num, po_line_locations_all.line_location_id AS po_line_location_id, '-' AS po_shipment_num, ap_invoice_distributions_all.po_distribution_id, '' AS rcv_transaction_id, '-' AS po_receipt_num, ap_invoice_distributions_all.dist_match_type AS match_type, '' AS po_release_id, COALESCE(ap_invoice_distributions_all.unit_price, 0) AS unit_price, COALESCE(ap_invoice_distributions_all.quantity_invoiced, 0) AS quantity_invoiced, COALESCE(ap_invoices_all.invoice_amount, 0) AS inv_amount, COALESCE(ap_invoice_lines_all.amount, 0) AS inv_line_amount, COALESCE(ap_invoice_distributions_all.amount, 0) AS inv_dist_line_amount, CASE WHEN ap_invoices_all.invoice_currency_code = cledgers.currency_code THEN COALESCE(ap_invoices_all.invoice_amount, 0) ELSE COALESCE(ap_invoices_all.invoice_amount, 0) * ap_invoices_all.exchange_rate END AS inv_ledger_amount, COALESCE(ap_invoices_all.amount_paid, 0) AS paid_amount, COALESCE(orm.amount_remaining, 0) AS remaining_due_amount, COALESCE(ap_invoices_all.amount_applicable_to_discount, 0) AS amt_applicable_to_disc, COALESCE(ap_invoices_all.base_amount, 0) AS base_amount, 0 AS inv_amount_usd, 0 AS inv_line_amount_usd, 0 AS inv_dist_line_amount_usd, 0 AS inv_ledger_amount_usd, 0 AS paid_amount_usd, 0 AS remaining_due_amount_usd, 0 AS conv_rate_to_usd, '' AS conv_rate_type, ap_invoices_all.creation_date AS creation_dt, ap_invoices_all.last_update_date AS last_update_dt, ap_invoices_all.created_by, ap_invoices_all.last_updated_by, 'INV~' || CAST(ap_invoices_all.invoice_id AS VARCHAR) || '~' || CAST(ap_invoice_lines_all.line_number AS VARCHAR) || '~' || CAST(ap_invoice_distributions_all.invoice_distribution_id AS VARCHAR) AS integration_id, 1000 AS datasource_num_id, '' AS trans_amt, '' AS transaction_status, fnd_lookup_values.meaning AS transaction_type, COALESCE(ap_invoices_all.discount_amount_taken, 0) AS discount_amount_taken, 'N' AS delete_flag, getdate() as w_insert_dt, getdate() as w_update_dt FROM ap_invoices_all LEFT JOIN ap_batches_all ON ap_invoices_all.batch_id = ap_batches_all.batch_id LEFT JOIN iby_payment_methods_tl ON ap_invoices_all.payment_method_code = iby_payment_methods_tl.payment_method_code AND iby_payment_methods_tl.language = 'US' LEFT JOIN ap_lookup_codes ON ap_lookup_codes.lookup_type = 'INVOICE TYPE' AND ap_lookup_codes.lookup_code = ap_invoices_all.invoice_type_lookup_code LEFT JOIN ap_invoice_lines_all ON ap_invoices_all.invoice_id = ap_invoice_lines_all.invoice_id LEFT JOIN ap_invoice_distributions_all ON ap_invoice_lines_all.invoice_id = ap_invoice_distributions_all.invoice_id AND ap_invoice_lines_all.line_number = ap_invoice_distributions_all.distribution_line_number LEFT JOIN po_distributions_all ON ap_invoice_distributions_all.po_distribution_id = po_distributions_all.po_distribution_id LEFT JOIN fnd_lookup_values ON fnd_lookup_values.lookup_type = 'INVOICE TYPE' AND fnd_lookup_values.language = 'US' AND ap_invoices_all.invoice_type_lookup_code = fnd_lookup_values.lookup_code LEFT JOIN po_lines_all ON po_distributions_all.po_line_id = po_lines_all.po_line_id LEFT JOIN po_line_locations_all ON po_line_locations_all.line_location_id = po_distributions_all.line_location_id LEFT JOIN ap_lookup_codes ap_lookup_codes1 ON ap_lookup_codes1.lookup_type = 'POSTING STATUS' AND ap_lookup_codes1.lookup_code = ap_invoice_distributions_all.posted_flag LEFT JOIN ap_lookup_codes ap_lookup_codes2 ON ap_lookup_codes2.lookup_type = 'INVOICE DISTRIBUTION TYPE' AND ap_lookup_codes2.lookup_code = ap_invoice_distributions_all.line_type_lookup_code LEFT JOIN ap_lookup_codes ap_lookup_codes3 ON ap_lookup_codes3.lookup_type = 'INVOICE LINE TYPE' AND ap_lookup_codes3.lookup_code = ap_invoice_lines_all.line_type_lookup_code LEFT JOIN po_headers_all ON po_distributions_all.po_header_id = po_headers_all.po_header_id LEFT JOIN gl_ledgers cledgers ON cledgers.ledger_id = ap_invoices_all.set_of_books_id LEFT JOIN ap_terms_tl ON ap_invoices_all.terms_id = ap_terms_tl.term_id AND ap_terms_tl.language = 'US' LEFT JOIN ( SELECT invoice_id, amount_remaining, due_date FROM ( SELECT invoice_id, amount_remaining, due_date, ROW_NUMBER() OVER (PARTITION BY invoice_id ORDER BY payment_num DESC) AS rn FROM ap_payment_schedules_all ) x WHERE rn = 1 ) orm ON ap_invoices_all.invoice_id = orm.invoice_id WHERE 1=1 AND ( ap_invoices_all.last_update_date >= TO_DATE('$LAST_RUN_DATE$', 'YYYY-MM-DD') OR ap_invoice_lines_all.last_update_date >= TO_DATE('$LAST_RUN_DATE$', 'YYYY-MM-DD') OR ap_invoice_distributions_all.last_update_date >= TO_DATE('$LAST_RUN_DATE$', 'YYYY-MM-DD') )
)
    select * from ct_ap_trans_f_stg;
