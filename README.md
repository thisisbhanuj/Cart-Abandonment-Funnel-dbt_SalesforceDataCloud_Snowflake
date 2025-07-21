# Retail Abandonment Funnel using Snowflake + dbt + SDFC + External Functions

An enterprise-grade dbt project for modeling cart abandonment behavior using Salesforce Data Cloud Behavioral Events and Snowflake Secure Data Shares.

---

## 🧠 Project Objective

Detect and segment **cart abandonment sessions** across **multiple user identities and sessions**, using real-time behavioral data synced via **Salesforce Data Cloud**.

We leverage:
- Snowflake Secure Views (`WEBSITE_ENGAGEMENT_DATA_SHARE_00DGL000006CKP7UAG`)
- Identity resolution logic via `IndividualId` and `WebCookieId`
- Time-based funnel analysis for engagement segmentation

---

## 🛠️ Environment Setup (Python Virtualenv + dbt)

We use `virtualenv` to isolate the dbt environment.

### 1. Create & activate virtual environment

```bash
# Create virtual environment
python3 -m venv .venv
# Always activate your .venv before running any dbt commands.
# Activate it (Linux/macOS)
source .venv/bin/activate

# Or on Windows
.venv\Scripts\activate

# Install dbt for Snowflake
pip install dbt-snowflake==1.9.0

---

## 🏗️ Project Structure

```bash
dbt_salesforcedatacloud_snowflake/
│
├── models/
│   ├── sources/         # Source declarations for secure views
│   ├── staging/         # Staged cleaned models
│   ├── dashboard/       # Final analytical models (facts / trends)
│   ├── schema/          # Tests, docs, exposures
│
├── snapshots/           # Optional: for tracking cart state changes
├── macros/              # Custom segmentation logic
├── seeds/               # Sample test datasets (optional)
├── analyses/            # Ad hoc SQL analytics
│
├── dbt_project.yml      # Project configuration
├── README.md            # This file
└── .gitignore
````

---

## 🔌 Dependencies

No external dbt packages yet. (Feel free to add [dbt\_utils](https://hub.getdbt.com/dbt-labs/dbt_utils/latest/) later.)

---

## 🔐 Snowflake Setup

```sql
-- One-time setup (must be run as ACCOUNTADMIN)
GRANT IMPORTED PRIVILEGES ON DATABASE WEBSITE_ENGAGEMENT_DATA_SHARE_00DGL000006CKP7UAG TO ROLE TRANSFORM;
```

---

## 🧪 Run Commands

```bash
# Validate connection
dbt debug

# Run models
dbt run

# Run tests
dbt test

# Run specific model
dbt run --select stg_cart_sessions
```

---

## 🧊 Data Models Overview

| Layer        | Description                                                  |
| ------------ | ------------------------------------------------------------ |
| `sources/`   | Salesforce Data Cloud Secure Views (via Data Share)          |
| `staging/`   | Cleaned + renamed columns                                    |
| `dashboard/` | Final business models: cart abandonment funnel, daily trends |
| `schema/`    | Tests (e.g., not nulls), YAML metadata                       |
| `snapshots/` | Optional: change tracking for cart session behaviors         |

---

## 📈 Funnel Use Cases

* Hot / Warm / Cold session segmentation
* Identity resolution using email / cookie / session
* Date-based funnel (daily cart abandonment trends)
* Conversion lag attribution (coming soon)

---

## 🚧 Next Steps

* Add `dbt_utils` and `expectations` for richer testing
* Implement exposures + dashboard metadata
* Enable CI/CD deployment using GitHub Actions or dbt Cloud

---

## 👨‍💻 Maintainers

This project is developed by [Bhanuj](https://github.com/thisisbhanuj), powered by dbt + Snowflake + Salesforce Data Cloud.
