{{ config(materialized = 'table', tags = "GL") }} 
with gl_balances as (
  select 
    * 
  from 
    {{ ref("gl_balances") }}
), 
gl_ledgers as (
  select 
    * 
  from 
    {{ ref("gl_ledgers") }}
), 
gl_code_combinations as (
  select 
    * 
  from 
    {{ ref("gl_code_combinations") }}
), 
gl_periods as (
  select 
    * 
  from 
    {{ ref("gl_periods") }}
), 
gl_daily_rates as (
  select 
    * 
  from 
    {{ ref("gl_daily_rates") }}
), 
ct_gl_balances_f_stg as (
  select 
    to_char(
      gl_balances_reusable_mapping_s.ledger_id
    ) as ledger_id, 
    to_char(
      gl_code_combinations_reusable.code_combination_id
    ) as glcc_id, 
    nvl(
      gl_periods_reusable_mapping_st.period_name, 
      '0'
    )|| '~' || cledgers_reusable_mapping_stg.period_set_name as period_id, 
    cast(
      nvl(
        TO_CHAR(
          TO_DATE(
            gl_periods_reusable_mapping_st.end_date, 
            'DD-MM-RR'
          ), 
          'YYYYMMDD'
        ), 
        0
      ) as int
    ) as period_dt_id, 
    gl_balances_reusable_mapping_s.period_name as period_name, 
    gl_balances_reusable_mapping_s.period_year as period_year, 
    gl_balances_reusable_mapping_s.period_num as period_num, 
    cledgers_reusable_mapping_stg.name as ledger_name, 
    gl_code_combinations_reusable.segment1 as segment1, 
    gl_code_combinations_reusable.segment2 as segment2, 
    gl_code_combinations_reusable.segment3 as segment3, 
    gl_code_combinations_reusable.segment4 as segment4, 
    gl_code_combinations_reusable.segment5 as segment5, 
    gl_code_combinations_reusable.segment6 as segment6, 
    gl_code_combinations_reusable.segment7 as segment7, 
    gl_code_combinations_reusable.segment8 as segment8, 
    gl_code_combinations_reusable.segment9 as segment9, 
    gl_balances_reusable_mapping_s.currency_code as currency_code, 
    gl_balances_reusable_mapping_s.actual_flag as actual_flag, 
    case when coalesce(
      gl_balances_reusable_mapping_s.period_net_dr, 
      0
    ) > coalesce(
      gl_balances_reusable_mapping_s.period_net_cr, 
      0
    ) then 'DB' else 'CR' end as db_cr_ind, 
    gl_balances_reusable_mapping_s.translated_flag as translated_flag, 
    gl_balances_reusable_mapping_s.budget_version_id as budget_version_id, 
    gl_balances_reusable_mapping_s.encumbrance_type_id as encumbrance_type_id, 
    cast(
      null as varchar2(200)
    ) as encumbrance_type_name, 
    cast(
      null as varchar2(200)
    ) as summary_account_flag, 
    coalesce(
      gl_balances_reusable_mapping_s.period_net_dr, 
      0
    ) as period_net_dr, 
    coalesce(
      gl_balances_reusable_mapping_s.period_net_cr, 
      0
    ) as period_net_cr, 
    coalesce(
      gl_balances_reusable_mapping_s.begin_balance_dr, 
      0
    ) as begin_balance_dr, 
    coalesce(
      gl_balances_reusable_mapping_s.begin_balance_cr, 
      0
    ) as begin_balance_cr, 
    coalesce(
      gl_balances_reusable_mapping_s.begin_balance_cr, 
      0
    ) - coalesce(
      gl_balances_reusable_mapping_s.begin_balance_dr, 
      0
    ) as begin_balance, 
    (
      coalesce(
        gl_balances_reusable_mapping_s.begin_balance_cr, 
        0
      ) - coalesce(
        gl_balances_reusable_mapping_s.begin_balance_dr, 
        0
      )
    ) + (
      coalesce(
        gl_balances_reusable_mapping_s.period_net_cr, 
        0
      ) - coalesce(
        gl_balances_reusable_mapping_s.period_net_dr, 
        0
      )
    ) as end_balance, 
    coalesce(
      gl_balances_reusable_mapping_s.period_net_cr, 
      0
    ) - coalesce(
      gl_balances_reusable_mapping_s.period_net_dr, 
      0
    ) as period_activity, 
    coalesce(
      gl_balances_reusable_mapping_s.quarter_to_date_dr, 
      0
    ) as qtr_to_date_dr, 
    coalesce(
      gl_balances_reusable_mapping_s.quarter_to_date_cr, 
      0
    ) as qtr_to_date_cr, 
    coalesce(
      gl_balances_reusable_mapping_s.period_net_dr, 
      0
    ) * coalesce(
      gl_daily_rates.conversion_rate, 
      1
    ) as period_net_dr_usd, 
    coalesce(
      gl_balances_reusable_mapping_s.period_net_cr, 
      0
    ) * coalesce(
      gl_daily_rates.conversion_rate, 
      1
    ) as period_net_cr_usd, 
    (
      coalesce(
        gl_balances_reusable_mapping_s.begin_balance_cr, 
        0
      ) - coalesce(
        gl_balances_reusable_mapping_s.begin_balance_dr, 
        0
      )
    ) * coalesce(
      gl_daily_rates.conversion_rate, 
      1
    ) as begin_balance_usd, 
    (
      (
        coalesce(
          gl_balances_reusable_mapping_s.begin_balance_cr, 
          0
        ) - coalesce(
          gl_balances_reusable_mapping_s.begin_balance_dr, 
          0
        )
      ) + (
        coalesce(
          gl_balances_reusable_mapping_s.period_net_cr, 
          0
        ) - coalesce(
          gl_balances_reusable_mapping_s.period_net_dr, 
          0
        )
      )
    ) * coalesce(
      gl_daily_rates.conversion_rate, 
      1
    ) as end_balance_usd, 
    coalesce(
      gl_daily_rates.conversion_rate, 
      1
    ) as conv_rate_to_usd, 
    coalesce(
      gl_daily_rates.CONVERSION_TYPE, 
      'Corporate'
    ) as conv_rate_type, 
    cast(null as date) as creation_dt, 
    gl_balances_reusable_mapping_s.last_update_date as last_update_dt, 
    cast(
      null as varchar2(200)
    ) as created_by, 
    gl_balances_reusable_mapping_s.last_updated_by as last_updated_by, 
    coalesce(
      gl_balances_reusable_mapping_s.ledger_id, 
      0
    ) || '~' || coalesce(
      gl_balances_reusable_mapping_s.code_combination_id, 
      0
    ) || '~' || coalesce(
      gl_balances_reusable_mapping_s.period_name, 
      ' '
    ) || '~' || coalesce(
      gl_balances_reusable_mapping_s.actual_flag, 
      ' '
    ) || '~' || coalesce(
      gl_balances_reusable_mapping_s.translated_flag, 
      'X'
    ) || '~' || coalesce(
      gl_balances_reusable_mapping_s.currency_code, 
      ' '
    ) || '~' || coalesce(
      gl_balances_reusable_mapping_s.budget_version_id, 
      0
    ) as integration_id, 
    1000 as datasource_num_id, 
    'Y' as active_flag, 
    'N' as delete_flag 
  from 
    gl_balances gl_balances_reusable_mapping_s 
    inner join gl_ledgers cledgers_reusable_mapping_stg on GL_BALANCES_REUSABLE_MAPPING_S.LEDGER_ID = CLEDGERS_REUSABLE_MAPPING_STG.LEDGER_ID 
    inner join gl_code_combinations gl_code_combinations_reusable on GL_BALANCES_REUSABLE_MAPPING_S.CODE_COMBINATION_ID = GL_CODE_COMBINATIONS_REUSABLE.CODE_COMBINATION_ID 
    inner join gl_periods gl_periods_reusable_mapping_st on GL_PERIODS_REUSABLE_MAPPING_ST.PERIOD_SET_NAME = CLEDGERS_REUSABLE_MAPPING_STG.PERIOD_SET_NAME 
    AND GL_BALANCES_REUSABLE_MAPPING_S.PERIOD_NAME = GL_PERIODS_REUSABLE_MAPPING_ST.PERIOD_NAME 
    AND GL_BALANCES_REUSABLE_MAPPING_S.PERIOD_TYPE = GL_PERIODS_REUSABLE_MAPPING_ST.PERIOD_TYPE 
    left join gl_daily_rates on (
      GL_DAILY_RATES.FROM_CURRENCY = gl_balances_reusable_mapping_s.CURRENCY_CODE 
      and GL_DAILY_RATES.TO_CURRENCY = 'USD' 
      and GL_DAILY_RATES.CONVERSION_TYPE = 'Corporate' 
      and trunc(GL_DAILY_RATES.CONVERSION_DATE) = trunc(
        gl_periods_reusable_mapping_st.end_date
      )
    ) 
  where 
    (1 = 1) 
    and (
      COALESCE(
        gl_balances_reusable_mapping_s.translated_flag, 
        'X'
      ) IN ('Y', 'X', 'R') 
      AND gl_balances_reusable_mapping_s.actual_flag IN ('A') 
      AND gl_balances_reusable_mapping_s.template_id IS NULL 
      and cast(
        gl_balances_reusable_mapping_s.last_update_date as timestamp
      )>= TO_TIMESTAMP('$LAST_RUN_DATE$', 'YYYY-MM-DD')
    )
) 
select 
  * 
from 
  ct_gl_balances_f_stg
