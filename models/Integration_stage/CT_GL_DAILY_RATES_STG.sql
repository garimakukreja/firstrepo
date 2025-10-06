{{ config(materialized='table') }}

with gl_daily_rates as (
    select * from {{ ref("gl_daily_rates") }}
),

ct_gl_daily_rates_stg as (
    select
        gl_daily_rates.from_currency as from_currency,
        gl_daily_rates.to_currency as to_currency,
        gl_daily_rates.conversion_date as conversion_dt,
        gl_daily_rates.conversion_type as conversion_type,
        gl_daily_rates.conversion_rate as conversion_rate,
        gl_daily_rates.status_code as status_code,
        gl_daily_rates.creation_date as creation_dt,
        gl_daily_rates.created_by as created_by,
        gl_daily_rates.last_update_date as last_update_dt,
        gl_daily_rates.last_updated_by as last_updated_by,
        gl_daily_rates.last_update_login as last_update_login,
        gl_daily_rates.context as context,
        gl_daily_rates.rate_source_code as rate_source_code,

        -- ✅ Redshift-safe concatenation using explicit casts
        CAST(gl_daily_rates.conversion_type AS VARCHAR) 
        || '~' || 
        CAST(gl_daily_rates.from_currency AS VARCHAR)
        || '~' || 
        CAST(gl_daily_rates.to_currency AS VARCHAR)
        || '~' || 
        TO_CHAR(gl_daily_rates.conversion_date, 'MMDDYYYY') 
        AS integration_id,

        1000 as datasource_num_id
    from gl_daily_rates
)

select * from ct_gl_daily_rates_stg
