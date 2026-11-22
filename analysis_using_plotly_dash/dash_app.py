from dash.dependencies import Output, Input
from dash.exceptions import PreventUpdate
from dash_bootstrap_templates import load_figure_template
from dash import Dash, dcc, html, dash_table
import dash_bootstrap_components as dbc
import pandas as pd 
import numpy as np 
from pathlib import Path

#from statement_utility import BalanceSheetTable, CashFlowTable, IncomeStatementTable, Stock
#from statement_utility import DatabaseLoader
from statement_utility import CSVLoader
from statement_utility import IncomeStatement,BalanceSheet,CashFlowStatement
from plot_utility import BarGraph,LineGraph,PieGraph,HorizontalBarGraph,WaterfallPlot
from dash_utility import FinanceTab

template_name = "superhero"
dbc_css = "https://cdn.jsdelivr.net/gh/AnnMarieW/dash-bootstrap-templates/dbc.min.css"
load_figure_template(template_name)
app = Dash(__name__,external_stylesheets=[dbc.themes.SUPERHERO,dbc_css],suppress_callback_exceptions=True)

cwd = Path(__file__).parent

income_csv_name = cwd  / 'data' / 'income_statement.csv'
balance_csv_name = cwd / 'data' / 'balance_sheet.csv'
cashflow_csv_name = cwd / 'data' / 'cashflow.csv'

income_statement = IncomeStatement(data_loader=CSVLoader())
income_statement.perform_load(table_or_csv=income_csv_name)
balance_sheet = BalanceSheet(data_loader=CSVLoader())
balance_sheet.perform_load(table_or_csv=balance_csv_name)
cashflow = CashFlowStatement(data_loader=CSVLoader())
cashflow.perform_load(table_or_csv=cashflow_csv_name)

income_tab = FinanceTab(id="income_tab",label="IncomeStatement",statement=income_statement,component="total_revenue")
balance_tab = FinanceTab(id="balance_tab",label="BalanceStatement",statement=balance_sheet,component="total_assets")
cashflow_tab = FinanceTab(id="cash_tab",label="CashflowStatement",statement=cashflow,component="operating_cashflow")

app.layout = html.Div([
                        dcc.Tabs([
                                        income_tab.create_tab(),
                                        balance_tab.create_tab(),
                                        cashflow_tab.create_tab()
                                ])
                    ],className="dbc")

@app.callback(
    Output("IncomeStatement_stock_dropdown", "multi"),
    Output("IncomeStatement_stock_dropdown", "value"),
    Output("IncomeStatement_component_dropdown", "multi"),
    Output("IncomeStatement_component_dropdown", "value"),
    Input("IncomeStatement_output_picker", "value")
)
def income_tab_toggle_dropdown_modes(comparison_type):
    if comparison_type == "stock":
        # Multi-stock selection, single financial structural item
        return True, ["AAPL"], False, "total_revenue"
    else:
        # Single stock selection, multi structural item component layout
        return False, "AAPL", True, ["total_revenue", "net_income"]
    
@app.callback(
    Output("IncomeStatement_title","children"),
    Output("IncomeStatement_first_plot","figure"),
    Input("IncomeStatement_stock_dropdown","value"),
    Input("IncomeStatement_component_dropdown","value"),
    Input("IncomeStatement_graph_picker","value"),
    Input("IncomeStatement_year_picker","value"),
    Input("IncomeStatement_reporttype","value"),
    Input("IncomeStatement_output_picker","value"),
)
def first_plot_income_tab(tickers,column_name,graph_type,last_x_years,report_type,comparison_type):
    if not tickers:
        raise PreventUpdate
    
    df = (income_statement.calc_columns(tickers,report_type)
            .groupby("ticker").tail(last_x_years if report_type == "ANNUAL" else last_x_years*4))

    if graph_type == "bar":
        fig = BarGraph(df,report_type,column_name,comparison_type).create_plot()
    else:
        fig = LineGraph(df,report_type,column_name,comparison_type).create_plot()

    title =  "**NO TITLE**"
    return title,fig

@app.callback(
    Output("IncomeStatement_second_plot","figure"),
    Input("IncomeStatement_first_plot","hoverData"),
    Input("IncomeStatement_stock_dropdown","value"),
    Input("IncomeStatement_reporttype","value"),
)
def second_plot_income_tab(hoverData,tickers,report_type):
    # 1. Broad safety catch for missing or empty hover data
    if not hoverData or "points" not in hoverData or not tickers:
        raise PreventUpdate
    point = hoverData["points"][0]
    custom_data = point.get("customdata")
    
    # 2. Crash protection: Exit early if customdata isn't populated yet
    if custom_data is None:
        raise PreventUpdate

    df = (income_statement.calc_columns(tickers,report_type)
                          .astype({"fiscal_date_ending":"datetime64[ns]"}))
    
    year = pd.to_datetime(hoverData["points"][0]["customdata"][0])
    plot_df = (
                pd.DataFrame(df[df.fiscal_date_ending == year][["cost_of_revenue","operating_expenses","income_tax_expense","calc_net_income"]].T)
                .reset_index()
            )

    if plot_df.shape[1] != 2:
        raise PreventUpdate
    
    plot_df.columns = ["col1", "col2"]

    color_discrete_map =    {   'cost_of_revenue':'navyblue',
                                'operating_expenses':'cyan',
                                'income_tax_expense':'royalblue',
                                'calc_net_income':'darkblue'}
    fig = PieGraph(plot_df).create_plot(color_discrete_map,title="Revenue Composition")

    return fig

@app.callback(
    Output("BalanceStatement_stock_dropdown", "multi"),
    Output("BalanceStatement_stock_dropdown", "value"),
    Output("BalanceStatement_component_dropdown", "multi"),
    Output("BalanceStatement_component_dropdown", "value"),
    Input("BalanceStatement_output_picker", "value")
)
def balance_tab_toggle_dropdown_modes(comparison_type):
    if comparison_type == "stock":
        # Multi-stock selection, single financial structural item
        return True, ["AAPL"], False, "total_current_assets"
    else:
        # Single stock selection, multi structural item component layout
        return False, "AAPL", True, ["total_current_assets", "total_current_liabilities"]
    
@app.callback(
    Output("BalanceStatement_title","children"),
    Output("BalanceStatement_first_plot","figure"),
    Input("BalanceStatement_stock_dropdown","value"),
    Input("BalanceStatement_component_dropdown","value"),
    Input("BalanceStatement_graph_picker","value"),
    Input("BalanceStatement_year_picker","value"),
    Input("BalanceStatement_reporttype","value"),
    Input("BalanceStatement_output_picker","value"),
)
def first_plot_balance_tab(tickers,column_name,graph_type,last_x_years,report_type,comparison_type):
    if not tickers:
        raise PreventUpdate
    
    df = (balance_sheet.calc_columns(tickers,report_type,income_statement.df)       
            .groupby("ticker").tail(last_x_years if report_type == "ANNUAL" else last_x_years*4))

    if graph_type == "bar":
        fig = BarGraph(df,report_type,column_name,comparison_type).create_plot()
    else:
        fig = LineGraph(df,report_type,column_name,comparison_type).create_plot()

    title =  "**NO TITLE**"
    return title,fig

@app.callback(
    Output("BalanceStatement_second_plot","figure"),
    Input("BalanceStatement_first_plot","hoverData"),
    Input("BalanceStatement_stock_dropdown","value"),
    Input("BalanceStatement_reporttype","value"),
)
def second_plot_balance_tab(hoverData,tickers,report_type):
    # 1. Broad safety catch for missing or empty hover data
    if not hoverData or "points" not in hoverData or not tickers:
        raise PreventUpdate
    point = hoverData["points"][0]
    custom_data = point.get("customdata")
    
    # 2. Crash protection: Exit early if customdata isn't populated yet
    if custom_data is None:
        raise PreventUpdate

    df = (balance_sheet.calc_columns(tickers,report_type,income_statement.df)
                          .astype({"fiscal_date_ending":"datetime64[ns]"}))
    
    year_str = pd.to_datetime(hoverData["points"][0]["customdata"][0]).strftime('%Y-%m-%d')
    df["date_str"] = pd.to_datetime(df["fiscal_date_ending"]).dt.strftime('%Y-%m-%d')

    new_df = (pd.DataFrame(df[df.fiscal_date_ending == year_str][["total_assets","total_shareholder_equity","total_liabilities"]].T)
                .reset_index())

    if new_df.shape[1] != 2:
        raise PreventUpdate

    new_df.columns = ["col1", "col2"]

    fig = HorizontalBarGraph(new_df).create_plot()

    return fig

@app.callback(
    Output("CashflowStatement_stock_dropdown", "multi"),
    Output("CashflowStatement_stock_dropdown", "value"),
    Output("CashflowStatement_component_dropdown", "multi"),
    Output("CashflowStatement_component_dropdown", "value"),
    Input("CashflowStatement_output_picker", "value")
)
def cashflow_tab_toggle_dropdown_modes(comparison_type):
    if comparison_type == "stock":
        # Multi-stock selection, single financial structural item
        return True, ["AAPL"], False, "operating_cashflow"
    else:
        # Single stock selection, multi structural item component layout
        return False, "AAPL", True, ["operating_cashflow", "free_cash_flow"]
    
@app.callback(
    Output("CashflowStatement_title","children"),
    Output("CashflowStatement_first_plot","figure"),
    Input("CashflowStatement_stock_dropdown","value"),
    Input("CashflowStatement_component_dropdown","value"),
    Input("CashflowStatement_graph_picker","value"),
    Input("CashflowStatement_year_picker","value"),
    Input("CashflowStatement_reporttype","value"),
    Input("CashflowStatement_output_picker","value"),
)
def first_plot_cashflow_tab(tickers,column_name,graph_type,last_x_years,report_type,comparison_type):
    if not tickers:
        raise PreventUpdate
    
    df = (cashflow.calc_columns(tickers,report_type)       
            .groupby("ticker").tail(last_x_years if report_type == "ANNUAL" else last_x_years*4))

    if graph_type == "bar":
        fig = BarGraph(df,report_type,column_name,comparison_type).create_plot()
    else:
        fig = LineGraph(df,report_type,column_name,comparison_type).create_plot()

    title =  "**NO TITLE**"
    return title,fig

@app.callback(
    Output("CashflowStatement_second_plot","figure"),
    Input("CashflowStatement_first_plot","hoverData"),
    Input("CashflowStatement_stock_dropdown","value"),
    Input("CashflowStatement_reporttype","value"),
)
def second_plot_cashflow_tab(hoverData,tickers,report_type):
    # 1. Broad safety catch for missing or empty hover data
    if not hoverData or "points" not in hoverData or not tickers:
        raise PreventUpdate
    point = hoverData["points"][0]
    custom_data = point.get("customdata")

    # 2. Crash protection: Exit early if customdata isn't populated yet
    if custom_data is None:
        raise PreventUpdate

    df = (cashflow.calc_columns(tickers,report_type)
                    .astype({"fiscal_date_ending":"datetime64[ns]"}))

    year_str = pd.to_datetime(hoverData["points"][0]["customdata"][0]).strftime('%Y-%m-%d')
    df["date_str"] = pd.to_datetime(df["fiscal_date_ending"]).dt.strftime('%Y-%m-%d')


    reduced_df = (df[df.fiscal_date_ending == year_str]
                    [["net_income","depreciation_depletion_and_amortization",
                    "stock_based_compensation","change_in_inventory",
                    "operating_cashflow"]])

    if reduced_df.empty or reduced_df.shape[0] == 0:
        raise PreventUpdate

    fig = WaterfallPlot(reduced_df).create_plot()

    return fig

if __name__ == "__main__":
    app.run(debug=True)