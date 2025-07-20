{% macro segment_cart_age(timestamp_col) %}
  CASE
    WHEN DATEDIFF(MINUTE, {{ timestamp_col }}, CURRENT_TIMESTAMP) BETWEEN 1 AND 60 THEN 'HOT'
    WHEN DATEDIFF(MINUTE, {{ timestamp_col }}, CURRENT_TIMESTAMP) BETWEEN 61 AND 120 THEN 'WARM'
    ELSE 'COLD'
  END
{% endmacro %}

{% macro segment_cart_days(day_diff_col) %}
  CASE
    WHEN {{ day_diff_col }} BETWEEN 1 AND 2 THEN 'HOT'
    WHEN {{ day_diff_col }} BETWEEN 3 AND 7 THEN 'WARM'
    ELSE 'COLD'
  END
{% endmacro %}
