{{ config(materialized='table') }}

    with
    gl_balances as (
    select * from {{ ref("gl_balances") }}
),
gl_periods as (
    select * from {{ ref("gl_periods") }}
),
gl_ledgers as (
    select * from {{ ref("gl_ledgers") }}
),
gl_budget_versions as (
    select * from {{ ref("gl_budget_versions") }}
),
gl_code_combinations as (
    select * from {{ ref("gl_code_combinations") }}
),
ct_gl_budget_f_stg as (
    SELECT CAST(COALESCE(cbalances.ledger_id, 0) AS VARCHAR) AS ledger_id, CAST(COALESCE(cbalances.code_combination_id, 0) AS VARCHAR) AS glcc_id, COALESCE(cperiods.period_name, '0') || '~' || COALESCE(cperiods.period_set_name, '0') AS period_id, CAST( COALESCE( TO_CHAR(TO_DATE(cperiods.end_date, 'DD-MM-RR'), 'YYYYMMDD'), '0' ) AS INTEGER ) AS budget_month_id, cperiods.period_name AS budget_month, cbudget_versions.budget_name AS budget_name, cledgers.name AS ledger_name, cbalances.currency_code AS currency_code, gl_code_combinations.segment1 AS segment1, gl_code_combinations.segment2 AS segment2, gl_code_combinations.segment3 AS segment3, gl_code_combinations.segment4 AS segment4, gl_code_combinations.segment5 AS segment5, gl_code_combinations.segment6 AS segment6, gl_code_combinations.segment7 AS segment7, gl_code_combinations.segment8 AS segment8, COALESCE(cbalances.period_net_dr, 0) AS period_net_dr, COALESCE(cbalances.period_net_cr, 0) AS period_net_cr, (COALESCE(cbalances.period_net_dr, 0) - COALESCE(cbalances.period_net_cr, 0)) AS amount, cbudget_versions.creation_date AS creation_dt, cbudget_versions.last_update_date AS last_update_dt, cbudget_versions.created_by AS created_by, cbudget_versions.last_updated_by AS last_updated_by, cbudget_versions.budget_type AS type, NULL AS scenario, cbudget_versions.version_num AS version, cledgers.currency_code AS currency, NULL AS mgmt_reporting_line, NULL AS vew, NULL AS data_load_cube_name, COALESCE(CAST(cbalances.ledger_id AS VARCHAR), '0') || '~' || COALESCE(CAST(cbalances.code_combination_id AS VARCHAR), '0') || '~' || COALESCE(cbudget_versions.budget_name, '0') || '~' || COALESCE(cbalances.period_name, '0') || '~' || COALESCE(cbalances.currency_code, '0') AS integration_id, 1000 AS datasource_num_id FROM gl_balances cbalances JOIN gl_periods cperiods ON cbalances.actual_flag = 'B' AND cbalances.period_name = cperiods.period_name AND cbalances.period_type = cperiods.period_type JOIN gl_ledgers cledgers ON cperiods.period_set_name = cledgers.period_set_name AND cledgers.ledger_id = cbalances.ledger_id JOIN gl_budget_versions cbudget_versions ON cbudget_versions.budget_version_id = cbalances.budget_version_id JOIN gl_code_combinations gl_code_combinations ON cbalances.code_combination_id = gl_code_combinations.code_combination_id WHERE ( CAST(cbudget_versions.last_update_date AS TIMESTAMP) >= TO_TIMESTAMP('$LAST_RUN_DATE$', 'YYYY-MM-DD') OR CAST(cbalances.last_update_date AS TIMESTAMP) >= TO_TIMESTAMP('$LAST_RUN_DATE$', 'YYYY-MM-DD') )
)
    select * from ct_gl_budget_f_stg;
