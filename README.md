# 📱 Mobile App Marketing Performance & ROI Analytics

## 📌 Project Overview
This project presents an end-to-end performance marketing analysis for a mobile application. The goal is to evaluate user acquisition efficiency, revenue performance, and campaign ROI across multiple ad networks to guide budget allocation decisions.

---

## 🛠️ Tech Stack & Skills
* **SQL (Google BigQuery):** Multi-CTE data consolidation, data cleansing, primary key fixing.
* **Power BI & DAX:** Data modeling, custom DAX measures, date localization (`en-US`).
* **Tableau:** Visual analytics and interactive reporting.
* **Performance Marketing Metrics:** CPI, Revenue, Net Profit, weighted ROI %.

---

## 🔍 Data Cleansing & Key SQL Insights
During initial data audit, `analytics_installation_id` was identified as having 100% missing values (NULLs). The primary key mapping was successfully migrated to `firebase_analytic_app_id` to preserve data integrity.

### Data Architecture (5 CTEs):
1. `installs_data` — Aggregates installs per campaign & date.
2. `costs_data` — Consolidates ad spend across ad networks.
3. `iap_revenue_data` — Calculates in-app purchase revenue.
4. `ad_revenue_data` — Tracks ad network monetization.
5. `final_mart` — Joins metrics seamlessly without missing expense/revenue records.

---

## 📊 Key Business Results & Findings
* **Total Installs:** 328,578
* **Total Cost:** $19,931.07
* **Total Revenue:** $26,480.29
* **Net Profit:** $6,549.22
* **Overall ROI:** **32.86%**

### Strategic Recommendations:
* **Scale High-ROI Channels:** Increase budget for campaigns yielding ROI > 35%.
* **Optimize Underperforming Sources:** Pause or re-target ad sets with negative net profit.

---

## 📁 Repository Structure
* `analytics_query.sql` — Complete BigQuery SQL script (5 CTEs).
* `marketing_dashboard Power BI.pbix` — Interactive Power BI Dashboard file.
* `marketing_dashboard Tableau.pdf` — Tableau Dashboard export.
* `presentation_marketing_analytics.pdf` — Business analysis presentation slides.
