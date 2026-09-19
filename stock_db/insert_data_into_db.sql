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

UPDATE alpha_vantage_db.income_statement as income
SET 
fiscal_date_ending = inc_data.new_date
FROM (
    VALUES 
        (3, CAST('2006-12-31' AS DATE), CAST('2006-06-30' AS DATE)),
        (3, CAST('2007-12-31' AS DATE), CAST('2007-06-30' AS DATE)),
        (3, CAST('2008-12-31' AS DATE), CAST('2008-06-30' AS DATE)),
        (3, CAST('2009-12-31' AS DATE), CAST('2009-06-30' AS DATE)),
        (3, CAST('2010-12-31' AS DATE), CAST('2010-06-30' AS DATE)),
        (3, CAST('2011-12-31' AS DATE), CAST('2011-06-30' AS DATE)),
        (3, CAST('2012-12-31' AS DATE), CAST('2012-06-30' AS DATE)),
        (3, CAST('2013-12-31' AS DATE), CAST('2013-06-30' AS DATE)),
        (3, CAST('2014-12-31' AS DATE), CAST('2014-06-30' AS DATE)),
        (3, CAST('2015-12-31' AS DATE), CAST('2015-06-30' AS DATE)),
        (3, CAST('2016-12-31' AS DATE), CAST('2016-06-30' AS DATE)),
        (3, CAST('2017-12-31' AS DATE), CAST('2017-06-30' AS DATE)),
        (3, CAST('2018-12-31' AS DATE), CAST('2018-06-30' AS DATE)),
        (3, CAST('2019-12-31' AS DATE), CAST('2019-06-30' AS DATE)),
        (3, CAST('2020-12-31' AS DATE), CAST('2020-06-30' AS DATE)),
        (3, CAST('2021-12-31' AS DATE), CAST('2021-06-30' AS DATE)),
        (3, CAST('2022-12-31' AS DATE), CAST('2022-06-30' AS DATE)),
        (3, CAST('2023-12-31' AS DATE), CAST('2023-06-30' AS DATE)),
        (3, CAST('2024-12-31' AS DATE), CAST('2024-06-30' AS DATE)),
        (3, CAST('2025-12-31' AS DATE), CAST('2025-06-30' AS DATE))
) AS inc_data(stock_id, old_date, new_date)
WHERE income.stock_id = inc_data.stock_id 
  AND income.fiscal_date_ending = inc_data.old_date 
  AND income.report_type = 'ANNUAL';

UPDATE alpha_vantage_db.income_statement as income
SET 
fiscal_date_ending = new_data.fiscal_date_ending,
reported_currency = new_data.reported_currency,
gross_profit = new_data.gross_profit,
total_revenue = new_data.total_revenue, 
cost_of_revenue = new_data.cost_of_revenue,
cost_of_goods_and_services_sold = new_data.cost_of_goods_and_services_sold,
operating_income = new_data.operating_income,
selling_general_and_administrative = new_data.selling_general_and_administrative,
research_and_development = new_data.research_and_development,
operating_expenses = new_data.operating_expenses,
investment_income_net = new_data.investment_income_net,
net_interest_income = new_data.net_interest_income,
interest_income = new_data.interest_income,
interest_expense = new_data.interest_expense,
non_interest_income = new_data.non_interest_income,
other_non_operating_income = new_data.other_non_operating_income,
depreciation = new_data.depreciation,
depreciation_and_amortization = new_data.depreciation_and_amortization,
income_before_tax = new_data.income_before_tax,
income_tax_expense = new_data.income_tax_expense,
interest_and_debt_expense = new_data.interest_and_debt_expense,
net_income_from_continuing_operations = new_data.net_income_from_continuing_operations,
comprehensive_income_net_of_tax = new_data.comprehensive_income_net_of_tax,
ebit = new_data.ebit,
ebitda = new_data.ebitda,
net_income = new_data.net_income,
report_type = new_data.report_type
FROM (
    VALUES 
(3, CAST('2025-06-30' AS DATE), 'USD', 193893000000, 281724000000, 87831000000, 87831000000, 128528000000, 7223000000, 32488000000, 65365000000, CAST(NULL AS NUMERIC), 262000000, 767000000, 2385000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 34153000000, 123627000000, 21795000000, CAST(NULL AS NUMERIC), 101832000000, CAST(NULL AS NUMERIC), 126012000000, 160165000000, 101832000000, 'ANNUAL'),
(3, CAST('2024-06-30' AS DATE), 'USD', 171008000000, 245122000000, 74114000000, 74114000000, 109433000000, 7609000000, 29510000000, 61575000000, CAST(NULL AS NUMERIC), 222000000, 3157000000, 2935000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 22287000000, 107787000000, 19651000000, CAST(NULL AS NUMERIC), 88136000000, CAST(NULL AS NUMERIC), 110722000000, 133009000000, 88136000000, 'ANNUAL'),
(3, CAST('2023-06-30' AS DATE), 'USD', 146052000000, 211915000000, 65863000000, 65863000000, 88523000000, 7575000000, 27195000000, 57529000000, CAST(NULL AS NUMERIC), 1026000000, 1041000000, 1968000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 13861000000, 89311000000, 16950000000, CAST(NULL AS NUMERIC), 72361000000, CAST(NULL AS NUMERIC), 91279000000, 105140000000, 72361000000, 'ANNUAL'),
(3, CAST('2022-06-30' AS DATE), 'USD', 135620000000, 198270000000, 62650000000, 62650000000, 83383000000, 5900000000, 24512000000, 52237000000, CAST(NULL AS NUMERIC), 31000000, 2094000000, 2063000000, CAST(NULL AS NUMERIC), 333000000, CAST(NULL AS NUMERIC), 14460000000, 83716000000, 10978000000, CAST(NULL AS NUMERIC), 72738000000, CAST(NULL AS NUMERIC), 85779000000, 100239000000, 72738000000, 'ANNUAL'),
(3, CAST('2021-06-30' AS DATE), 'USD', 115856000000, 168088000000, 52232000000, 52232000000, 69916000000, 5107000000, 20716000000, 45940000000, CAST(NULL AS NUMERIC), -215000000, 2131000000, 2346000000, CAST(NULL AS NUMERIC), 1186000000, CAST(NULL AS NUMERIC), 11686000000, 71102000000, 9831000000, CAST(NULL AS NUMERIC), 61271000000, CAST(NULL AS NUMERIC), 73448000000, 85134000000, 61271000000, 'ANNUAL'),
(3, CAST('2020-06-30' AS DATE), 'USD', 96937000000, 143015000000, 46078000000, 46078000000, 52959000000, 5111000000, 19269000000, 43978000000, CAST(NULL AS NUMERIC), -2591000000, 2680000000, 2591000000, CAST(NULL AS NUMERIC), 77000000, CAST(NULL AS NUMERIC), 12796000000, 53036000000, 8755000000, CAST(NULL AS NUMERIC), 44281000000, CAST(NULL AS NUMERIC), 55627000000, 68423000000, 44281000000, 'ANNUAL'),
(3, CAST('2019-06-30' AS DATE), 'USD', 82933000000, 125843000000, 42910000000, 42910000000, 42959000000, 4885000000, 16876000000, 39974000000, CAST(NULL AS NUMERIC), -2686000000, 812000000, 2686000000, CAST(NULL AS NUMERIC), 729000000, CAST(NULL AS NUMERIC), 11682000000, 43688000000, 4448000000, CAST(NULL AS NUMERIC), 39240000000, CAST(NULL AS NUMERIC), 46374000000, 58056000000, 39240000000, 'ANNUAL'),
(3, CAST('2018-06-30' AS DATE), 'USD', 72007000000, 110360000000, 38353000000, 38353000000, 35058000000, 4754000000, 14726000000, 36949000000, CAST(NULL AS NUMERIC), -2733000000, 1522000000, 2733000000, CAST(NULL AS NUMERIC), 1416000000, CAST(NULL AS NUMERIC), 10261000000, 36474000000, 19903000000, CAST(NULL AS NUMERIC), 16571000000, CAST(NULL AS NUMERIC), 39207000000, 49468000000, 16571000000, 'ANNUAL'),
(3, CAST('2017-06-30' AS DATE), 'USD', 62310000000, 96571000000, 34261000000, 34261000000, 29025000000, 4481000000, 13037000000, 32979000000, CAST(NULL AS NUMERIC), -2222000000, 1182000000, 2222000000, CAST(NULL AS NUMERIC), 823000000, CAST(NULL AS NUMERIC), 8778000000, 29901000000, 4412000000, CAST(NULL AS NUMERIC), 21204000000, CAST(NULL AS NUMERIC), 32123000000, 40901000000, 25489000000, 'ANNUAL'),
(3, CAST('2016-06-30' AS DATE), 'USD', 58374000000, 91154000000, 32780000000, 32780000000, 26078000000, 4563000000, 11988000000, 32296000000, CAST(NULL AS NUMERIC), -1243000000, 78000000, 1243000000, CAST(NULL AS NUMERIC), -431000000, CAST(NULL AS NUMERIC), 6622000000, 25639000000, 5100000000, CAST(NULL AS NUMERIC), 16798000000, CAST(NULL AS NUMERIC), 26882000000, 33504000000, 20539000000, 'ANNUAL'),
(3, CAST('2015-06-30' AS DATE), 'USD', 60542000000, 93580000000, 33038000000, 33038000000, 18161000000, 4611000000, 12046000000, 42381000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 781000000, CAST(NULL AS NUMERIC), 346000000, CAST(NULL AS NUMERIC), 5957000000, 18507000000, 6314000000, CAST(NULL AS NUMERIC), 12193000000, CAST(NULL AS NUMERIC), 19288000000, 25245000000, 12193000000, 'ANNUAL'),
(3, CAST('2014-06-30' AS DATE), 'USD', 59755000000, 86833000000, 27078000000, 27078000000, 27759000000, 4677000000, 11381000000, 31869000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 597000000, CAST(NULL AS NUMERIC), 61000000, CAST(NULL AS NUMERIC), 5212000000, 27820000000, 5746000000, CAST(NULL AS NUMERIC), 22074000000, CAST(NULL AS NUMERIC), 28417000000, 33629000000, 22074000000, 'ANNUAL'),
(3, CAST('2013-06-30' AS DATE), 'USD', 57464000000, 77849000000, 20385000000, 20385000000, 26764000000, 5013000000, 10411000000, 30700000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 429000000, CAST(NULL AS NUMERIC), 288000000, CAST(NULL AS NUMERIC), 3755000000, 27052000000, 5189000000, CAST(NULL AS NUMERIC), 21863000000, CAST(NULL AS NUMERIC), 27481000000, 31236000000, 21863000000, 'ANNUAL'),
(3, CAST('2012-06-30' AS DATE), 'USD', 56193000000, 73723000000, 17530000000, 17530000000, 21763000000, 4569000000, 9811000000, 28237000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 380000000, CAST(NULL AS NUMERIC), 504000000, CAST(NULL AS NUMERIC), 2967000000, 22267000000, 5289000000, CAST(NULL AS NUMERIC), 16978000000, CAST(NULL AS NUMERIC), 22647000000, 25614000000, 16978000000, 'ANNUAL'),
(3, CAST('2011-06-30' AS DATE), 'USD', 54366000000, 69943000000, 15577000000, 15577000000, 27161000000, 4222000000, 9043000000, 27205000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 295000000, CAST(NULL AS NUMERIC), 910000000, CAST(NULL AS NUMERIC), 2766000000, 28071000000, 4921000000, CAST(NULL AS NUMERIC), 23150000000, CAST(NULL AS NUMERIC), 28366000000, 31132000000, 23150000000, 'ANNUAL'),
(3, CAST('2010-06-30' AS DATE), 'USD', 50089000000, 62484000000, 12395000000, 12395000000, 24098000000, 4063000000, 8714000000, 25991000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 151000000, CAST(NULL AS NUMERIC), 915000000, CAST(NULL AS NUMERIC), 2673000000, 25013000000, 6253000000, CAST(NULL AS NUMERIC), 18760000000, CAST(NULL AS NUMERIC), 25164000000, 27837000000, 18760000000, 'ANNUAL'),
(3, CAST('2009-06-30' AS DATE), 'USD', 46282000000, 58437000000, 12155000000, 12155000000, 20363000000, 4030000000, 9010000000, 25919000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 38000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 2562000000, 19821000000, 5252000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 19859000000, 22421000000, 14569000000, 'ANNUAL'),
(3, CAST('2008-06-30' AS DATE), 'USD', 48822000000, 60420000000, 11598000000, 11598000000, 22271000000, 5127000000, 8164000000, 26551000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 106000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 2056000000, 23814000000, 6133000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 23920000000, 25976000000, 17681000000, 'ANNUAL'),
(3, CAST('2007-06-30' AS DATE), 'USD', 40429000000, 51122000000, 10693000000, 10693000000, 18438000000, 3329000000, 7121000000, 21991000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 0, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 1440000000, 20101000000, 6036000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 18438000000, 19878000000, 14065000000, 'ANNUAL'),
(3, CAST('2006-06-30' AS DATE), 'USD', 36632000000, 44282000000, 7650000000, 7650000000, 16472000000, 3758000000, 6584000000, 20160000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 0, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 903000000, 18262000000, 5663000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 16472000000, 17375000000, 12599000000, 'ANNUAL')
) AS new_data(  stock_id,fiscal_date_ending,reported_currency,gross_profit,total_revenue,cost_of_revenue,
                cost_of_goods_and_services_sold,operating_income,selling_general_and_administrative,
                research_and_development,operating_expenses,investment_income_net,net_interest_income,
                interest_income,interest_expense,non_interest_income,other_non_operating_income,depreciation,
                depreciation_and_amortization,income_before_tax,income_tax_expense,interest_and_debt_expense,
                net_income_from_continuing_operations,comprehensive_income_net_of_tax,ebit,ebitda,net_income,report_type )
WHERE income.stock_id = new_data.stock_id AND income.fiscal_date_ending = new_data.fiscal_date_ending AND income.report_type = 'ANNUAL'

UPDATE alpha_vantage_db.balance_sheet as balance
SET 
fiscal_date_ending = bal_data.new_date
FROM (
    VALUES 
        (3, CAST('2006-12-31' AS DATE), CAST('2006-06-30' AS DATE)),
        (3, CAST('2007-12-31' AS DATE), CAST('2007-06-30' AS DATE)),
        (3, CAST('2008-12-31' AS DATE), CAST('2008-06-30' AS DATE)),
        (3, CAST('2009-12-31' AS DATE), CAST('2009-06-30' AS DATE)),
        (3, CAST('2010-12-31' AS DATE), CAST('2010-06-30' AS DATE)),
        (3, CAST('2011-12-31' AS DATE), CAST('2011-06-30' AS DATE)),
        (3, CAST('2012-12-31' AS DATE), CAST('2012-06-30' AS DATE)),
        (3, CAST('2013-12-31' AS DATE), CAST('2013-06-30' AS DATE)),
        (3, CAST('2014-12-31' AS DATE), CAST('2014-06-30' AS DATE)),
        (3, CAST('2015-12-31' AS DATE), CAST('2015-06-30' AS DATE)),
        (3, CAST('2016-12-31' AS DATE), CAST('2016-06-30' AS DATE)),
        (3, CAST('2017-12-31' AS DATE), CAST('2017-06-30' AS DATE)),
        (3, CAST('2018-12-31' AS DATE), CAST('2018-06-30' AS DATE)),
        (3, CAST('2019-12-31' AS DATE), CAST('2019-06-30' AS DATE)),
        (3, CAST('2020-12-31' AS DATE), CAST('2020-06-30' AS DATE)),
        (3, CAST('2021-12-31' AS DATE), CAST('2021-06-30' AS DATE)),
        (3, CAST('2022-12-31' AS DATE), CAST('2022-06-30' AS DATE)),
        (3, CAST('2023-12-31' AS DATE), CAST('2023-06-30' AS DATE)),
        (3, CAST('2024-12-31' AS DATE), CAST('2024-06-30' AS DATE)),
        (3, CAST('2025-12-31' AS DATE), CAST('2025-06-30' AS DATE))
) AS bal_data(stock_id, old_date, new_date)
WHERE balance.stock_id = bal_data.stock_id 
  AND balance.fiscal_date_ending = bal_data.old_date 
  AND balance.report_type = 'ANNUAL';

UPDATE alpha_vantage_db.balance_sheet as balance
SET 
fiscal_date_ending = new_data.fiscal_date_ending,
reported_currency = new_data.reported_currency,
total_assets = new_data.total_assets,
total_current_assets = new_data.total_current_assets,
cash_and_cash_equivalents_at_carrying_value = new_data.cash_and_cash_equivalents_at_carrying_value,
cash_and_short_term_investments = new_data.cash_and_short_term_investments,
inventory = new_data.inventory,
current_net_receivables = new_data.current_net_receivables,
total_non_current_assets = new_data.total_non_current_assets,
property_plant_equipment = new_data.property_plant_equipment,
accumulated_depreciation_amortization_ppe = new_data.accumulated_depreciation_amortization_ppe,
intangible_assets = new_data.intangible_assets,
intangible_assets_excluding_goodwill = new_data.intangible_assets_excluding_goodwill,
goodwill = new_data.goodwill,
investments = new_data.investments,
long_term_investments = new_data.long_term_investments,
short_term_investments = new_data.short_term_investments,
other_current_assets = new_data.other_current_assets,
other_non_current_assets = new_data.other_non_current_assets,
total_liabilities = new_data.total_liabilities,
total_current_liabilities = new_data.total_current_liabilities,
current_accounts_payable = new_data.current_accounts_payable,
deferred_revenue = new_data.deferred_revenue,
current_debt = new_data.current_debt,
short_term_debt = new_data.short_term_debt,
total_non_current_liabilities = new_data.total_non_current_liabilities,
capital_lease_obligations = new_data.capital_lease_obligations,
long_term_debt = new_data.long_term_debt,
current_long_term_debt = new_data.current_long_term_debt,
long_term_debt_noncurrent = new_data.long_term_debt_noncurrent,
short_long_term_debt_total = new_data.short_long_term_debt_total,
other_current_liabilities = new_data.other_current_liabilities,
other_non_current_liabilities = new_data.other_non_current_liabilities,
total_shareholder_equity = new_data.total_shareholder_equity,
treasury_stock = new_data.treasury_stock,
retained_earnings = new_data.retained_earnings,
common_stock = new_data.common_stock,
common_stock_shares_outstanding = new_data.common_stock_shares_outstanding,
report_type = new_data.report_type
FROM (
VALUES 
(3, CAST('2025-06-30' AS DATE), 'USD', 619003000000, 191131000000, 30242000000, 30242000000, 938000000, 69905000000, 427872000000, 229789000000, CAST(NULL AS NUMERIC), 22604000000, 22604000000, 119509000000, CAST(NULL AS NUMERIC), 15133000000, 64313000000, 25733000000, CAST(NULL AS NUMERIC), 275524000000, 141218000000, 27724000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 11595000000, 134306000000, 17437000000, 40152000000, 2999000000, CAST(NULL AS NUMERIC), 112184000000, 37344000000, 45186000000, 343479000000, CAST(NULL AS NUMERIC), 237731000000, 109095000000, 7465000000, 'ANNUAL'),
(3, CAST('2024-06-30' AS DATE), 'USD', 512163000000, 159734000000, 18315000000, 18315000000, 1246000000, 56924000000, 352429000000, 154552000000, CAST(NULL AS NUMERIC), 27597000000, 27597000000, 119220000000, CAST(NULL AS NUMERIC), 14600000000, 57216000000, 26033000000, CAST(NULL AS NUMERIC), 243686000000, 125286000000, 21996000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 14871000000, 118400000000, 15497000000, 42688000000, 8942000000, CAST(NULL AS NUMERIC), 97852000000, 25820000000, 27064000000, 268477000000, CAST(NULL AS NUMERIC), 173144000000, 100923000000, 7469000000, 'ANNUAL'),
(3, CAST('2023-06-30' AS DATE), 'USD', 411976000000, 184257000000, 34704000000, 34704000000, 2500000000, 48688000000, 227719000000, 109987000000, CAST(NULL AS NUMERIC), 9366000000, 9366000000, 67886000000, CAST(NULL AS NUMERIC), 9879000000, 76558000000, 21807000000, CAST(NULL AS NUMERIC), 205753000000, 104149000000, 18095000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 5247000000, 101604000000, 12728000000, 41990000000, 5247000000, CAST(NULL AS NUMERIC), 59965000000, 29906000000, 17981000000, 206223000000, CAST(NULL AS NUMERIC), 118848000000, 93718000000, 7472000000, 'ANNUAL'),
(3, CAST('2022-06-30' AS DATE), 'USD', 364840000000, 169684000000, 13931000000, 13931000000, 3742000000, 44261000000, 195156000000, 87546000000, CAST(NULL AS NUMERIC), 11298000000, 11298000000, 67524000000, CAST(NULL AS NUMERIC), 6891000000, 90826000000, 16924000000, CAST(NULL AS NUMERIC), 198298000000, 95082000000, 19000000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 2749000000, 103216000000, 11489000000, 47032000000, 2749000000, CAST(NULL AS NUMERIC), 61270000000, 27795000000, 15526000000, 166542000000, CAST(NULL AS NUMERIC), 84281000000, 86939000000, 7540000000, 'ANNUAL'),
(3, CAST('2021-06-30' AS DATE), 'USD', 333779000000, 184406000000, 14224000000, 14224000000, 2636000000, 38043000000, 149373000000, 70803000000, CAST(NULL AS NUMERIC), 7800000000, 7800000000, 49711000000, CAST(NULL AS NUMERIC), 5984000000, 116110000000, 13393000000, CAST(NULL AS NUMERIC), 191791000000, 88657000000, 15163000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 8072000000, 103134000000, 9629000000, 50074000000, 8072000000, CAST(NULL AS NUMERIC), 67775000000, 23897000000, 13427000000, 141988000000, CAST(NULL AS NUMERIC), 57055000000, 83111000000, 7608000000, 'ANNUAL'),
(3, CAST('2020-06-30' AS DATE), 'USD', 301311000000, 181915000000, 13576000000, 13576000000, 1895000000, 32011000000, 119396000000, 44151000000, CAST(NULL AS NUMERIC), 7038000000, 7038000000, 43351000000, CAST(NULL AS NUMERIC), 2965000000, 122951000000, 11482000000, CAST(NULL AS NUMERIC), 183007000000, 72310000000, 12530000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 3749000000, 110697000000, 7671000000, 59578000000, 3749000000, CAST(NULL AS NUMERIC), 70998000000, 20031000000, 50915000000, 118304000000, CAST(NULL AS NUMERIC), 34566000000, 80552000000, 7683000000, 'ANNUAL'),
(3, CAST('2019-06-30' AS DATE), 'USD', 286556000000, 175552000000, 11356000000, 11356000000, 2063000000, 29524000000, 111004000000, 36477000000, CAST(NULL AS NUMERIC), 7750000000, 7750000000, 42026000000, CAST(NULL AS NUMERIC), 2649000000, 122463000000, 10146000000, CAST(NULL AS NUMERIC), 184226000000, 69420000000, 9382000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 5516000000, 114806000000, 6188000000, 66662000000, 5516000000, CAST(NULL AS NUMERIC), 78366000000, 21846000000, 47911000000, 102330000000, CAST(NULL AS NUMERIC), 24150000000, 78520000000, 7753000000, 'ANNUAL'),
(3, CAST('2018-06-30' AS DATE), 'USD', 258848000000, 169662000000, 11946000000, 11946000000, 2662000000, 26481000000, 89186000000, 29460000000, CAST(NULL AS NUMERIC), 8053000000, 8053000000, 35683000000, CAST(NULL AS NUMERIC), 1862000000, 121822000000, 6751000000, CAST(NULL AS NUMERIC), 176130000000, 58488000000, 8617000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 3998000000, 117642000000, 5568000000, 72242000000, 3998000000, CAST(NULL AS NUMERIC), 81808000000, 16968000000, 44859000000, 82718000000, 0, 13682000000, 71223000000, 7794000000, 'ANNUAL'),
(3, CAST('2017-06-30' AS DATE), 'USD', 241086000000, 159851000000, 7663000000, 7663000000, 2181000000, 19792000000, 81235000000, 23734000000, CAST(NULL AS NUMERIC), 10106000000, 10106000000, 35122000000, CAST(NULL AS NUMERIC), 6023000000, 125318000000, 4897000000, CAST(NULL AS NUMERIC), 168692000000, 64527000000, 7390000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 10121000000, 104165000000, CAST(NULL AS NUMERIC), 76073000000, 10121000000, CAST(NULL AS NUMERIC), 86194000000, 12914000000, 17184000000, 72394000000, 0, 2648000000, 69315000000, 7832000000, 'ANNUAL'),
(3, CAST('2016-06-30' AS DATE), 'USD', 193694000000, 139660000000, 6510000000, 6510000000, 2251000000, 18277000000, 54034000000, 18356000000, CAST(NULL AS NUMERIC), 3733000000, 3733000000, 17872000000, CAST(NULL AS NUMERIC), 10431000000, 106730000000, 5892000000, CAST(NULL AS NUMERIC), 121697000000, 59357000000, 6898000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 12904000000, 62340000000, CAST(NULL AS NUMERIC), 40783000000, 12904000000, CAST(NULL AS NUMERIC), 53687000000, 12087000000, 13640000000, 71997000000, 0, 2282000000, 68178000000, 8013000000, 'ANNUAL'),
(3, CAST('2015-06-30' AS DATE), 'USD', 174472000000, 122797000000, 5595000000, 5595000000, 2902000000, 17908000000, 51675000000, 14731000000, CAST(NULL AS NUMERIC), 4835000000, 4835000000, 16939000000, CAST(NULL AS NUMERIC), 12053000000, 90931000000, 5461000000, CAST(NULL AS NUMERIC), 94389000000, 49647000000, 6591000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 7484000000, 44742000000, CAST(NULL AS NUMERIC), 27808000000, 2499000000, CAST(NULL AS NUMERIC), 35292000000, 11743000000, 13544000000, 80083000000, 0, 9096000000, 68465000000, 8254000000, 'ANNUAL'),
(3, CAST('2014-06-30' AS DATE), 'USD', 172384000000, 114246000000, 8669000000, 8669000000, 2660000000, 19544000000, 58138000000, 13011000000, CAST(NULL AS NUMERIC), 6981000000, 6981000000, 20127000000, CAST(NULL AS NUMERIC), 14597000000, 77040000000, 6333000000, CAST(NULL AS NUMERIC), 82600000000, 45625000000, 7432000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 2000000000, 36975000000, CAST(NULL AS NUMERIC), 20645000000, 23203000000, CAST(NULL AS NUMERIC), 22645000000, 12261000000, 11594000000, 89784000000, 0, 17710000000, 68366000000, 8399000000, 'ANNUAL'),
(3, CAST('2013-06-30' AS DATE), 'USD', 142431000000, 101466000000, 3804000000, 3804000000, 1938000000, 17486000000, 40965000000, 9991000000, CAST(NULL AS NUMERIC), 3083000000, 3083000000, 14655000000, CAST(NULL AS NUMERIC), 10844000000, 73218000000, 5020000000, CAST(NULL AS NUMERIC), 63487000000, 37417000000, 4828000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 2999000000, 26070000000, CAST(NULL AS NUMERIC), 12601000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 15600000000, 8359000000, 10000000000, 78944000000, 0, 9895000000, 67306000000, 8470000000, 'ANNUAL'),
(3, CAST('2012-06-30' AS DATE), 'USD', 121271000000, 85084000000, 6938000000, 6938000000, 1137000000, 15780000000, 36187000000, 8269000000, CAST(NULL AS NUMERIC), 3170000000, 3170000000, 13452000000, CAST(NULL AS NUMERIC), 9776000000, 56102000000, 5127000000, CAST(NULL AS NUMERIC), 54908000000, 32688000000, 4175000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 1231000000, 22220000000, CAST(NULL AS NUMERIC), 10713000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 11944000000, 7840000000, 8208000000, 66363000000, 0, 566000000, 65797000000, 8506000000, 'ANNUAL'),
(3, CAST('2011-06-30' AS DATE), 'USD', 108704000000, 74918000000, 9610000000, 9610000000, 1372000000, 14987000000, 33786000000, 8162000000, CAST(NULL AS NUMERIC), 744000000, 744000000, 12581000000, CAST(NULL AS NUMERIC), 10865000000, 43162000000, 3320000000, CAST(NULL AS NUMERIC), 51621000000, 28774000000, 4197000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 5363000000, 22847000000, CAST(NULL AS NUMERIC), 11921000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 17284000000, 3492000000, 8072000000, 57083000000, 0, -6332000000, 63415000000, 8593000000, 'ANNUAL'),
(3, CAST('2010-06-30' AS DATE), 'USD', 86113000000, 55676000000, 5505000000, 5505000000, 740000000, 13014000000, 30437000000, 7630000000, CAST(NULL AS NUMERIC), 1158000000, 1158000000, 12394000000, CAST(NULL AS NUMERIC), 7754000000, 31283000000, 5134000000, CAST(NULL AS NUMERIC), 39938000000, 26147000000, 4025000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 1000000000, 13791000000, CAST(NULL AS NUMERIC), 4939000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 5939000000, 6396000000, 7445000000, 46175000000, 0, -16681000000, 62856000000, 8927000000, 'ANNUAL'),
(3, CAST('2009-06-30' AS DATE), 'USD', 77888000000, 49280000000, 6076000000, 6111000000, 717000000, 11192000000, 28608000000, 7535000000, CAST(NULL AS NUMERIC), 1759000000, 1759000000, 12503000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 25371000000, 3711000000, CAST(NULL AS NUMERIC), 38330000000, 27034000000, 3324000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 2000000000, 11296000000, CAST(NULL AS NUMERIC), 3756000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 5756000000, 8707000000, CAST(NULL AS NUMERIC), 39558000000, CAST(NULL AS NUMERIC), -22824000000, 62382000000, 8996000000, 'ANNUAL'),
(3, CAST('2008-06-30' AS DATE), 'USD', 72793000000, 43242000000, 10339000000, 10339000000, 985000000, 13589000000, 29551000000, 6242000000, CAST(NULL AS NUMERIC), 1973000000, 1973000000, 12108000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 13323000000, 5006000000, CAST(NULL AS NUMERIC), 36507000000, 29886000000, 4034000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 8796000000, 6621000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 9207000000, CAST(NULL AS NUMERIC), 36286000000, CAST(NULL AS NUMERIC), -27703000000, 62849000000, 9470000000, 'ANNUAL'),
(3, CAST('2007-06-30' AS DATE), 'USD', 63171000000, 40168000000, 6111000000, 6111000000, 1127000000, 11338000000, 23003000000, 4350000000, CAST(NULL AS NUMERIC), 878000000, 878000000, 4760000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 17300000000, 4292000000, CAST(NULL AS NUMERIC), 32074000000, 23754000000, 3247000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 2325000000, 8320000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 9728000000, CAST(NULL AS NUMERIC), 31097000000, CAST(NULL AS NUMERIC), -31114000000, 60557000000, 9886000000, 'ANNUAL'),
(3, CAST('2006-06-30' AS DATE), 'USD', 69597000000, 49010000000, 6714000000, 6714000000, 1478000000, 9316000000, 20587000000, 3044000000, CAST(NULL AS NUMERIC), 539000000, 539000000, 3866000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 27447000000, 4055000000, CAST(NULL AS NUMERIC), 29493000000, 22442000000, 2909000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 3495000000, 7051000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 10395000000, CAST(NULL AS NUMERIC), 40104000000, CAST(NULL AS NUMERIC), -20130000000, 59005000000, 10531000000, 'ANNUAL')
) AS new_data(  stock_id,fiscal_date_ending,reported_currency,total_assets,total_current_assets,
                cash_and_cash_equivalents_at_carrying_value,cash_and_short_term_investments,inventory,
                current_net_receivables,total_non_current_assets,property_plant_equipment,
                accumulated_depreciation_amortization_ppe,intangible_assets,intangible_assets_excluding_goodwill,
                goodwill,investments,long_term_investments,short_term_investments,other_current_assets,
                other_non_current_assets,total_liabilities,total_current_liabilities,current_accounts_payable,
                deferred_revenue,current_debt,short_term_debt,total_non_current_liabilities,
                capital_lease_obligations,long_term_debt,current_long_term_debt,long_term_debt_noncurrent,
                short_long_term_debt_total,other_current_liabilities,other_non_current_liabilities,
                total_shareholder_equity,treasury_stock,retained_earnings,common_stock,
                common_stock_shares_outstanding,report_type)
WHERE balance.stock_id = new_data.stock_id AND balance.fiscal_date_ending = new_data.fiscal_date_ending AND balance.report_type = 'ANNUAL';

UPDATE alpha_vantage_db.cash_flow as cash
SET 
fiscal_date_ending = cf_data.new_date
FROM (
    VALUES 
        (3, CAST('2006-12-31' AS DATE), CAST('2006-06-30' AS DATE)),
        (3, CAST('2007-12-31' AS DATE), CAST('2007-06-30' AS DATE)),
        (3, CAST('2008-12-31' AS DATE), CAST('2008-06-30' AS DATE)),
        (3, CAST('2009-12-31' AS DATE), CAST('2009-06-30' AS DATE)),
        (3, CAST('2010-12-31' AS DATE), CAST('2010-06-30' AS DATE)),
        (3, CAST('2011-12-31' AS DATE), CAST('2011-06-30' AS DATE)),
        (3, CAST('2012-12-31' AS DATE), CAST('2012-06-30' AS DATE)),
        (3, CAST('2013-12-31' AS DATE), CAST('2013-06-30' AS DATE)),
        (3, CAST('2014-12-31' AS DATE), CAST('2014-06-30' AS DATE)),
        (3, CAST('2015-12-31' AS DATE), CAST('2015-06-30' AS DATE)),
        (3, CAST('2016-12-31' AS DATE), CAST('2016-06-30' AS DATE)),
        (3, CAST('2017-12-31' AS DATE), CAST('2017-06-30' AS DATE)),
        (3, CAST('2018-12-31' AS DATE), CAST('2018-06-30' AS DATE)),
        (3, CAST('2019-12-31' AS DATE), CAST('2019-06-30' AS DATE)),
        (3, CAST('2020-12-31' AS DATE), CAST('2020-06-30' AS DATE)),
        (3, CAST('2021-12-31' AS DATE), CAST('2021-06-30' AS DATE)),
        (3, CAST('2022-12-31' AS DATE), CAST('2022-06-30' AS DATE)),
        (3, CAST('2023-12-31' AS DATE), CAST('2023-06-30' AS DATE)),
        (3, CAST('2024-12-31' AS DATE), CAST('2024-06-30' AS DATE)),
        (3, CAST('2025-12-31' AS DATE), CAST('2025-06-30' AS DATE))
) AS cf_data(stock_id, old_date, new_date)
WHERE cash.stock_id = cf_data.stock_id 
  AND cash.fiscal_date_ending = cf_data.old_date 
  AND cash.report_type = 'ANNUAL';


UPDATE alpha_vantage_db.cash_flow as cash
SET 
fiscal_date_ending = new_data.fiscal_date_ending,
reported_currency = new_data.reported_currency,
operating_cashflow = new_data.operating_cashflow,
payments_for_operating_activities = new_data.payments_for_operating_activities,
proceeds_from_operating_activities = new_data.proceeds_from_operating_activities,
change_in_operating_liabilities = new_data.change_in_operating_liabilities,
change_in_operating_assets = new_data.change_in_operating_assets,
depreciation_depletion_and_amortization = new_data.depreciation_depletion_and_amortization,
capital_expenditures = new_data.capital_expenditures,
change_in_receivables = new_data.change_in_receivables,
change_in_inventory = new_data.change_in_inventory,
profit_loss = new_data.profit_loss,
cashflow_from_investment = new_data.cashflow_from_investment,
cashflow_from_financing = new_data.cashflow_from_financing,
proceeds_from_repayments_of_short_term_debt = new_data.proceeds_from_repayments_of_short_term_debt,
payments_for_repurchase_of_common_stock = new_data.payments_for_repurchase_of_common_stock,
payments_for_repurchase_of_equity = new_data.payments_for_repurchase_of_equity,
payments_for_repurchase_of_preferred_stock = new_data.payments_for_repurchase_of_preferred_stock,
dividend_payout = new_data.dividend_payout,
dividend_payout_common_stock = new_data.dividend_payout_common_stock,
dividend_payout_preferred_stock = new_data.dividend_payout_preferred_stock,
proceeds_from_issuance_of_common_stock = new_data.proceeds_from_issuance_of_common_stock,
proceeds_from_issuance_of_long_term_debt_and_capital_securities = new_data.proceeds_from_issuance_of_long_term_debt_and_capital_securities,
proceeds_from_issuance_of_preferred_stock = new_data.proceeds_from_issuance_of_preferred_stock,
proceeds_from_repurchase_of_equity = new_data.proceeds_from_repurchase_of_equity,
proceeds_from_sale_of_treasury_stock = new_data.proceeds_from_sale_of_treasury_stock,
stock_based_compensation = new_data.stock_based_compensation,
change_in_cash_and_cash_equivalents = new_data.change_in_cash_and_cash_equivalents,
change_in_exchange_rate = new_data.change_in_exchange_rate,
net_income = new_data.net_income,
report_type = new_data.report_type
FROM (
VALUES 
(3, CAST('2025-06-30' AS DATE), 'USD', 136162000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 34153000000, 64551000000, CAST(NULL AS NUMERIC), 309000000, CAST(NULL AS NUMERIC), -72599000000, -51699000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 24082000000, 24082000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), -18420000000, CAST(NULL AS NUMERIC), 11974000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 101832000000, 'ANNUAL'),
(3, CAST('2024-06-30' AS DATE), 'USD', 118548000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 22287000000, 44477000000, CAST(NULL AS NUMERIC), 1284000000, CAST(NULL AS NUMERIC), -96970000000, -37757000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 21771000000, 21771000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), -17254000000, CAST(NULL AS NUMERIC), 10734000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 88136000000, 'ANNUAL'),
(3, CAST('2023-06-30' AS DATE), 'USD', 87582000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 13861000000, 28107000000, CAST(NULL AS NUMERIC), 1242000000, CAST(NULL AS NUMERIC), -22680000000, -43935000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 19800000000, 19800000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), -22245000000, CAST(NULL AS NUMERIC), 9611000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 72361000000, 'ANNUAL'),
(3, CAST('2022-06-30' AS DATE), 'USD', 89035000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 14460000000, 23886000000, -6834000000, -1123000000, CAST(NULL AS NUMERIC), -30311000000, -58876000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 18135000000, 18135000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), -32696000000, CAST(NULL AS NUMERIC), 7502000000, -152000000, CAST(NULL AS NUMERIC), 72738000000, 'ANNUAL'),
(3, CAST('2021-06-30' AS DATE), 'USD', 76740000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 11686000000, 20622000000, -6481000000, -737000000, CAST(NULL AS NUMERIC), -27577000000, -48486000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 16521000000, 16521000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), -27385000000, CAST(NULL AS NUMERIC), 6118000000, 648000000, -29000000, 61271000000, 'ANNUAL'),
(3, CAST('2020-06-30' AS DATE), 'USD', 60675000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 12796000000, 15441000000, -2577000000, 168000000, CAST(NULL AS NUMERIC), -12223000000, -46031000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 15137000000, 15137000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), -22968000000, CAST(NULL AS NUMERIC), 5289000000, 2220000000, -201000000, 44281000000, 'ANNUAL'),
(3, CAST('2019-06-30' AS DATE), 'USD', 52185000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 11682000000, 13925000000, -2812000000, 597000000, CAST(NULL AS NUMERIC), -15773000000, -36887000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 13811000000, 13811000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), -19543000000, CAST(NULL AS NUMERIC), 4652000000, -590000000, -115000000, 39240000000, 'ANNUAL'),
(3, CAST('2018-06-30' AS DATE), 'USD', 43884000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 10261000000, 11632000000, -3862000000, -465000000, CAST(NULL AS NUMERIC), -6061000000, -33590000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 12699000000, 12699000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), -10721000000, CAST(NULL AS NUMERIC), 3940000000, 4283000000, 50000000, 16571000000, 'ANNUAL'),
(3, CAST('2017-06-30' AS DATE), 'USD', 39507000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 8778000000, 8129000000, -925000000, 50000000, CAST(NULL AS NUMERIC), -46781000000, 8408000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 11845000000, 11845000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), -11788000000, CAST(NULL AS NUMERIC), 3266000000, 1153000000, 19000000, 25489000000, 'ANNUAL'),
(3, CAST('2016-06-30' AS DATE), 'USD', 33325000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 6622000000, 8343000000, -530000000, 600000000, CAST(NULL AS NUMERIC), -23950000000, -8393000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 11006000000, 11006000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), -15969000000, CAST(NULL AS NUMERIC), 2668000000, 915000000, -67000000, 20539000000, 'ANNUAL'),
(3, CAST('2015-06-30' AS DATE), 'USD', 29668000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 5957000000, 5944000000, 1456000000, -272000000, CAST(NULL AS NUMERIC), -23001000000, -9668000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 9882000000, 9882000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), -14443000000, CAST(NULL AS NUMERIC), 2574000000, -3074000000, -73000000, 12193000000, 'ANNUAL'),
(3, CAST('2014-06-30' AS DATE), 'USD', 32502000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 5212000000, 5485000000, -1120000000, -161000000, CAST(NULL AS NUMERIC), -18833000000, -8665000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 8879000000, 8879000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), -7316000000, CAST(NULL AS NUMERIC), 2446000000, 4865000000, -139000000, 22074000000, 'ANNUAL'),
(3, CAST('2013-06-30' AS DATE), 'USD', 28833000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 3755000000, 4257000000, -1807000000, -802000000, CAST(NULL AS NUMERIC), -23811000000, -8148000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 7455000000, 7455000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), -5360000000, CAST(NULL AS NUMERIC), 2406000000, -3134000000, -8000000, 21863000000, 'ANNUAL'),
(3, CAST('2012-06-30' AS DATE), 'USD', 31626000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 2967000000, 2305000000, -1156000000, 184000000, CAST(NULL AS NUMERIC), -24786000000, -9408000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 6385000000, 6385000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), -5029000000, CAST(NULL AS NUMERIC), 2244000000, -2672000000, -104000000, 16978000000, 'ANNUAL'),
(3, CAST('2011-06-30' AS DATE), 'USD', 26994000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 2766000000, 2355000000, -1451000000, -561000000, CAST(NULL AS NUMERIC), -14616000000, -8376000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 5180000000, 5180000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), -11555000000, CAST(NULL AS NUMERIC), 2166000000, 4105000000, 103000000, 23150000000, 'ANNUAL'),
(3, CAST('2010-06-30' AS DATE), 'USD', 24073000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 2673000000, 1977000000, -2238000000, 0, CAST(NULL AS NUMERIC), -11314000000, -13291000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 4578000000, 4578000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), -11269000000, CAST(NULL AS NUMERIC), 1891000000, -571000000, -39000000, 18760000000, 'ANNUAL'),
(3, CAST('2009-06-30' AS DATE), 'USD', 19037000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 2562000000, 3119000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), -15770000000, -7463000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 4468000000, 4468000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), -9353000000, CAST(NULL AS NUMERIC), 1708000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 14569000000, 'ANNUAL'),
(3, CAST('2008-06-30' AS DATE), 'USD', 21612000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 2056000000, 3182000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), -4587000000, -12934000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 4015000000, 4015000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), -12533000000, CAST(NULL AS NUMERIC), 1479000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 17681000000, 'ANNUAL'),
(3, CAST('2007-06-30' AS DATE), 'USD', 17796000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 1440000000, 2264000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 6089000000, -24544000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 3805000000, 3805000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), -27575000000, CAST(NULL AS NUMERIC), -292000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 14065000000, 'ANNUAL'),
(3, CAST('2006-06-30' AS DATE), 'USD', 14404000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 903000000, 1578000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 8003000000, -20562000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 3545000000, 3545000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), -19207000000, CAST(NULL AS NUMERIC), 1454000000, CAST(NULL AS NUMERIC), CAST(NULL AS NUMERIC), 12599000000, 'ANNUAL')
) AS new_data(  stock_id,fiscal_date_ending,reported_currency,operating_cashflow,payments_for_operating_activities,
                proceeds_from_operating_activities,change_in_operating_liabilities,change_in_operating_assets,
                depreciation_depletion_and_amortization,capital_expenditures,change_in_receivables,
                change_in_inventory,profit_loss,cashflow_from_investment,cashflow_from_financing,
                proceeds_from_repayments_of_short_term_debt,payments_for_repurchase_of_common_stock,
                payments_for_repurchase_of_equity,payments_for_repurchase_of_preferred_stock,dividend_payout,
                dividend_payout_common_stock,dividend_payout_preferred_stock,proceeds_from_issuance_of_common_stock,
                proceeds_from_issuance_of_long_term_debt_and_capital_securities,proceeds_from_issuance_of_preferred_stock,
                proceeds_from_repurchase_of_equity,proceeds_from_sale_of_treasury_stock,stock_based_compensation,
                change_in_cash_and_cash_equivalents,change_in_exchange_rate,net_income,report_type )
WHERE cash.stock_id = new_data.stock_id 
  AND cash.fiscal_date_ending = new_data.fiscal_date_ending 
  AND cash.report_type = 'ANNUAL';
