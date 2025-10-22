{% macro create_sequence(schema, sequence_name, start=1, increment=1, cache=100) %}
    create sequence if not exists {{ schema }}.{{ sequence_name }}
        start {{ start }}
        increment {{ increment }}
        minvalue {{ start }}
        no maxvalue
        cache {{ cache }};
{% endmacro %}

{% macro oracle_nextval(schema, sequence_name) %}
    nextval('{{ schema }}.{{ sequence_name }}')
{% endmacro %}

{% macro oracle_currval(schema, sequence_name) %}
    currval('{{ schema }}.{{ sequence_name }}')
{% endmacro %}
