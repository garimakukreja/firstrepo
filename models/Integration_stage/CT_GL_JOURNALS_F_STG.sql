{{ config(materialized='table') }}

    with
    gl_je_lines as (
    select * from {{ ref("gl_je_lines") }}
),
gl_je_headers as (
    select * from {{ ref("gl_je_headers") }}
),
gl_je_batches as (
    select * from {{ ref("gl_je_batches") }}
),
fnd_user as (
    select * from {{ ref("fnd_user") }}
),
gl_code_combinations as (
    select * from {{ ref("gl_code_combinations") }}
),
gl_ledgers as (
    select * from {{ ref("gl_ledgers") }}
),
gl_periods as (
    select * from {{ ref("gl_periods") }}
),
gl_je_sources as (
    select * from {{ ref("gl_je_sources") }}
),
gl_je_categories as (
    select * from {{ ref("gl_je_categories") }}
),
ct_gl_journals_f_stg as (
    SELECT CAST(cje_lines.ledger_id AS VARCHAR(50)) AS ledger_id, CAST(gl_code_combinations.code_combination_id AS VARCHAR(50)) AS glcc_id, CAST( COALESCE( TO_CHAR( TO_DATE(cje_lines.effective_date, 'DD-MM-YY'), 'YYYYMMDD' ), '0' ) AS INTEGER ) AS period_dt, CAST( COALESCE( TO_CHAR( TO_DATE(cje_lines.effective_date, 'DD-MM-YY'), 'YYYYMMDD' ), '0' ) AS INTEGER ) AS accounting_dt, CAST( COALESCE( TO_CHAR( TO_DATE(cje_headers.posted_date, 'DD-MM-YY'), 'YYYYMMDD' ), '0' ) AS INTEGER ) AS posted_dt, cledgers.name AS ledger_name, cje_lines.period_name AS period_name, cperiods.period_year AS period_year, cperiods.period_num AS period_num, gl_code_combinations.segment1 AS segment1, gl_code_combinations.segment2 AS segment2, gl_code_combinations.segment3 AS segment3, gl_code_combinations.segment4 AS segment4, gl_code_combinations.segment5 AS segment5, gl_code_combinations.segment6 AS segment6, gl_code_combinations.segment7 AS segment7, gl_code_combinations.segment8 AS segment8, gl_code_combinations.segment9 AS segment9, cledgers.currency_code AS ledger_curr_code, cje_headers.currency_code AS trans_curr_code, cje_batches.name AS je_batch_name, cje_batches.status AS je_batch_status, cje_lines.description AS je_batch_desc, cje_headers.je_source AS je_batch_source, cje_headers.period_name AS je_batch_period_name, cje_headers.posted_date AS je_batch_posted_dt, cje_batches.default_effective_date AS je_batch_accounting_dt, cje_batches.approval_status_code AS je_batch_approval_status, cje_lines.je_header_id AS je_header_id, cje_lines.je_line_num AS je_line_num, cje_headers.name AS je_header_name, cje_headers.description AS je_header_description, gl_je_sources.user_je_source_name AS je_hdr_source, COALESCE( gl_je_categories.user_je_category_name, cje_headers.je_category ) AS je_hdr_category, cje_headers.external_reference AS je_hdr_source_ref, CAST(NULL AS VARCHAR(200)) AS je_hdr_reference, cje_headers.status AS je_hdr_status, cje_headers.period_name AS je_hdr_period_name, cje_headers.posted_date AS je_hdr_posted_dt, cje_headers.default_effective_date AS je_hdr_accounting_dt, cje_headers.actual_flag AS actual_flag, cje_batches.status_verified AS status_verified, cje_lines.status AS je_line_status, cje_lines.description AS je_line_description, cje_headers.period_name AS je_line_period_name, cje_lines.effective_date AS je_line_accounting_dt, CAST(NULL AS VARCHAR(200)) AS je_line_currency_code, cje_headers.currency_conversion_rate AS je_line_conv_rate, cje_headers.currency_conversion_type AS je_line_conv_type, cje_headers.currency_conversion_date AS je_line_conv_dt, COALESCE(cje_lines.entered_dr, 0) AS entered_dr, COALESCE(cje_lines.entered_cr, 0) AS entered_cr, COALESCE(cje_lines.accounted_dr, 0) AS accounted_dr, COALESCE(cje_lines.accounted_cr, 0) AS accounted_cr, 0 AS entered_dr_usd, 0 AS entered_cr_usd, CAST(NULL AS DECIMAL(18,6)) AS conv_rate_to_usd, CAST(NULL AS VARCHAR(200)) AS conv_rate_type, cje_lines.creation_date AS creation_dt, cje_lines.last_update_date AS last_update_dt, cje_lines.created_by AS created_by, cje_lines.last_updated_by AS last_updated_by, CAST(cje_lines.je_header_id AS VARCHAR(50)) || '~' || CAST(cje_lines.je_line_num AS VARCHAR(50)) AS integration_id, 1000 AS datasource_num_id, CAST(NULL AS DECIMAL(18,2)) AS accounted_cr_usd, CAST(NULL AS DECIMAL(18,2)) AS accounted_dr_usd, cje_lines.period_name || '~' || cledgers.period_set_name AS period_id FROM gl_je_lines cje_lines INNER JOIN gl_je_headers cje_headers ON cje_lines.je_header_id = cje_headers.je_header_id INNER JOIN gl_je_batches cje_batches ON cje_headers.je_batch_id = cje_batches.je_batch_id LEFT JOIN fnd_user cuser ON cje_lines.created_by = cuser.user_id INNER JOIN gl_code_combinations ON gl_code_combinations.code_combination_id = cje_lines.code_combination_id INNER JOIN gl_ledgers cledgers ON cledgers.ledger_id = cje_headers.ledger_id INNER JOIN gl_periods cperiods ON cje_lines.period_name = cperiods.period_name AND cperiods.period_set_name = cje_batches.period_set_name LEFT JOIN gl_je_sources ON gl_je_sources.je_source_name = cje_headers.je_source LEFT JOIN gl_je_categories ON gl_je_categories.je_category_name = cje_headers.je_category WHERE 1 = 1 AND ( CAST(cje_headers.last_update_date AS TIMESTAMP) >= TO_TIMESTAMP('$LAST_RUN_DATE$', 'YYYY-MM-DD') OR CAST(cje_lines.last_update_date AS TIMESTAMP) >= TO_TIMESTAMP('$LAST_RUN_DATE$', 'YYYY-MM-DD') OR CAST(cje_batches.last_update_date AS TIMESTAMP) >= TO_TIMESTAMP('$LAST_RUN_DATE$', 'YYYY-MM-DD') )
)
    select * from ct_gl_journals_f_stg;
