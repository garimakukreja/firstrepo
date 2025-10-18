{% macro incremental_filter_condition(column_name) %}
    {% if is_incremental() %}
        WHERE {{ column_name }} > (SELECT COALESCE(MAX({{ column_name }}), '1900-01-01') FROM {{ this }})
    {% endif %}
{% endmacro %}
