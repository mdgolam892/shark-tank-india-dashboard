// ================================================================
// Shark Tank India — Power Query ETL (M Language)
// ================================================================
// Purpose  : Full ETL pipeline inside Power BI Power Query
// Source   : SharkTankIndia.csv (Kaggle: thirumani/shark-tank-india)
// Output   : 4 clean tables ready for DAX measures
//
// HOW TO USE:
// 1. Get Data → Text/CSV → load SharkTankIndia.csv
// 2. Open Transform Data (Power Query Editor)
// 3. For each query below: Home → Advanced Editor → paste the code
// ================================================================


// ================================================================
// QUERY 1: Pitches (main fact table — one row per pitch)
// ================================================================
let
    // ── Step 1: Load raw CSV ─────────────────────────────────────
    Source = Csv.Document(
        File.Contents("C:\path\to\SharkTankIndia.csv"),
        [Delimiter=",", Columns=75, Encoding=65001, QuoteStyle=QuoteStyle.None]
    ),
    PromotedHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),

    // ── Step 2: Select only needed columns ───────────────────────
    // Drops per-shark individual columns (handled in Query 3)
    SelectedColumns = Table.SelectColumns(PromotedHeaders, {
        "Season Number", "Startup Name", "Episode Number", "Pitch Number",
        "Original Air Date", "Industry", "Business Description",
        "Started in", "Number of Presenters", "Male Presenters",
        "Female Presenters", "Couple Presenters", "Pitchers Average Age",
        "Pitchers City", "Pitchers State",
        "Yearly Revenue", "Monthly Sales", "Gross Margin", "Net Margin",
        "Has Patents", "Bootstrapped",
        "Original Ask Amount", "Original Offered Equity", "Valuation Requested",
        "Received Offer", "Accepted Offer",
        "Total Deal Amount", "Total Deal Equity", "Total Deal Debt",
        "Debt Interest", "Deal Valuation", "Number of Sharks in Deal",
        "Deal Has Conditions", "Royalty Percentage",
        "Namita Present", "Vineeta Present", "Anupam Present",
        "Aman Present", "Peyush Present", "Ritesh Present",
        "Amit Present", "Guest Present", "All Guest Names"
    }),

    // ── Step 3: Rename columns to clean names ────────────────────
    RenamedColumns = Table.RenameColumns(SelectedColumns, {
        {"Season Number",           "season"},
        {"Startup Name",            "startup_name"},
        {"Episode Number",          "episode"},
        {"Pitch Number",            "pitch_number"},
        {"Original Air Date",       "air_date"},
        {"Industry",                "sector"},
        {"Business Description",    "business_description"},
        {"Started in",              "founded_year"},
        {"Number of Presenters",    "presenter_count"},
        {"Male Presenters",         "male_presenters"},
        {"Female Presenters",       "female_presenters"},
        {"Couple Presenters",       "couple_presenters"},
        {"Pitchers Average Age",    "pitcher_age_group"},
        {"Pitchers City",           "city"},
        {"Pitchers State",          "state"},
        {"Yearly Revenue",          "yearly_revenue_lakh"},
        {"Monthly Sales",           "monthly_sales_lakh"},
        {"Gross Margin",            "gross_margin_pct"},
        {"Net Margin",              "net_margin_pct"},
        {"Has Patents",             "has_patents"},
        {"Bootstrapped",            "is_bootstrapped"},
        {"Original Ask Amount",     "ask_amount_lakh"},
        {"Original Offered Equity", "ask_equity_pct"},
        {"Valuation Requested",     "ask_valuation_lakh"},
        {"Received Offer",          "received_offer"},
        {"Accepted Offer",          "deal_closed"},
        {"Total Deal Amount",       "deal_amount_lakh"},
        {"Total Deal Equity",       "deal_equity_pct"},
        {"Total Deal Debt",         "deal_debt_lakh"},
        {"Debt Interest",           "debt_interest_pct"},
        {"Deal Valuation",          "deal_valuation_lakh"},
        {"Number of Sharks in Deal","sharks_in_deal"},
        {"Deal Has Conditions",     "deal_has_conditions"},
        {"Royalty Percentage",      "royalty_pct"},
        {"Namita Present",          "namita_present"},
        {"Vineeta Present",         "vineeta_present"},
        {"Anupam Present",          "anupam_present"},
        {"Aman Present",            "aman_present"},
        {"Peyush Present",          "peyush_present"},
        {"Ritesh Present",          "ritesh_present"},
        {"Amit Present",            "amit_present"},
        {"Guest Present",           "guest_present"},
        {"All Guest Names",         "guest_names"}
    }),

    // ── Step 4: Set correct data types ───────────────────────────
    TypedColumns = Table.TransformColumnTypes(RenamedColumns, {
        {"season",              Int64.Type},
        {"episode",             Int64.Type},
        {"pitch_number",        Int64.Type},
        {"air_date",            type date},
        {"founded_year",        Int64.Type},
        {"presenter_count",     Int64.Type},
        {"male_presenters",     Int64.Type},
        {"female_presenters",   Int64.Type},
        {"couple_presenters",   Int64.Type},
        {"yearly_revenue_lakh", type number},
        {"monthly_sales_lakh",  type number},
        {"gross_margin_pct",    type number},
        {"net_margin_pct",      type number},
        {"ask_amount_lakh",     type number},
        {"ask_equity_pct",      type number},
        {"ask_valuation_lakh",  type number},
        {"received_offer",      Int64.Type},
        {"deal_closed",         Int64.Type},
        {"deal_amount_lakh",    type number},
        {"deal_equity_pct",     type number},
        {"deal_debt_lakh",      type number},
        {"debt_interest_pct",   type number},
        {"deal_valuation_lakh", type number},
        {"sharks_in_deal",      Int64.Type},
        {"deal_has_conditions", Int64.Type},
        {"royalty_pct",         type number},
        {"namita_present",      Int64.Type},
        {"vineeta_present",     Int64.Type},
        {"anupam_present",      Int64.Type},
        {"aman_present",        Int64.Type},
        {"peyush_present",      Int64.Type},
        {"ritesh_present",      Int64.Type},
        {"amit_present",        Int64.Type},
        {"guest_present",       Int64.Type},
        {"has_patents",         Int64.Type},
        {"is_bootstrapped",     Int64.Type}
    }),

    // ── Step 5: Add outcome label column ─────────────────────────
    AddOutcome = Table.AddColumn(TypedColumns, "outcome",
        each if [deal_closed] = 1 then "Funded" else "Not Funded",
        type text),

    // ── Step 6: Add equity premium (extra equity given vs asked) ─
    // Positive value = founder gave MORE equity than asked
    AddEquityPremium = Table.AddColumn(AddOutcome, "equity_premium_pp",
        each if [deal_equity_pct] = null or [ask_equity_pct] = null
             then null
             else [deal_equity_pct] - [ask_equity_pct],
        type number),

    // ── Step 7: Add valuation delta (deal vs ask) ────────────────
    // Negative = deal valuation was LOWER than founder asked (haircut)
    AddValuationDelta = Table.AddColumn(AddEquityPremium, "valuation_delta_pct",
        each if [deal_valuation_lakh] = null or [ask_valuation_lakh] = null
                or [ask_valuation_lakh] = 0
             then null
             else ([deal_valuation_lakh] - [ask_valuation_lakh])
                  / [ask_valuation_lakh] * 100,
        type number),

    // ── Step 8: Add ARR (Annual Recurring Revenue) from monthly ──
    AddARR = Table.AddColumn(AddValuationDelta, "arr_lakh",
        each if [monthly_sales_lakh] = null
             then [yearly_revenue_lakh]
             else [monthly_sales_lakh] * 12,
        type number),

    // ── Step 9: Add revenue multiple (deal valuation / ARR) ──────
    AddRevMultiple = Table.AddColumn(AddARR, "revenue_multiple",
        each if [arr_lakh] = null or [arr_lakh] = 0
             then null
             else [deal_valuation_lakh] / [arr_lakh],
        type number),

    // ── Step 10: Add profitability flag ──────────────────────────
    AddProfitFlag = Table.AddColumn(AddRevMultiple, "is_profitable",
        each if [net_margin_pct] = null
             then null
             else if [net_margin_pct] > 0 then 1 else 0,
        Int64.Type),

    // ── Step 11: Standardise sector names ────────────────────────
    // Some sectors have slight naming variations across seasons
    StandardiseSector = Table.ReplaceValue(
        AddProfitFlag,
        each [sector],
        each
            if Text.Contains([sector], "Food") then "Food and Beverage"
            else if Text.Contains([sector], "Beauty") or Text.Contains([sector], "Fashion") then "Beauty and Fashion"
            else if Text.Contains([sector], "Tech") and not Text.Contains([sector], "Ed") then "Technology"
            else if Text.Contains([sector], "Health") then "Healthcare"
            else if Text.Contains([sector], "Edu") then "Education"
            else if Text.Contains([sector], "Vehicle") or Text.Contains([sector], "EV") then "EV and Mobility"
            else [sector],
        Replacer.ReplaceValue,
        {"sector"}
    ),

    // ── Step 12: Remove rows with no startup name (blank/footer rows)
    RemovedBlanks = Table.SelectRows(StandardiseSector,
        each [startup_name] <> null and [startup_name] <> ""),

    // ── Step 13: Add years in business at time of pitch ──────────
    // air_date year minus founded year
    AddYearsInBusiness = Table.AddColumn(RemovedBlanks, "years_in_business",
        each if [founded_year] = null or [air_date] = null
             then null
             else Date.Year([air_date]) - [founded_year],
        Int64.Type)

in
    AddYearsInBusiness


// ================================================================
// QUERY 2: Sector Summary (aggregated by sector — for bias analysis)
// ================================================================
let
    Source        = Pitches,   // references Query 1 above
    Grouped = Table.Group(Source, {"sector"}, {
        {"total_pitches",   each Table.RowCount(_),              Int64.Type},
        {"funded_count",    each List.Sum(List.Transform([deal_closed], each _ ?? 0)), Int64.Type},
        {"avg_ask_equity",  each List.Average(List.RemoveNulls([ask_equity_pct])),   type number},
        {"avg_deal_equity", each List.Average(List.RemoveNulls([deal_equity_pct])),  type number},
        {"avg_ask_valuation",  each List.Average(List.RemoveNulls([ask_valuation_lakh])), type number},
        {"avg_deal_valuation", each List.Average(List.RemoveNulls([deal_valuation_lakh])), type number},
        {"avg_equity_premium", each List.Average(List.RemoveNulls([equity_premium_pp])), type number},
        {"avg_revenue_multiple", each List.Average(List.RemoveNulls([revenue_multiple])), type number},
        {"profitable_count", each List.Sum(List.Transform([is_profitable], each _ ?? 0)), Int64.Type}
    }),
    AddFundingRate = Table.AddColumn(Grouped, "funding_rate_pct",
        each if [total_pitches] = 0 then null
             else [funded_count] / [total_pitches] * 100,
        type number),
    AddProfitableRate = Table.AddColumn(AddFundingRate, "profitable_rate_pct",
        each if [total_pitches] = 0 then null
             else [profitable_count] / [total_pitches] * 100,
        type number)
in
    AddProfitableRate


// ================================================================
// QUERY 3: Shark Investments (unpivoted — one row per shark per deal)
// ================================================================
// This unpivots the 7 per-shark amount columns into a long table
// so we can analyse each shark's investment patterns independently
let
    Source = Pitches,
    // Keep only funded pitches — unfunded have no shark data
    FundedOnly = Table.SelectRows(Source, each [deal_closed] = 1),
    // Select just the identifier + per-shark amount columns
    SharkCols = Table.SelectColumns(FundedOnly, {
        "season", "startup_name", "sector", "deal_amount_lakh",
        "deal_equity_pct", "deal_valuation_lakh",
        "namita_present", "vineeta_present", "anupam_present",
        "aman_present", "peyush_present", "ritesh_present", "amit_present"
    }),
    // Unpivot the 7 presence columns into shark_name + invested (1/0)
    Unpivoted = Table.UnpivotOtherColumns(SharkCols, {
        "season", "startup_name", "sector",
        "deal_amount_lakh", "deal_equity_pct", "deal_valuation_lakh"
    }, "shark_column", "is_present"),
    // Clean shark name from column name (e.g. "namita_present" → "Namita")
    CleanSharkName = Table.AddColumn(Unpivoted, "shark_name",
        each Text.Proper(Text.BeforeDelimiter([shark_column], "_present")),
        type text),
    // Keep only rows where the shark was actually present
    PresentOnly = Table.SelectRows(CleanSharkName, each [is_present] = 1),
    // Remove the raw column name column
    FinalCols = Table.RemoveColumns(PresentOnly, {"shark_column", "is_present"})
in
    FinalCols


// ================================================================
// QUERY 4: Season Summary (aggregated by season — for trend analysis)
// ================================================================
let
    Source = Pitches,
    Grouped = Table.Group(Source, {"season"}, {
        {"total_pitches",     each Table.RowCount(_),             Int64.Type},
        {"funded_count",      each List.Sum(List.Transform([deal_closed], each _ ?? 0)), Int64.Type},
        {"avg_ask_amount",    each List.Average(List.RemoveNulls([ask_amount_lakh])),  type number},
        {"avg_deal_amount",   each List.Average(List.RemoveNulls([deal_amount_lakh])), type number},
        {"avg_ask_equity",    each List.Average(List.RemoveNulls([ask_equity_pct])),   type number},
        {"avg_deal_equity",   each List.Average(List.RemoveNulls([deal_equity_pct])),  type number},
        {"avg_equity_premium",each List.Average(List.RemoveNulls([equity_premium_pp])),type number},
        {"total_investment",  each List.Sum(List.RemoveNulls([deal_amount_lakh])),     type number}
    }),
    AddFundingRate = Table.AddColumn(Grouped, "funding_rate_pct",
        each if [total_pitches] = 0 then null
             else [funded_count] / [total_pitches] * 100,
        type number)
in
    AddFundingRate
