INSERT INTO alpha_vantage_db.stock (ticker) 
    VALUES 
    ('APPL'),
    ('TSLA'),
    ('MSFT'),
    ('GOOG');

INSERT INTO alpha_vantage_db.currency (currency_name) 
    VALUES 
    ('USD');

COPY alpha_vantage_db.overview 
    (   
        asset_type, name, description, cik, exchange, 
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

COPY alpha_vantage_db.shares_outstanding
    (   
            date,
            shares_outstanding_diluted,
            shares_outstanding_basic,
            stock_id
    )
FROM '/tmp/shares_outstanding.csv' DELIMITER ',' CSV HEADER;

COPY alpha_vantage_db.earnings
    (   
            fiscal_date_ending,
            reported_eps,
            stock_id
    )
FROM '/tmp/earnings.csv' DELIMITER ',' CSV HEADER;

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

COPY alpha_vantage_db.splits
    (
        effective_date,
        split_factor,
        stock_id
    )
FROM '/tmp/splits.csv' DELIMITER ',' CSV HEADER;

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
FROM '/tmp/google_income.csv' DELIMITER ',' CSV HEADER;

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
FROM '/tmp/google_balance.csv' 
DELIMITER ',' 
CSV HEADER;

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

COPY alpha_vantage_db.ohlcv
    (
        date,   
        close,
        high,
        low,  
        open,
        volume,
        year,
        stock_id
    )
FROM '/tmp/ohlcv.csv' 
DELIMITER ',' 
CSV HEADER 
NULL '';