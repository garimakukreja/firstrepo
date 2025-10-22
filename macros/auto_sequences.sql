{% macro create_sequences_for_sources(schema, start=1, increment=1, cache=100) %}
    {% for source in sources() %}
        {% set sequence_name = source.name ~ '_seq' %}
        create sequence if not exists {{ schema }}.{{ sequence_name }}
            start {{ start }}
            increment {{ increment }}
            minvalue {{ start }}
            no maxvalue
            cache {{ cache }};
    {% endfor %}
{% endmacro %}
