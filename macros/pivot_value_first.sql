{% macro pivot_value_first(column, values, then_value, else_value='0', agg='sum',prefix='media_', quote_values=true) -%}
  {%- for val in values -%}
    {%- if quote_values -%}
      {{ agg }}(CASE WHEN {{ column }} = '{{ val }}' THEN {{ then_value }} ELSE {{ else_value }} END) AS {{ prefix }}{{ val }}_{{ then_value }}{% if not loop.last %}, {% endif %}
    {%- else -%}
      {{ agg }}(CASE WHEN {{ column }} = {{ val }} THEN {{ then_value }} ELSE {{ else_value }} END) AS {{ prefix }}{{ val }}_{{ then_value }}{% if not loop.last %}, {% endif %}
    {%- endif -%}
  {%- endfor -%}
{%- endmacro %}
