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

