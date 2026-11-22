from .loader import *
import pandas as pd 

class FinanceStatement:
    def __init__(self,data_loader = None):
        self.df = pd.DataFrame()
        self.data_loader = data_loader

    def set_loading_type(self,data_loader):
        self.data_loader = data_loader

    def perform_load(self,table_or_csv):
        self.df = self.data_loader.get_data(table_or_csv)  

    def write_csv(self,csvname):
        return self.df.to_csv(csvname,index=False)
    
    def get_numeric_columns(self):
        return self.df.select_dtypes(include='number').columns[1:-1]

    def get_unique_ticker(self):
        return self.df["ticker"].unique()

    def calc_columns(self):
        pass
    
class IncomeStatement(FinanceStatement):
    def __str__(self):
        return f"Creating an object for income statement"
    def calc_columns(self,tickers,report_type):
        calc_df = (self.df.query(f"report_type == '{report_type}' and ticker in @tickers")
                            .sort_values(by=['stock_id','fiscal_date_ending'],ascending=True)
                            .assign(calc_net_income = lambda x: x["operating_income"] - x["income_tax_expense"],
                                    revenue_growth = lambda x: (x["total_revenue"] - x.groupby("ticker")["total_revenue"].shift(-1)) 
                                                                / x.groupby("ticker")["total_revenue"].shift(-1) * 100,
                                    gross_margin = lambda x: x["gross_profit"]/x["total_revenue"] * 100,
                                    operating_margin = lambda x: x["ebit"]/x["total_revenue"] * 100,
                                    net_margin = lambda x: (x["operating_income"] - x["income_tax_expense"])/x["total_revenue"] * 100,
                                    cogs_margin = lambda x: x["cost_of_revenue"]/x["total_revenue"] * 100,
                                    expense_margin = lambda x: x["operating_expenses"]/x["total_revenue"] * 100,
                                    tax_margin = lambda x: x["income_tax_expense"]/x["total_revenue"] * 100,
                                    year_str = lambda x: pd.to_datetime(x["fiscal_date_ending"]).dt.year.astype(str)))  
        return calc_df

class BalanceSheet(FinanceStatement):
    def __str__(self):
        return f"Creating an object for balance sheet"

    def calc_columns(self,tickers,report_type,income_df):
        calc_df = (self.df.query(f"report_type == '{report_type}' and ticker in @tickers")
                          .sort_values(by=['stock_id','fiscal_date_ending'],ascending=True)
                          .assign(  current_ratio = lambda x: x["total_current_assets"]/x["total_current_liabilities"],
                                    liabilities_to_equity = lambda x: x["total_liabilities"]/x["total_shareholder_equity"],
                                    return_on_equity = lambda x: income_df["net_income"]/x["total_shareholder_equity"] *100,
                                    year_str = lambda x: pd.to_datetime(x["fiscal_date_ending"]).dt.year.astype(str)))
        return calc_df

class CashFlowStatement(FinanceStatement):
    def __str__(self):
        return f"Creating an object for cashflow statement"

    def calc_columns(self,tickers,report_type):
        calc_df = df = (self.df.query(f"report_type == '{report_type}' and ticker in @tickers")
                               .sort_values(by=['stock_id','fiscal_date_ending'],ascending=True)
                               .assign(free_cash_flow = lambda x: x["operating_cashflow"] - x["capital_expenditures"],
                                       year_str = lambda x: pd.to_datetime(x["fiscal_date_ending"]).dt.year.astype(str)))
        return calc_df
