{% snapshot reactivated_user_sessions_snapshot %}

{{
    config(
        target_schema='snapshots',
        unique_key='reactivation_event_id',
        strategy='check',
        check_cols=['reactivation_flag', 'gap_days']
    )
}}

WITH ordered_sessions AS (
  SELECT
    party_id,
    session_id,
    session_starts,
    last_session_activity,
    start_date,
    end_date,
    ROW_NUMBER() OVER (
      PARTITION BY party_id 
      ORDER BY session_starts
    ) AS session_number,
    LAG(last_session_activity) OVER (
      PARTITION BY party_id 
      ORDER BY session_starts
    ) AS previous_session_end
  FROM {{ ref('stg_cart_sessions_from_seed') }}
  WHERE is_deleted = 'False'
),

reactivated_sessions AS (
  SELECT *,
    DATEDIFF(DAY, previous_session_end, session_starts) AS gap_days
  FROM ordered_sessions
  WHERE session_number > 1
    AND DATEDIFF(DAY, previous_session_end, session_starts) > 30
)

SELECT
  MD5(CONCAT_WS('|', party_id, session_id, session_starts)) AS reactivation_event_id,
  party_id,
  session_id,
  session_starts,
  last_session_activity,
  start_date AS engagement_timestamp,
  end_date,
  session_number,
  previous_session_end,
  gap_days,
  'reactivated' AS reactivation_flag
FROM reactivated_sessions

{% endsnapshot %}
