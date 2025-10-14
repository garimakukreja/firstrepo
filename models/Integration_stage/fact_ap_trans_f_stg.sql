{{ config(materialized="table", unique_key="integration_id") }}

       {# {% do mkTruncate_stage_table() %}

        {% set src_tables = ['ap_invoices_all', 'ap_invoice_lines_all', 'ap_invoice_distributions_all', 'ap_batches_all', 'iby_payment_method_translation', 'ap_lookup_codes', 'po_distributions_all', 'fnd_lookup_values', 'po_lines_all', 'po_line_locations_all', 'po_headers_all', 'gl_ledger', 'ap_terms_tl', 'ap_payment_schedules_all'] %}
        {% set last_update_date = mkget_last_update_date(src_tables) %}#}

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
    select * from {{ ref("iby_payment_method_translation") }}
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
select concat( coalesce(ap_invoices_all.vendor_id::varchar, '0'), '~', coalesce(ap_invoices_all.vendor_site_id::varchar, '0') ) as supplier_id, ap_invoices_all.set_of_books_id as ledger_id, ap_invoices_all.legal_entity_id as legal_entity_id, cast(to_char(ap_invoices_all.invoice_date, 'yyyymmdd') as int) as invoice_dt_id, cast(to_char(orm.due_date, 'yyyymmdd') as int) as payment_due_dt_id, cast(to_char(ap_invoices_all.gl_date, 'yyyymmdd') as int) as gl_dt_id, cast(to_char(ap_invoice_distributions_all.accounting_date, 'yyyymmdd') as int) as accounting_dt_id, coalesce(ap_invoices_all.accts_pay_code_combination_id, 0) as glcc_liab_id, coalesce(ap_invoice_distributions_all.dist_code_combination_id, 0) as glcc_expense_id, ap_invoices_all.org_id as bu_id, ap_invoices_all.org_id as org_id, ap_invoices_all.project_id as project_id, ap_invoices_all.task_id as task_id, coalesce(ap_invoice_lines_all.inventory_item_id, 0) as product_id, to_char(ap_invoices_all.invoice_date, 'mon-yy') as period_name, extract(year from ap_invoices_all.invoice_date) as period_year, extract(month from ap_invoices_all.invoice_date) as period_num, '' as supplier_num, '' as supplier_name, '' as supplier_site_num, '' as supplier_site_name, '' as supplier_contact, cledgers.name as ledger_name, ap_invoices_all.invoice_id as invoice_id, ap_invoices_all.invoice_num as invoice_num, ap_invoices_all.description as invoice_desc, ap_invoice_lines_all.line_number as invoice_line_num, ap_invoice_distributions_all.distribution_line_number as dist_line_num, ap_invoices_all.invoice_currency_code as inv_curr_code, cledgers.currency_code as ledger_curr_code, ap_invoices_all.payment_currency_code as payment_curr_code, ap_invoices_all.invoice_date as invoice_dt, ap_invoices_all.gl_date as gl_dt, ap_invoice_distributions_all.accounting_date as accounting_dt, orm.due_date as payment_due_dt, '' as org_num, '' as org_name, '' as bu_num, '' as bu_name, '' as legal_entity_num, '' as legal_entity_name, '' as legal_entity_name, '' as glcc_liab_concat, '' as liab_segment1, '' as liab_segment2, '' as liab_segment3, '' as liab_segment4, '' as liab_segment5, '' as liab_segment6, '' as liab_segment7, '' as liab_segment8, '' as liab_segment9, '' as glcc_exp_concat, '' as exp_segment1, '' as exp_segment2, '' as exp_segment3, '' as exp_segment4, '' as exp_segment5, '' as exp_segment6, '' as exp_segment7, '' as exp_segment8, '' as exp_segment9, ap_invoices_all.source as inv_source, ap_invoices_all.invoice_type_lookup_code as inv_type_code, ap_lookup_codes.displayed_field as inv_type_name, '' as transaction_sub_type, ap_terms_tl.name as payment_terms, ap_invoices_all.payment_method_code as payment_method_code, iby_payment_method_translation.payment_method_name as payment_method_desc, ap_invoices_all.payment_status_flag as payment_status_flag, case when ap_invoices_all.payment_status_flag = 'y' then 'paid' when ap_invoices_all.payment_status_flag = 'n' then 'not paid' when ap_invoices_all.payment_status_flag = 'p' then 'partially paid' end as payment_status, ap_invoices_all.wfapproval_status as approval_status, ap_invoices_all.goods_received_date as goods_received_dt, ap_invoices_all.invoice_received_date as invoice_received_dt, ap_invoices_all.exchange_rate as exch_rate, ap_invoices_all.attribute_category as header_category_code, ap_invoices_all.cancelled_date as cancelled_dt, ap_invoices_all.cancelled_by as cancelled_by, '' as project_name, '' as task_name, ap_invoice_lines_all.line_type_lookup_code as line_type_lookup_code, ap_lookup_codes3.displayed_field as line_type_lookup_desc, ap_invoice_lines_all.line_source as line_source, '' as line_source_desc, '-' as product_num, '-' as product_name, '-' as product_desc, po_line_locations_all.unit_meas_lookup_code as uom_code, '-' as uom_desc, ap_invoice_lines_all.cancelled_flag as line_cancelled_flag, ap_invoice_distributions_all.type_1099 as type_1099, '-' as line_category_code, '-' as accrual_posted_flag, '-' as cash_posted_flag, '-' as dist_glcc_concat, ap_invoice_distributions_all.posted_flag as posted_flag, '-' as dist_category_code, po_headers_all.po_header_id as po_header_id, po_headers_all.segment1 as po_number, po_lines_all.po_line_id as po_line_id, po_lines_all.line_num as po_line_num, po_line_locations_all.line_location_id as po_line_location_id, '-' as po_shipment_num, ap_invoice_distributions_all.po_distribution_id as po_distribution_id, '' as rcv_transaction_id, '-' as po_receipt_num, ap_invoice_distributions_all.dist_match_type as match_type, '' as po_release_id, coalesce(ap_invoice_distributions_all.unit_price, 0) as unit_price, coalesce(ap_invoice_distributions_all.quantity_invoiced, 0) as quantity_invoiced, coalesce(ap_invoices_all.invoice_amount, 0) as inv_amount, coalesce(ap_invoice_lines_all.amount, 0) as inv_line_amount, coalesce(ap_invoice_distributions_all.amount, 0) as inv_dist_line_amount, case when ap_invoices_all.invoice_currency_code = cledgers.currency_code then coalesce(ap_invoices_all.invoice_amount, 0) else coalesce(ap_invoices_all.invoice_amount, 0) * ap_invoices_all.exchange_rate end as inv_ledger_amount, coalesce(ap_invoices_all.amount_paid, 0) as paid_amount, coalesce(orm.amount_remaining, 0) as remaining_due_amount, coalesce(ap_invoices_all.amount_applicable_to_discount, 0) as amt_applicable_to_disc, coalesce(ap_invoices_all.base_amount, 0) as base_amount, 0 as inv_amount_usd, 0 as inv_line_amount_usd, 0 as inv_dist_line_amount_usd, 0 as inv_ledger_amount_usd, 0 as paid_amount_usd, 0 as remaining_due_amount_usd, 0 as conv_rate_to_usd, '' as conv_rate_type, ap_invoices_all.creation_date as creation_dt, ap_invoices_all.last_update_date as last_update_dt, ap_invoices_all.created_by as created_by, ap_invoices_all.last_updated_by as last_updated_by, coalesce(ap_invoice_distributions_all.invoice_distribution_id, 0) as integration_id, 1000 as datasource_num_id, '' as trans_amt, '' as transaction_status, fnd_lookup_values.meaning as transaction_type, coalesce(ap_invoices_all.discount_amount_taken, 0) as discount_amount_taken, ap_invoices_all.doc_sequence_value as voucher_num, 'n' as delete_flag, current_date as w_insert_dt, current_date as w_update_dt from apps.ap_invoices_all ap_invoices_all inner join apps.ap_invoice_lines_all ap_invoice_lines_all on ap_invoices_all.invoice_id = ap_invoice_lines_all.invoice_id inner join apps.ap_invoice_distributions_all ap_invoice_distributions_all on ap_invoice_lines_all.invoice_id = ap_invoice_distributions_all.invoice_id and ap_invoice_lines_all.line_number = ap_invoice_distributions_all.distribution_line_number left join apps.ap_batches_all ap_batches_all on ap_invoices_all.batch_id = ap_batches_all.batch_id left join apps.iby_payment_method_translation iby_payment_method_translation on ap_invoices_all.payment_method_code = iby_payment_method_translation.payment_method_code and coalesce(iby_payment_method_translation.language, 'us') = 'us' left join apps.ap_lookup_codes ap_lookup_codes on ap_lookup_codes.lookup_type = 'invoice type' and ap_lookup_codes.lookup_code = ap_invoices_all.invoice_type_lookup_code left join apps.po_distributions_all po_distributions_all on ap_invoice_distributions_all.po_distribution_id = po_distributions_all.po_distribution_id left join apps.fnd_lookup_values fnd_lookup_values on fnd_lookup_values.lookup_type = 'invoice type' and fnd_lookup_values.language = 'us' and ap_invoices_all.invoice_type_lookup_code = fnd_lookup_values.lookup_code left join apps.po_lines_all po_lines_all on po_distributions_all.po_line_id = po_lines_all.po_line_id left join apps.po_line_locations_all po_line_locations_all on po_line_locations_all.line_location_id = po_distributions_all.line_location_id left join apps.ap_lookup_codes ap_lookup_codes1 on ap_lookup_codes1.lookup_type = 'posting status' and ap_lookup_codes1.lookup_code = ap_invoice_distributions_all.posted_flag left join apps.ap_lookup_codes ap_lookup_codes2 on ap_lookup_codes2.lookup_type = 'invoice distribution type' and ap_lookup_codes2.lookup_code = ap_invoice_distributions_all.line_type_lookup_code left join apps.ap_lookup_codes ap_lookup_codes3 on ap_lookup_codes3.lookup_type = 'invoice line type' and ap_lookup_codes3.lookup_code = ap_invoice_lines_all.line_type_lookup_code left join apps.po_headers_all po_headers_all on po_distributions_all.po_header_id = po_headers_all.po_header_id left join apps.gl_ledger cledgers on cledgers.ledger_id = ap_invoices_all.set_of_books_id left join apps.ap_terms_tl ap_terms_tl on ap_invoices_all.terms_id = ap_terms_tl.term_id and coalesce(ap_terms_tl.language, 'us') = 'us' left join ( select apsa.invoice_id, apsa.amount_remaining, apsa.due_date from apps.ap_payment_schedules_all apsa where apsa.payment_num = ( select max(payment_num) from apps.ap_payment_schedules_all where apsa.invoice_id = ap_payment_schedules_all.invoice_id ) ) orm on ap_invoices_all.invoice_id = orm.invoice_id where 1=1 and ( ap_invoices_all.last_update_date::date >= substring('$last_run_date$',1,10)::date or ap_invoice_lines_all.last_update_date::date >= substring('$last_run_date$',1,10)::date or ap_invoice_distributions_all.last_update_date::date >= substring('$last_run_date$',1,10)::date )
)

        select *
        from fact_ap_trans_f_stg;
