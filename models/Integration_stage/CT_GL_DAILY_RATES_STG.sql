{{ config(materialized='table') }}

    with
    gl_daily_rates as (
    select * from {{ ref("gl_daily_rates") }}
),
ct_gl_daily_rates_stg as (
    SELECT gl_daily_rates.from_currency AS from_currency, gl_daily_rates.to_currency AS to_currency, gl_daily_rates.conversion_date AS conversion_dt, gl_daily_rates.conversion_type AS conversion_type, gl_daily_rates.conversion_rate AS conversion_rate, gl_daily_rates.status_code AS status_code, gl_daily_rates.creation_date AS creation_dt, gl_daily_rates.created_by AS created_by, gl_daily_rates.last_update_date AS last_update_dt, gl_daily_rates.last_updated_by AS last_updated_by, gl_daily_rates.last_update_login AS last_update_login, gl_daily_rates.context AS context, gl_daily_rates.rate_source_code AS rate_source_code, CONCAT( gl_daily_rates.conversion_type, '~', gl_daily_rates.from_currency, '~', gl_daily_rates.to_currency, '~', TO_CHAR(gl_daily_rates.conversion_date, 'MMDDYYYY') ) AS integration_id, 1000 AS datasource_num_id FROM gl_daily_rates WHERE 1 = 1
)
    select * from ct_gl_daily_rates_stg;
