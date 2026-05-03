CREATE SCHEMA alpha_vantage_db
    AUTHORIZATION postgres;

CREATE TABLE alpha_vantage_db.stock
    (
        stock_id BIGINT PRIMARY KEY,
        ticker VARCHAR(10)
    );

CREATE TABLE alpha_vantage_db.currency
    (
        currency_id INT PRIMARY KEY,
        currency_name VARCHAR(10)
    );

INSERT INTO alpha_vantage_db.stock
    VALUES 
    (1, 'APPL'),
    (2, 'TSLA'),
    (3, 'MSFT');

INSERT INTO alpha_vantage_db.currency
    VALUES 
    (1, 'USD');

CREATE TABLE alpha_vantage_db.overview (
    -- Identification & Foreign Keys
    stock_id INT PRIMARY KEY,
    currency_id INT NOT NULL,
    
    -- General Info
    asset_type VARCHAR(50),
    name VARCHAR(255),
    description TEXT,
    cik VARCHAR(20),
    exchange VARCHAR(100),
    country VARCHAR(100),
    sector VARCHAR(100),
    industry VARCHAR(255),
    address TEXT,
    official_site VARCHAR(255),
    
    -- Financial Calendar
    fiscal_year_end VARCHAR(20),
    latest_quarter DATE,
    
    -- Market Data (Using BIGINT for large totals)
    market_capitalization BIGINT,
    ebitda BIGINT,
    revenue_ttm BIGINT,
    gross_profit_ttm BIGINT,
    
    -- Valuation Ratios
    pe_ratio DECIMAL(15, 4),
    peg_ratio DECIMAL(15, 4),
    book_value DECIMAL(15, 4),
    dividend_per_share DECIMAL(15, 4),
    dividend_yield DECIMAL(15, 4),
    eps DECIMAL(15, 4),
    revenue_per_share_ttm DECIMAL(15, 4),
    profit_margin DECIMAL(15, 4),
    operating_margin_ttm DECIMAL(15, 4),
    return_on_assets_ttm DECIMAL(15, 4),
    return_on_equity_ttm DECIMAL(15, 4),
    diluted_eps_ttm DECIMAL(15, 4),
    
    -- Growth Metrics
    quarterly_earnings_growth_yoy DECIMAL(15, 4),
    quarterly_revenue_growth_yoy DECIMAL(15, 4),
    
    -- Analyst Metrics
    analyst_target_price DECIMAL(15, 4),
    analyst_rating_strong_buy INT,
    analyst_rating_buy INT,
    analyst_rating_hold INT,
    analyst_rating_sell INT,
    analyst_rating_strong_sell INT,
    
    -- Price Metrics
    trailing_pe DECIMAL(15, 4),
    forward_pe DECIMAL(15, 4),
    price_to_sales_ratio_ttm DECIMAL(15, 4),
    price_to_book_ratio DECIMAL(15, 4),
    ev_to_revenue DECIMAL(15, 4),
    ev_to_ebitda DECIMAL(15, 4),
    beta DECIMAL(15, 4),
    high_52_week DECIMAL(15, 4),
    low_52_week DECIMAL(15, 4),
    moving_average_50_day DECIMAL(15, 4),
    moving_average_200_day DECIMAL(15, 4),
    
    -- Share Statistics
    shares_outstanding BIGINT,
    shares_float BIGINT,
    percent_insiders DECIMAL(15, 4),
    percent_institutions DECIMAL(15, 4),
    
    -- Dividends
    dividend_date DATE,
    ex_dividend_date DATE,

    -- Table Constraints
    CONSTRAINT fk_stock FOREIGN KEY (stock_id) REFERENCES alpha_vantage_db.stock(stock_id) ON DELETE CASCADE,
    CONSTRAINT fk_currency FOREIGN KEY (currency_id) REFERENCES alpha_vantage_db.currency(currency_id)
);

COPY alpha_vantage_db.overview 
    (   
        stock_id, asset_type, name, description, cik, exchange, 
        currency_id, country, sector, industry, address, official_site, 
        fiscal_year_end, latest_quarter, market_capitalization, ebitda, 
        pe_ratio, peg_ratio, book_value, dividend_per_share, dividend_yield, 
        eps, revenue_per_share_ttm, profit_margin, operating_margin_ttm, 
        return_on_assets_ttm, return_on_equity_ttm, revenue_ttm, gross_profit_ttm, 
        diluted_eps_ttm, quarterly_earnings_growth_yoy, quarterly_revenue_growth_yoy, 
        analyst_target_price, analyst_rating_strong_buy, analyst_rating_buy, 
        analyst_rating_hold, analyst_rating_sell, analyst_rating_strong_sell, 
        trailing_pe, forward_pe, price_to_sales_ratio_ttm, price_to_book_ratio, 
        ev_to_revenue, ev_to_ebitda, beta, high_52_week, low_52_week, 
        moving_average_50_day, moving_average_200_day, shares_outstanding, 
        shares_float, percent_insiders, percent_institutions, dividend_date, 
        ex_dividend_date
    )
FROM '/tmp/overview.csv' DELIMITER ',' CSV HEADER;

-- Creating and populating shares_outstanding table
CREATE TABLE alpha_vantage_db.shares_outstanding (
    stock_id INT REFERENCES alpha_vantage_db.stock(stock_id),
    date DATE,
    shares_outstanding_diluted BIGINT,
    shares_outstanding_basic BIGINT,
    -- This creates the composite primary key
    PRIMARY KEY (stock_id, date)
);

COPY alpha_vantage_db.shares_outstanding
    (   
            date,
            shares_outstanding_diluted,
            shares_outstanding_basic,
            stock_id
    )
FROM '/tmp/shares_outstanding.csv' DELIMITER ',' CSV HEADER;

-- Creating and populating earnings table
CREATE TABLE alpha_vantage_db.earnings (
    stock_id INT REFERENCES alpha_vantage_db.stock(stock_id),
    fiscal_date_ending DATE,
    reported_eps DECIMAL(10,2),
    -- This creates the composite primary key
    PRIMARY KEY (stock_id, fiscal_date_ending )
);

COPY alpha_vantage_db.earnings
    (   
            fiscal_date_ending,
            reported_eps,
            stock_id
    )
FROM '/tmp/earnings.csv' DELIMITER ',' CSV HEADER;

-- Creating and populating dividends table
CREATE TABLE alpha_vantage_db.dividends (
    stock_id INT REFERENCES alpha_vantage_db.stock(stock_id),
    ex_dividend_date DATE,
    declaration_date DATE,
    record_date DATE,
    payment_date DATE,
    amount DECIMAL(5,2),
    -- This creates the composite primary key
    PRIMARY KEY (stock_id, ex_dividend_date)
);

COPY alpha_vantage_db.dividends 
    (
        ex_dividend_date,
        declaration_date,
        record_date,
        payment_date,
        amount,
        stock_id
    )
FROM '/tmp/dividends.csv' DELIMITER ',' CSV HEADER;

-- Creating and populating dividends table
CREATE TABLE alpha_vantage_db.splits (
    stock_id INT REFERENCES alpha_vantage_db.stock(stock_id),
    effective_date DATE,
    split_factor DECIMAL(4,2),
    -- This creates the composite primary key
    PRIMARY KEY (stock_id, effective_date)
);

COPY alpha_vantage_db.splits
    (
        effective_date,
        split_factor,
        stock_id
    )
FROM '/tmp/splits.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE alpha_vantage_db.income_statement (
    stock_id INT,
    fiscal_date_ending DATE,
    reported_currency VARCHAR(3),
    gross_profit DECIMAL(19,4),
    total_revenue DECIMAL(19,4),
    cost_of_revenue DECIMAL(19,4),
    cost_of_goods_and_services_sold DECIMAL(19,4),
    operating_income DECIMAL(19,4),
    selling_general_and_administrative DECIMAL(19,4),
    research_and_development DECIMAL(19,4),
    operating_expenses DECIMAL(19,4),
    investment_income_net DECIMAL(19,4),
    net_interest_income DECIMAL(19,4),
    interest_income DECIMAL(19,4),
    interest_expense DECIMAL(19,4),
    non_interest_income DECIMAL(19,4),
    other_non_operating_income DECIMAL(19,4),
    depreciation DECIMAL(19,4),
    depreciation_and_amortization DECIMAL(19,4),
    income_before_tax DECIMAL(19,4),
    income_tax_expense DECIMAL(19,4),
    interest_and_debt_expense DECIMAL(19,4),
    net_income_from_continuing_operations DECIMAL(19,4),
    comprehensive_income_net_of_tax DECIMAL(19,4),
    ebit DECIMAL(19,4),
    ebitda DECIMAL(19,4),
    net_income DECIMAL(19,4),
    
    -- Constraints
    PRIMARY KEY (stock_id, fiscal_date_ending),
    CONSTRAINT fk_income_stock FOREIGN KEY (stock_id) 
        REFERENCES alpha_vantage_db.stock(stock_id) ON DELETE CASCADE
);


COPY alpha_vantage_db.income_statement
    (
        fiscal_date_ending,
        reported_currency,
        gross_profit,
        total_revenue,
        cost_of_revenue,
        cost_of_goods_and_services_sold,
        operating_income,
        selling_general_and_administrative,
        research_and_development,
        operating_expenses,
        investment_income_net,
        net_interest_income,
        interest_income,
        interest_expense,
        non_interest_income,
        other_non_operating_income,
        depreciation,
        depreciation_and_amortization,
        income_before_tax,
        income_tax_expense,
        interest_and_debt_expense,
        net_income_from_continuing_operations,
        comprehensive_income_net_of_tax,
        ebit,
        ebitda,
        net_income,
        stock_id
    )
FROM '/tmp/income_statement.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE alpha_vantage_db.balance_sheet (
    -- Identification
    stock_id INT,
    fiscal_date_ending DATE,
    reported_currency VARCHAR(3),

    -- Assets
    total_assets DECIMAL(19,4),
    total_current_assets DECIMAL(19,4),
    cash_and_cash_equivalents_at_carrying_value DECIMAL(19,4),
    cash_and_short_term_investments DECIMAL(19,4),
    inventory DECIMAL(19,4),
    current_net_receivables DECIMAL(19,4),
    total_non_current_assets DECIMAL(19,4),
    property_plant_equipment DECIMAL(19,4),
    accumulated_depreciation_amortization_ppe DECIMAL(19,4),
    intangible_assets DECIMAL(19,4),
    intangible_assets_excluding_goodwill DECIMAL(19,4),
    goodwill DECIMAL(19,4),
    investments DECIMAL(19,4),
    long_term_investments DECIMAL(19,4),
    short_term_investments DECIMAL(19,4),
    other_current_assets DECIMAL(19,4),
    other_non_current_assets DECIMAL(19,4),

    -- Liabilities
    total_liabilities DECIMAL(19,4),
    total_current_liabilities DECIMAL(19,4),
    current_accounts_payable DECIMAL(19,4),
    deferred_revenue DECIMAL(19,4),
    current_debt DECIMAL(19,4),
    short_term_debt DECIMAL(19,4),
    total_non_current_liabilities DECIMAL(19,4),
    capital_lease_obligations DECIMAL(19,4),
    long_term_debt DECIMAL(19,4),
    current_long_term_debt DECIMAL(19,4),
    long_term_debt_noncurrent DECIMAL(19,4),
    short_long_term_debt_total DECIMAL(19,4),
    other_current_liabilities DECIMAL(19,4),
    other_non_current_liabilities DECIMAL(19,4),

    -- Equity & Shares
    total_shareholder_equity DECIMAL(19,4),
    treasury_stock DECIMAL(19,4),
    retained_earnings DECIMAL(19,4),
    common_stock DECIMAL(19,4),
    common_stock_shares_outstanding BIGINT,

    -- Constraints
    PRIMARY KEY (stock_id, fiscal_date_ending),
    CONSTRAINT fk_balance_stock FOREIGN KEY (stock_id) 
        REFERENCES alpha_vantage_db.stock(stock_id) ON DELETE CASCADE
);


COPY alpha_vantage_db.balance_sheet
    (
        fiscal_date_ending,
        reported_currency,
        total_assets,
        total_current_assets,
        cash_and_cash_equivalents_at_carrying_value,
        cash_and_short_term_investments,
        inventory,
        current_net_receivables,
        total_non_current_assets,
        property_plant_equipment,
        accumulated_depreciation_amortization_ppe,
        intangible_assets,
        intangible_assets_excluding_goodwill,
        goodwill,
        investments,
        long_term_investments,
        short_term_investments,
        other_current_assets,
        other_non_current_assets,
        total_liabilities,
        total_current_liabilities,
        current_accounts_payable,
        deferred_revenue,
        current_debt,
        short_term_debt,
        total_non_current_liabilities,
        capital_lease_obligations,
        long_term_debt,
        current_long_term_debt,
        long_term_debt_noncurrent,
        short_long_term_debt_total,
        other_current_liabilities,
        other_non_current_liabilities,
        total_shareholder_equity,
        treasury_stock,
        retained_earnings,
        common_stock,
        common_stock_shares_outstanding,
        stock_id
    )
FROM '/tmp/balance_sheet.csv' 
DELIMITER ',' 
CSV HEADER;

CREATE TABLE alpha_vantage_db.cash_flow (
    stock_id INT,
    fiscal_date_ending DATE,
    reported_currency VARCHAR(3),
    operating_cashflow DECIMAL(19,4),
    payments_for_operating_activities DECIMAL(19,4),
    proceeds_from_operating_activities DECIMAL(19,4),
    change_in_operating_liabilities DECIMAL(19,4),
    change_in_operating_assets DECIMAL(19,4),
    depreciation_depletion_and_amortization DECIMAL(19,4),
    capital_expenditures DECIMAL(19,4),
    change_in_receivables DECIMAL(19,4),
    change_in_inventory DECIMAL(19,4),
    profit_loss DECIMAL(19,4),
    cashflow_from_investment DECIMAL(19,4),
    cashflow_from_financing DECIMAL(19,4),
    proceeds_from_repayments_of_short_term_debt DECIMAL(19,4),
    payments_for_repurchase_of_common_stock DECIMAL(19,4),
    payments_for_repurchase_of_equity DECIMAL(19,4),
    payments_for_repurchase_of_preferred_stock DECIMAL(19,4),
    dividend_payout DECIMAL(19,4),
    dividend_payout_common_stock DECIMAL(19,4),
    dividend_payout_preferred_stock DECIMAL(19,4),
    proceeds_from_issuance_of_common_stock DECIMAL(19,4),
    proceeds_from_issuance_of_long_term_debt_and_capital_securities DECIMAL(19,4),
    proceeds_from_issuance_of_preferred_stock DECIMAL(19,4),
    proceeds_from_repurchase_of_equity DECIMAL(19,4),
    proceeds_from_sale_of_treasury_stock DECIMAL(19,4),
    stock_based_compensation DECIMAL(19,4),
    change_in_cash_and_cash_equivalents DECIMAL(19,4),
    change_in_exchange_rate DECIMAL(19,4),
    net_income DECIMAL(19,4),

    -- Constraints
    PRIMARY KEY (stock_id, fiscal_date_ending),
    CONSTRAINT fk_cashflow_stock FOREIGN KEY (stock_id) 
        REFERENCES alpha_vantage_db.stock(stock_id) ON DELETE CASCADE
);


COPY alpha_vantage_db.cash_flow
    (
        fiscal_date_ending,
        reported_currency,
        operating_cashflow,
        payments_for_operating_activities,
        proceeds_from_operating_activities,
        change_in_operating_liabilities,
        change_in_operating_assets,
        depreciation_depletion_and_amortization,
        capital_expenditures,
        change_in_receivables,
        change_in_inventory,
        profit_loss,
        cashflow_from_investment,
        cashflow_from_financing,
        proceeds_from_repayments_of_short_term_debt,
        payments_for_repurchase_of_common_stock,
        payments_for_repurchase_of_equity,
        payments_for_repurchase_of_preferred_stock,
        dividend_payout,
        dividend_payout_common_stock,
        dividend_payout_preferred_stock,
        proceeds_from_issuance_of_common_stock,
        proceeds_from_issuance_of_long_term_debt_and_capital_securities,
        proceeds_from_issuance_of_preferred_stock,
        proceeds_from_repurchase_of_equity,
        proceeds_from_sale_of_treasury_stock,
        stock_based_compensation,
        change_in_cash_and_cash_equivalents,
        change_in_exchange_rate,
        net_income,
        stock_id
    )
FROM '/tmp/cash_flow.csv' 
DELIMITER ',' 
CSV HEADER 
NULL '';


CREATE TABLE alpha_vantage_db.earnings_estimates (
    stock_id INT,
    date DATE,
    horizon VARCHAR(50),
    eps_estimate_average DECIMAL(19,4),
    eps_estimate_high DECIMAL(19,4),
    eps_estimate_low DECIMAL(19,4),
    eps_estimate_analyst_count INT,
    eps_estimate_average_7_days_ago DECIMAL(19,4),
    eps_estimate_average_30_days_ago DECIMAL(19,4),
    eps_estimate_average_60_days_ago DECIMAL(19,4),
    eps_estimate_average_90_days_ago DECIMAL(19,4),
    eps_estimate_revision_up_trailing_7_days INT,
    eps_estimate_revision_down_trailing_7_days INT,
    eps_estimate_revision_up_trailing_30_days INT,
    eps_estimate_revision_down_trailing_30_days INT,
    revenue_estimate_average DECIMAL(25,2),
    revenue_estimate_high DECIMAL(25,2),
    revenue_estimate_low DECIMAL(25,2),
    revenue_estimate_analyst_count INT,

    -- Constraints
    PRIMARY KEY (stock_id, date, horizon),
    CONSTRAINT fk_estimates_stock FOREIGN KEY (stock_id) 
        REFERENCES alpha_vantage_db.stock(stock_id) ON DELETE CASCADE
);

ALTER TABLE alpha_vantage_db.earnings_estimates 
    ALTER COLUMN eps_estimate_analyst_count TYPE DECIMAL(19,2),
    ALTER COLUMN eps_estimate_revision_up_trailing_7_days TYPE DECIMAL(19,2),
    ALTER COLUMN eps_estimate_revision_down_trailing_7_days TYPE DECIMAL(19,2),
    ALTER COLUMN eps_estimate_revision_up_trailing_30_days TYPE DECIMAL(19,2),
    ALTER COLUMN eps_estimate_revision_down_trailing_30_days TYPE DECIMAL(19,2),
    ALTER COLUMN revenue_estimate_analyst_count TYPE DECIMAL(19,2);


COPY alpha_vantage_db.earnings_estimates
    (
        date,
        horizon,
        eps_estimate_average,
        eps_estimate_high,
        eps_estimate_low,
        eps_estimate_analyst_count,
        eps_estimate_average_7_days_ago,
        eps_estimate_average_30_days_ago,
        eps_estimate_average_60_days_ago,
        eps_estimate_average_90_days_ago,
        eps_estimate_revision_up_trailing_7_days,
        eps_estimate_revision_down_trailing_7_days,
        eps_estimate_revision_up_trailing_30_days,
        eps_estimate_revision_down_trailing_30_days,
        revenue_estimate_average,
        revenue_estimate_high,
        revenue_estimate_low,
        revenue_estimate_analyst_count,
        stock_id
    )
FROM '/tmp/earnings_estimates.csv' 
DELIMITER ',' 
CSV HEADER 
NULL '';

-- Alter the tables to add foreign key constraints to income and cash flow statement
ALTER TABLE alpha_vantage_db.income_statement
ADD CONSTRAINT fk_income_to_balance 
FOREIGN KEY (stock_id, fiscal_date_ending) 
REFERENCES alpha_vantage_db.balance_sheet (stock_id, fiscal_date_ending)
ON DELETE CASCADE; -- Optional: cleans up income records if balance sheet is deleted

ALTER TABLE alpha_vantage_db.cash_flow
ADD CONSTRAINT fk_cashflow_to_balance 
FOREIGN KEY (stock_id, fiscal_date_ending) 
REFERENCES alpha_vantage_db.balance_sheet (stock_id, fiscal_date_ending)
ON DELETE CASCADE;


-- To check if the join works after foreign key constraints
SELECT i.stock_id, i.fiscal_date_ending
FROM alpha_vantage_db.income_statement i
LEFT JOIN alpha_vantage_db.balance_sheet b 
  ON i.stock_id = b.stock_id 
  AND i.fiscal_date_ending = b.fiscal_date_ending
WHERE b.stock_id IS NULL;
