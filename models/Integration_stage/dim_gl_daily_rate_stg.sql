{{ config(materialized="table", unique_key="integration_id") }}

        {% do mkTruncate_stage_table() %}

        {% set src_tables = ['gl_daily_rate'] %}
        {% set last_update_date = mkget_last_update_date(src_tables) %}

        with
            gl_daily_rate as (
    select * from {{ ref("gl_daily_rate") }}
),
dim_gl_daily_rate_stg as (
select gl_daily_rate.from_currency as from_currency, gl_daily_rate.to_currency as to_currency, gl_daily_rate.conversion_date as conversion_dt, gl_daily_rate.conversion_type as conversion_type, gl_daily_rate.conversion_rate as conversion_rate, gl_daily_rate.status_code as status_code, gl_daily_rate.creation_date as creation_dt, gl_daily_rate.created_by as created_by, gl_daily_rate.last_update_date as last_update_dt, gl_daily_rate.last_updated_by as last_updated_by, gl_daily_rate.last_update_login as last_update_login, gl_daily_rate.context as context, gl_daily_rate.rate_source_code as rate_source_code, coalesce(gl_daily_rate.conversion_type, '') || '~' || coalesce(gl_daily_rate.from_currency, '') || '~' || coalesce(gl_daily_rate.to_currency, '') || '~' || to_char(gl_daily_rate.conversion_date::timestamp, 'mmddyyyy') as integration_id, 1000 as datasource_num_id from gl_daily_rate where 1 = 1
)

        select *
        from dim_gl_daily_rate_stg;
