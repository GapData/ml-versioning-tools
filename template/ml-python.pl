{% macro write_python(cell_content) -%}
    {% set pythonized = cell.source | filter_no_effect | ipython2python %}
     {%- for line in pythonized.split('\n') -%}
     {% if line %}
        {{ line.replace('\n', '') }}{% endif %}
     {%- endfor -%}
{%- endmacro %}

{%- if 'metadata' in resources -%}
# Generated from {{ resources['metadata'].get('path') }}/{{ resources['metadata'].get('name') }}.ipynb
{%- endif -%}

{# Write main function with optional parameters and docstring #}
{% set func_name = resources.get('metadata', {'name': 'input_func'}).get('name') | sanitize_method_name %}
{%- set docstring_wrapper = nb.cells | handle_params -%}
def {{ func_name }}({{ docstring_wrapper.params }}):
{%- if docstring_wrapper.params -%}
{%- for line in docstring_wrapper.docstring_by_line %}
    {{ line }}
{%- endfor %}
{% endif -%}
{# Write notebook body #}
{%- for cell in nb.cells %}
{%- if cell.cell_type != 'code' %}
    {{ cell.source | comment_lines }}
{%- else %}
    {% set pythonized = cell.source | filter_no_effect | ipython2python %}
    {%- for line in pythonized.split('\n') -%}
    {%- if line -%}
    {{ line.replace('\n', '') }}
    {% endif %}
    {%- endfor -%}
{%- endif -%}
{%- endfor -%}
