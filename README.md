# Product Metrics Dashboard (Synthetic Dataset)

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)  ![Python](https://img.shields.io/badge/python-%3E%3D3.8-blue)

## Overview
This repository contains a synthetic product analytics project demonstrating key workflows for a Data/Product Analyst:
- KPI calculations (DAU, WAU, MAU, ARPU)
- Cohort retention and LTV analysis
- RFM segmentation for customer analytics
- SQL examples and reproducible Jupyter notebook
- Visual assets for portfolio (PNG images)

## Quick start
```bash
git clone <your-repo-url>
cd product-metrics-dashboard
python -m venv .venv
source .venv/bin/activate  # on Windows use `.venv\Scripts\activate`
pip install -r requirements.txt
# Optionally execute the notebook to regenerate outputs
./run_notebook.sh
```

## File structure
# Product Metrics Dashboard — Project

**Goal:** Demonstrate product analytics skills: compute product KPIs, perform cohort retention analysis, and build visualizations/dashboards to inform product decisions.

**Dataset:** Synthetic events dataset simulating user registrations, daily sessions, and revenue (Jan 1 — Jun 30, 2025). File: `product_metrics_events.csv`

**Tools:** Python (pandas, matplotlib), SQL (example queries provided), Power BI / Tableau for dashboarding

## Contents
- `product_metrics_events.csv` — simulated raw events data
- `product_metrics_queries.sql` — collection of SQL queries to compute KPIs and cohort retention
- `notebook.ipynb` — Jupyter notebook with analysis pipeline (load → EDA → KPIs → plots)
- `plot_dau.png`, `plot_arpu.png`, `plot_retention.png`, `plot_revenue_acq.png` — visualizations
- `README.md` — this file

## Quick insights (from synthetic data)
- DAU steadily increases over the first months and stabilizes later (see plot_dau.png).
- ARPU is low but gradually increases with spikes on some days (see plot_arpu.png).
- Retention heatmap shows typical decay across weeks; first-week retention drops and stabilizes across cohorts (see plot_retention.png).
- Revenue mainly driven by organic and ads channels in this synthetic sample (see plot_revenue_acq.png).

## How to reproduce / run locally
1. Open `notebook.ipynb` in JupyterLab or VSCode.
2. Ensure requirements installed: `pandas`, `matplotlib`, `nbformat`.
3. Run cells sequentially to regenerate analyses and figures.

## Suggested next steps (for the portfolio)
- Build an interactive Power BI / Tableau dashboard using the CSV (add slicers for date, country, acq_channel).
- Add cohort segmentation by country and acquisition channel.
- Prepare short slide deck (3 slides) summarizing top 3 business recommendations based on findings.


## Added analyses
- `ltv_by_cohort.csv` — average cumulative revenue per cohort-week per user.
- `rfm_users.csv` — RFM metrics and segment for each user (recency_days, frequency, monetary, RFM score, segment).
- `plot_ltv_by_cohort.png` — LTV trends for cohorts.
- `plot_rfm_segments.png` — distribution of RFM segments.

## Business Insights and A/B Test Hypotheses

### Key Insights:
1. **Top Users (Champions)** — represent approximately 26.6% of total users and generate about 32.8% of total revenue.
2. **Loyal Users** show consistent activity with medium revenue; they are potential candidates for retention campaigns.
3. **At Risk Segment** — users with reduced frequency and higher recency; they are ideal for reactivation offers.
4. **Organic and Referral channels** have higher retention and ARPU, while paid channels (Facebook, Google) provide volume but lower LTV.

### A/B Test Hypotheses:
1. Sending personalized push notifications to *At Risk* users will increase 7-day retention by +5–7%.
2. Offering a limited-time discount to *Loyal* users may increase ARPU by +10% in the following month.
