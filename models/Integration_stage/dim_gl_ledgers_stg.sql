{{ config(materialized="table", unique_key="integration_id") }}

       {# {% do mkTruncate_stage_table() %}

        {% set src_tables = ['gl_ledger'] %}
        {% set last_update_date = mkget_last_update_date(src_tables) %}#}

        with
            gl_ledger as (
    select * from {{ ref("gl_ledger") }}
),
dim_gl_ledgers_stg as (
select glledgers_filter_a.ledger_id as ledger_id, glledgers_filter_a.chart_of_accounts_id as coa_id, glledgers_filter_a.name as ledger_name, glledgers_filter_a.short_name as ledger_short_name, glledgers_filter_a.description as description, glledgers_filter_a.ledger_category_code as ledger_category_code, case when glledgers_filter_a.object_type_code = 'l' then 'ledger' when glledgers_filter_a.object_type_code = 's' then 'ledger set' else glledgers_filter_a.object_type_code end as ledger_type, glledgers_filter_a.currency_code as ledger_curr_code, glledgers_filter_a.creation_date as creation_dt, glledgers_filter_a.last_update_date as last_update_dt, glledgers_filter_a.created_by as created_by, glledgers_filter_a.last_updated_by as last_updated_by, cast(glledgers_filter_a.ledger_id as varchar) as integration_id, 1000 as datasource_num_id, glledgers_filter_a.ledger_category_code as ledger_cat_code from staging.gl_ledger glledgers_filter_a
)

        select *
        from dim_gl_ledgers_stg;
