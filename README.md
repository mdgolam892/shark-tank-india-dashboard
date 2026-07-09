# Shark Tank India — Startup Profitability Analysis
### Power BI · Power Query (M) · DAX

An end-to-end startup investment analysis project built on 780+ pitch records across 5 seasons of Shark Tank India. The ETL pipeline is built entirely inside **Power BI Power Query** (M language) — no external Python or SQL tooling — with 22 custom DAX measures powering a 5-page interactive dashboard.

---

## Business Questions Answered

- What patterns separate funded from non-funded startups — by sector, equity ask, and valuation?
- Which sectors are systematically over- or under-funded relative to their financial merit?
- How has the show's funding behavior evolved across seasons?
- Which sharks are most active, and do they show sector preferences?
- What equity premium do founders actually pay — and is it evenly distributed across sectors?

---

## Project Background

Unlike datasets with clean, pre-processed inputs, this real-world dataset required significant shaping: inconsistent sector naming across seasons, per-shark investment data spread across 14 columns, mixed null patterns for unfunded pitches, and derived metrics (equity premium, valuation delta, revenue multiple) that didn't exist in the raw file. All of this was handled inside Power Query — making the ETL layer reproducible, version-controlled, and entirely self-contained within the Power BI file.

---

## ETL Architecture (Power Query — M Language)

**Why Power Query instead of Python or SQL?**
The other two projects in this portfolio use Python ETL (Retail) and MySQL SQL ETL (PMAY/Ujjwala). Power Query was chosen here deliberately to demonstrate tool diversity — the same analytical goals achieved through a third, different ETL approach.

### 4 Queries Built in Power Query

| Query | Source | Purpose |
|---|---|---|
| `Pitches` | Raw CSV | Main fact table — one row per pitch. 13 transformation steps including column selection, renaming, type casting, derived columns (equity premium, valuation delta, revenue multiple, years in business, profitability flag), sector standardisation |
| `SectorSummary` | Pitches | Aggregated sector-level table — funding rate, avg equity, avg valuation, bias metrics |
| `SharkInvestments` | Pitches | Unpivoted shark presence columns → one row per shark per deal — enables per-shark analysis |
| `SeasonSummary` | Pitches | Season-level trend table — funding rate, avg deal size, investment totals per season |

### Key Power Query Transformations

- **Column selection**: drops 30+ unused columns upfront for performance
- **Type casting**: explicit types on all 35 retained columns — no auto-detect guessing
- **Derived columns**: `equity_premium_pp`, `valuation_delta_pct`, `arr_lakh`, `revenue_multiple`, `is_profitable`, `years_in_business`, `outcome`
- **Sector standardisation**: M-language conditional logic normalises ~25 raw sector strings into consistent categories
- **Unpivoting**: 7 per-shark presence columns → long format table for shark-level analysis

---

## Dashboard Pages (5 pages)

### Page 1 — Overview & KPIs
High-level funding summary with season trend.
- KPI cards: Total Pitches, Funded Deals, Overall Funding Rate %, Total Investment
- Funding rate by season (line chart — shows evolution across S1–S5)
- Sector distribution bar chart

### Page 2 — Investor Bias Analysis
The most analytically distinctive page.
- Sector funding rate vs overall benchmark (diverging bar chart, color-coded by bias tier)
- Investor × Sector matrix (which sharks dominate which sectors)
- Bias label conditional formatting (Strong Overweight → Strong Underweight)

### Page 3 — Equity & Valuation Deep Dive
What founders actually give up vs what they asked.
- Ask vs Deal valuation scatter (one dot per pitch, color by sector)
- Equity premium distribution by sector (box chart or grouped bar)
- Valuation haircut % cards

### Page 4 — Profitability Analysis
Tests whether profitability actually drives funding decisions.
- Revenue vs profitability quadrant (scatter, funded vs unfunded color-coded)
- Profitability rate: funded vs unfunded side-by-side cards
- Significance context: funded startups by profit status

### Page 5 — Strategic Insights
Synthesises findings from all 4 pages into specific, numbered insights with paired recommendations and 4 dynamic headline stat cards.

---

## DAX Measures (22 total)

| Category | Measures |
|---|---|
| Core Funding | Total Pitches, Funded Deals, Not Funded, Funding Rate %, Total Investment, Avg Deal Size |
| Equity & Valuation | Avg Ask/Deal Equity, Equity Premium, Ask/Deal Valuation, Valuation Haircut % |
| Sector Bias | Sector Funding Rate %, Overall Funding Rate %, Investor Bias (pp), Bias Label, Bias Color Score |
| Profitability | Profitable Pitches, Profitability Rate %, Funded Profitability Rate % |
| Season Trends | Season Funding Rate %, Avg Investment YoY Change % |
| Strategic Insights | Top Sector by Funding Rate, Most Active Shark, Highest Equity Premium Sector |

Full DAX with inline comments: [`dax/measures.dax`](dax/measures.dax)

---

## Key Findings

> *Replace these placeholders with your actual computed values once the dashboard is built*

- **Funding rate trend**: Season 1 (XX%) → Season 5 (XX%) — showing [increasing/decreasing] investor confidence
- **Sector bias**: [Sector X] funded at XXpp above benchmark despite comparable revenue multiples to [Sector Y] — systematic investor preference, not merit-based
- **Equity premium**: Funded founders gave up an average of X.Xpp more equity than they asked. [Sector Z] had the highest premium (X.Xpp), suggesting reduced founder leverage in niche sectors
- **Profitability vs funding**: XX% of funded startups were profitable vs XX% overall — [small/large] gap, meaning [sector/pitch quality] mattered more than profit status

---

## Tech Stack

| Layer | Tool |
|---|---|
| Data cleaning & transformation | Power BI Power Query (M language) |
| Business logic & metrics | DAX (22 custom measures) |
| Dashboard & visualisation | Power BI Desktop |
| Dataset | Shark Tank India — Kaggle (thirumani/shark-tank-india) |

---

## Project Structure

```
shark-tank-india/
│
├── data/
│   └── SharkTankIndia.csv         ← Download from Kaggle (link below)
│
├── powerbi/
│   ├── SharkTankIndia.pbix        ← Power BI dashboard
│   ├── dax/
│   │   └── measures.dax           ← All DAX measures with comments
│   └── powerquery/
│       └── etl_queries.pq         ← All 4 Power Query M scripts
│
├── screenshots/                   ← Dashboard page screenshots (5 pages)
│
├── README.md
├── requirements.txt
└── .gitignore
```

---

## How to Run

```bash
# 1. Clone the repo
git clone https://github.com/mdgolam892/shark-tank-india.git
cd shark-tank-india

# 2. Download the dataset
# Go to: https://www.kaggle.com/datasets/thirumani/shark-tank-india
# Download and save as: data/SharkTankIndia.csv

# 3. Open Power BI
# Open powerbi/SharkTankIndia.pbix
# If prompted, update the file path in Power Query:
#   Transform Data → Source step → update file path to your local data/ folder

# 4. Refresh
# Home → Refresh — all 4 queries will run automatically
```

---

## Dataset

**Shark Tank India (Seasons 1–5)** — [Kaggle](https://www.kaggle.com/datasets/thirumani/shark-tank-india)
- 780+ pitch records across 5 seasons
- 75 columns: pitch metadata, financials, per-shark investment breakdown, deal terms
- Values in Indian Lakhs (₹)

---

## Why This Project Is Different From the Other Two

| | Retail Sales | PMAY/Ujjwala | Shark Tank India |
|---|---|---|---|
| ETL tool | Python (pandas) | Python loader + MySQL SQL | Power BI Power Query (M) |
| Data source | Clean Kaggle CSV | Fragmented govt open data | Multi-season Kaggle dataset |
| Key technique | pandas pipeline | SQL UNION ALL unpivoting | M-language column unpivoting + sector normalisation |
| Dashboard focus | Sales performance | Policy gap analysis | Investor bias & equity analysis |

---

## License

MIT License — see [LICENSE](LICENSE) for details.

---

## Contact

**MD GOLAM MOHIUDDIN**
📧 mdgolammohiuddin892@gmail.com
🌐 [LinkedIn](https://www.linkedin.com/in/md-golam-mohiuddin-980b18150/)
🐙 [GitHub](https://github.com/mdgolam892)
