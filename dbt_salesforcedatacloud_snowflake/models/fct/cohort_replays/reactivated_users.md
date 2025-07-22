````markdown
# 🧠 fct_reactivated_users__cohort_monthly

Replayable monthly cohort model for users who return after inactivity.

---

## 📌 Objective

Track *reactivated users* grouped by the **month they returned**, enabling:

- Behavioral cohorting
- Reactivation trend analysis
- Campaign performance insights

---

## 🛠️ Model Info

| Attribute     | Value                                      |
|---------------|--------------------------------------------|
| Type          | Fact model (cohort-based)                  |
| Materialized  | Table                                      |
| Location      | `models/fct/cohort_replays/`              |
| Model Name    | `fct_reactivated_users__cohort_monthly`   |

---

## 🧮 Business Logic

A user is considered **reactivated** if:
- They had a previous session.
- Then returned after a gap of **30+ days**.

Each user is assigned to a **`cohort_month`** based on their return date.

---

## 📊 Columns

| Column         | Description                              |
|----------------|------------------------------------------|
| `party_id`     | Unique user ID                           |
| `session_id`   | Reactivated session ID                   |
| `session_starts` | Timestamp of the reactivation session |
| `cohort_month` | Month when user reactivated              |
| `gap_days`     | Days since last session                  |

---

## ⚙️ Parameters

By default, it pulls users who reactivated **within the current month**:

```sql
{% set cohort_month_start = date_trunc('month', current_timestamp()) %}
{% set cohort_month_end = dateadd('month', 1, cohort_month_start) %}
````

You can override these for historical replay if needed.

---

## 🚀 Usage

Run the model:

```bash
dbt run --select fct_reactivated_users__cohort_monthly
```

Or run all cohort models:

```bash
dbt run --select path:models/fct/cohort_replays/
```

---

## 🧩 Extensions

* Join with `dim_users` to add acquisition channel, region, etc.
* Use `date_spine` for full cohort tracking + retention analysis
* Plug into dashboards to compare LTV of reactivated vs new users

---

## 📁 Upstream Dependency

* `reactivated_user_sessions_snapshot`: identifies sessions with gap > 30 days

---

## 🧼 Sample Output

| party\_id | session\_id | session\_starts     | cohort\_month       | gap\_days |
| --------- | ----------- | ------------------- | ------------------- | --------- |
| user17    | sess4       | 2025-07-31 04:30:00 | 2025-07-01 00:00:00 | 31        |
| user12    | sess4       | 2025-07-10 18:30:00 | 2025-07-01 00:00:00 | 66        |

---

## 📎 Related

* 📦 `dim_users`
* 📦 `snapshots/reactivated_user_sessions_snapshot`

```