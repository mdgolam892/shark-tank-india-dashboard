# Shark Tank India — Startup Profitability & Investment Analysis

### Power BI · Power Query (M) · DAX

An end-to-end startup investment analytics project built on 780+ Shark Tank India pitch records across five seasons. The project explores funding patterns, investor behaviour, equity negotiations, valuation changes, sector-level trends, and the relationship between profitability and funding.

The complete data preparation and transformation workflow is built inside Power BI using Power Query (M), with 22 custom DAX measures powering a five-page interactive dashboard.
![Overview & KPIs](dashboard/Screenshots/Page1-Overview%20%26%20KPIs.png)
---

## 🎯 Project Objective

The goal of this project was to understand the patterns behind startup funding decisions on Shark Tank India and turn the raw pitch-level data into an interactive analytical solution.

The analysis focuses on questions such as:

- What patterns separate funded from non-funded startups?
- How does funding behaviour differ across sectors?
- Which sectors appear over- or under-represented relative to the overall funding rate?
- How has funding behaviour changed across seasons?
- Which sharks are most active and what sectors do they appear to favour?
- How much additional equity do funded founders give up compared with what they originally asked for?
- Does profitability appear to influence funding outcomes?

---

## 🛠️ What I Built

### 1. Power Query ETL Pipeline

Built the complete data preparation workflow inside Power BI using Power Query and M language.

The pipeline handles:

- Removing unnecessary columns
- Explicit data type conversion
- Cleaning inconsistent source values
- Standardising sector names
- Creating derived business metrics
- Handling missing values and unfunded pitches
- Reshaping shark-level investment data
- Creating analytical summary tables

No external Python or SQL ETL tool is required for this project.

### 2. Derived Business Metrics

Created analytical fields that were not directly available in the raw dataset, including:

- `equity_premium_pp`
- `valuation_delta_pct`
- `arr_lakh`
- `revenue_multiple`
- `is_profitable`
- `years_in_business`
- `outcome`

These metrics provide a consistent basis for comparing funding decisions, founder negotiations, business performance, and sector behaviour.

### 3. Sector Standardisation

The source data contains inconsistent sector naming across seasons.

Power Query transformations were used to standardise approximately 25 raw sector variations into consistent analytical categories, making sector-level comparisons more reliable.

### 4. Shark Investment Transformation

The raw dataset contains shark participation across multiple columns.

These fields were unpivoted into a long-format `SharkInvestments` table, creating one row per shark per deal and making investor-level analysis easier.

### 5. Analytical Summary Tables

Created supporting tables for:

- Sector-level funding analysis
- Shark-level investment analysis
- Season-level trends

These tables are used to support the dashboard's analytical views and comparisons.

---

## 📊 Dashboard

The Power BI dashboard is organised into five pages, moving from an overall funding view into investor behaviour, founder equity negotiations, profitability analysis, and strategic insights.

### 1️⃣ Overview & KPIs

The first page provides a high-level view of Shark Tank India's funding activity across the five seasons.

![Overview & KPIs](dashboard/Screenshots/Page1-Overview%20%26%20KPIs.png)

**Key elements:**
- Total pitches
- Funded deals
- Overall funding rate
- Total investment
- Funding rate by season
- Sector distribution

**Why it matters:** Provides a quick understanding of the overall funding landscape before moving into deeper analysis.

---

### 2️⃣ Investor Bias Analysis

This page focuses on differences in funding behaviour across sectors and investors.

![Investor Bias Analysis](dashboard/Screenshots/Page2-Investor%20Bias%20Analysis.png)

**Key elements:**
- Sector funding rate compared with the overall benchmark
- Investor × Sector analysis
- Shark participation across sectors
- Bias classification from over-weighted to under-weighted sectors

**Why it matters:** Helps identify whether certain sectors receive disproportionately more or less funding and highlights differences in investor preferences.

---

### 3️⃣ Equity & Valuation Deep Dive

This page examines what founders ask for compared with what they ultimately give up in funded deals.

![Equity & Valuation Deep Dive](dashboard/Screenshots/Page3-Equity%20%26%20Valuation%20Deep%20Dive.png)

**Key elements:**
- Ask valuation vs deal valuation
- Equity premium analysis
- Valuation changes between the ask and final deal
- Sector-level comparison of founder equity

**Why it matters:** Provides a deeper view of founder-investor negotiations and the valuation adjustments that happen during funding decisions.

---

### 4️⃣ Profitability Analysis

This page examines the relationship between startup profitability and funding outcomes.

![Profitability Analysis](dashboard/Screenshots/Page4-Profitability%20Analysis.png)

**Key elements:**
- Revenue vs profitability analysis
- Funded vs unfunded startups
- Profitability rate comparison
- Profitability status of funded startups

**Why it matters:** Helps explore whether profitability appears to be an important factor in funding decisions or whether other characteristics may play a larger role.

---

### 5️⃣ Strategic Insights

The final page brings the analysis together into key observations and recommendations.

![Strategic Insights](dashboard/Screenshots/Page5-Strategic%20Insights.png)

**Key elements:**
- Key analytical findings
- Strategic recommendations
- Dynamic headline statistics
- Cross-page insights from funding, sector, investor, equity, and profitability analysis

**Why it matters:** Converts the analysis from a collection of charts into actionable business observations.

---

## 🔄 ETL Architecture

The project uses Power BI Power Query as the complete data transformation layer:

    Raw Shark Tank India CSV
            ↓
    Power Query (M)
            ↓
    Data Cleaning & Standardisation
            ↓
    Derived Business Metrics
            ↓
    Analytical Tables
            ↓
    DAX Measures
            ↓
    Power BI Dashboard

The decision to use Power Query was deliberate: the project demonstrates a different ETL approach from the Python-based Retail Sales project and the MySQL-based Public Policy project.

---

## 🔍 Power Query Transformations

The main Power Query workflow includes four queries:

| Query | Purpose |
|---|---|
| `Pitches` | Main fact table containing one row per pitch and the core transformation logic |
| `SectorSummary` | Aggregated sector-level funding and bias analysis |
| `SharkInvestments` | Unpivots shark participation into a long-format investor table |
| `SeasonSummary` | Season-level funding and investment trends |

### Key transformations include:

- Selecting only relevant columns
- Explicit data type assignment
- Renaming and standardising fields
- Creating calculated columns
- Normalising sector names
- Handling missing values
- Unpivoting shark participation columns
- Creating summary tables for sector and season analysis

The Power Query code is stored in:

`etl/etl_queries.pq`

---

## 📐 DAX Measures

The dashboard is powered by **22 custom DAX measures** covering funding, valuation, sector bias, profitability, season trends, and strategic insights.

| Category | Measures |
|---|---|
| Core Funding | Total Pitches, Funded Deals, Not Funded, Funding Rate %, Total Investment, Avg Deal Size |
| Equity & Valuation | Avg Ask/Deal Equity, Equity Premium, Ask/Deal Valuation, Valuation Haircut % |
| Sector Bias | Sector Funding Rate %, Overall Funding Rate %, Investor Bias (pp), Bias Label, Bias Color Score |
| Profitability | Profitable Pitches, Profitability Rate %, Funded Profitability Rate % |
| Season Trends | Season Funding Rate %, Avg Investment YoY Change % |
| Strategic Insights | Top Sector by Funding Rate, Most Active Shark, Highest Equity Premium Sector |

The DAX measures are stored in:

`etl/measures.dax`

---

## 📈 Analytical Areas

The project covers several analytical dimensions:

### Funding Performance
- Overall funding rate
- Funded vs non-funded pitches
- Total investment
- Average deal size
- Season-level funding trends

### Sector Analysis
- Funding rate by sector
- Sector performance against the overall benchmark
- Investor-sector relationships
- Sector-level equity and valuation patterns

### Investor Analysis
- Shark participation
- Investor activity
- Sector preferences
- Investor bias relative to the overall funding benchmark

### Equity & Valuation
- Founder equity ask
- Final deal equity
- Equity premium
- Ask vs deal valuation
- Valuation haircut

### Profitability
- Revenue and profitability
- Funded vs unfunded profitability
- Profitability rates
- Relationship between profitability and funding

---

## 📂 Dataset

**Shark Tank India — Seasons 1–5** — [Kaggle](https://www.kaggle.com/datasets/thirumani/shark-tank-india)

- 780+ pitch records across five seasons
- 75 columns covering pitch metadata, financials, shark participation, and deal terms
- Financial values are represented in Indian Lakhs (₹)

The original dataset contains inconsistent sector names, missing values for unfunded pitches, and shark-level investment fields spread across multiple columns. These are handled during the Power Query transformation process.

---

## 🚀 How to Run

The dataset is already included in the repository, so no separate dataset download is required.

Clone the repository:

    git clone https://github.com/mdgolam892/shark-tank-india-dashboard.git
    cd shark-tank-india-dashboard

Open the Power BI dashboard:

    dashboard/shark_tank_india_dashboard.pbix

If Power BI asks for the source file location, update the source path in Power Query to the CSV included in:

    data/Shark Tank India.csv

Then refresh the dataset:

    Home → Refresh

The Power Query transformations and DAX measures will be applied automatically, and the five dashboard pages will be available for exploration.

---

## 📁 Project Structure

    shark-tank-india-dashboard/
    │
    ├── dashboard/
    │   ├── Screenshots/
    │   │   ├── Page1-Overview & KPIs.png
    │   │   ├── Page2-Investor Bias Analysis.png
    │   │   ├── Page3-Equity & Valuation Deep Dive.png
    │   │   ├── Page4-Profitability Analysis.png
    │   │   └── Page5-Strategic Insights.png
    │   │
    │   └── shark_tank_india_dashboard.pbix
    │
    ├── data/
    │   └── Shark Tank India.csv
    │
    ├── etl/
    │   ├── etl_queries.pq
    │   └── measures.dax
    │
    └── README.md

---

## 🧰 Tech Stack

| Layer | Technology |
|---|---|
| Data Source | CSV |
| Data Cleaning & Transformation | Power BI Power Query |
| Transformation Language | M |
| Business Logic & Metrics | DAX |
| Dashboard & Visualisation | Power BI Desktop |
| Dataset | Shark Tank India — Kaggle |

---

## 💡 Key Takeaways

This project demonstrates an end-to-end approach to analysing startup investment data:

- Transforming raw multi-season data into an analytics-ready model
- Cleaning and standardising inconsistent categorical data
- Creating derived business metrics from raw financial fields
- Reshaping multi-column investor data using unpivoting
- Building reusable DAX measures for business analysis
- Comparing funding behaviour across sectors and seasons
- Analysing investor preferences and sector bias
- Examining founder equity and valuation changes
- Exploring the relationship between profitability and funding
- Turning analytical findings into strategic recommendations

The project also demonstrates tool diversity by using **Power Query and DAX as the primary data engineering and analytics layer**, rather than relying on external Python or SQL processing.

---

## 📄 License

MIT License — see [LICENSE](LICENSE) for details.

---

## 📫 Contact

**MD GOLAM MOHIUDDIN**

📧 [mdgolammohiuddin892@gmail.com](mailto:mdgolammohiuddin892@gmail.com)  
🔗 [LinkedIn](https://www.linkedin.com/in/md-golam-mohiuddin-980b18150/)  
💻 [GitHub](https://github.com/mdgolam892)
