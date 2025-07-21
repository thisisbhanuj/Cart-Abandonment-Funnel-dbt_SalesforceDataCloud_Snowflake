{% snapshot snapshot_cart_sessions %}
{{
    config(
        target_schema='SNAPSHOTS',
        unique_key='session_id',
        strategy='timestamp',
        updated_at='last_session_activity',
        hard_deletes='new_record',
        snapshot_meta_column_names={
          "dbt_valid_from": "start_date",
          "dbt_valid_to": "end_date",
          "dbt_scd_id": "dbt_scd_id",
          "dbt_is_deleted": "is_deleted",
        } 
    )
}}

select * from {{ ref('stg_shopping_cart_scd2') }}

{% endsnapshot %}
