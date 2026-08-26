from dash import Dash, dcc, html, dash_table
import dash_bootstrap_components as dbc
from dash.dependencies import Output, Input
from dash.exceptions import PreventUpdate
from dash_bootstrap_templates import load_figure_template

import plotly.express as px
import pandas as pd
import numpy as np

import urllib.parse

income_df_csv = pd.read_csv("./analysis_using_plotly_dash/income_statements.csv")

calculated_column_names = (["calc_net_income","revenue_growth","gross_margin",
                            "operating_margin","net_margin","cogs_margin",
                            "expense_margin","tax_margin"
                            ])

load_figure_template("morph")

dbc_css = "https://cdn.jsdelivr.net/gh/AnnMarieW/dash-bootstrap-templates/dbc.min.css"

app = Dash(__name__,external_stylesheets=[dbc.themes.MORPH,dbc_css])

app.layout = html.Div([
                        dcc.Tabs([
                            dcc.Tab(label="Financial Statements",
                                    children=[
                                        dbc.Row([
                                            dcc.Markdown(id="markdown_title",
                                                         style={'textAlign':'center',
                                                                'fontSize':30,
                                                                'fontWeight':'bold',
                                                                'fontFamily':'sans-serif'})
                                                ]),
                                        dbc.Row([
                                                dbc.Col([
                                                            html.P("Select a Stock :"),
                                                            dcc.Dropdown(id="stock_selector",
                                                                        options=income_df_csv["ticker"].unique(),
                                                                        value="AAPL",
                                                                        className="dbc"),
                                                            html.Br(),          
                                                            html.P("Select a Column to Plot :"),
                                                            dcc.Dropdown(id="income_column_selector",
                                                                        options=list(income_df_csv.select_dtypes(include='number').columns[1:-1]) + calculated_column_names,
                                                                        value="total_revenue",
                                                                        className="dbc"),
                                                            html.Br(), 
                                                            html.P("Select plot type :"),
                                                            dcc.RadioItems(id="graph_picker",
                                                                           options = ["bar","line"],
                                                                           value="bar",
                                                                           inline=True),
                                                            html.Br(), 
                                                            html.P("Last x Years:"),
                                                            dcc.RadioItems(id="year_picker",
                                                                           options = [5,10,15,20],
                                                                           value=5,
                                                                           inline=True),
                                                    ],width=2),
                                                dbc.Col([
                                                            dcc.Graph(id="first_plot")#html.Div(id="first_plot")#
                                                    ]),
                                                dbc.Col([
                                                            dcc.Markdown(id="debug_md"),
                                                            dcc.Graph(id="second_plot")
                                                    ],width=4)
                                                ])
                                        ])
                                    ])
                    ],className="dbc")

@app.callback(
    Output("markdown_title","children"),
    Output("first_plot","figure"),#Output("first_plot","children")
    Input("stock_selector","value"),
    Input("income_column_selector","value"),
    Input("graph_picker","value"),
    Input("year_picker","value"),
)
def plot_tab1(ticker,column_name,graph_type,last_x_years):
    if not ticker:
        raise PreventUpdate
    
    df = income_df_csv.query(f"report_type == 'ANNUAL' and ticker == '{ticker}'")
    df = (df
        .iloc[:last_x_years]
        .assign(calc_net_income = lambda x: x["operating_income"] - x["income_tax_expense"],
                revenue_growth = lambda x: (x["total_revenue"] - x["total_revenue"].shift(-1))/x["total_revenue"].shift(-1)*100,
                gross_margin = lambda x: x["gross_profit"]/x["total_revenue"] * 100,
                operating_margin = lambda x: x["ebit"]/x["total_revenue"] * 100,
                net_margin = lambda x: (x["operating_income"] - x["income_tax_expense"])/x["total_revenue"] * 100,
                cogs_margin = lambda x: x["cost_of_revenue"]/x["total_revenue"] * 100,
                expense_margin = lambda x: x["operating_expenses"]/x["total_revenue"] * 100,
                tax_margin = lambda x: x["income_tax_expense"]/x["total_revenue"] * 100
                )
    )

    if graph_type == "bar":
        fig = px.bar(df,
                    x="fiscal_date_ending",
                    y=column_name,
                    title= f"{column_name.upper()} over the years",
                    hover_name = "fiscal_date_ending",
                    custom_data = ["fiscal_date_ending"])
    else:
        fig = px.line(df, 
                    x='fiscal_date_ending',
                    y=column_name,
                    markers=True,
                    custom_data = ["fiscal_date_ending"])

    dates = pd.to_datetime(df["fiscal_date_ending"])
    fig.update_xaxes(type="date",
                     tickmode="array",
                     tickvals=df["fiscal_date_ending"],
                     tickformat="%Y",
                     range=[dates.min() - pd.DateOffset(months=6), dates.max() + pd.DateOffset(months=6)])
    
    title =  f"Income Statement Plot of {ticker}"
    return title,fig

@app.callback(
    Output("second_plot","figure"),
    Output("debug_md","children"),
    Input("first_plot","hoverData"),
    Input("stock_selector","value")
)
def plot_tab11(hoverData,ticker):
    # 1. Broad safety catch for missing or empty hover data
    if not hoverData or "points" not in hoverData or not ticker:
        raise PreventUpdate
    point = hoverData["points"][0]
    custom_data = point.get("customdata")
    
    # 2. Crash protection: Exit early if customdata isn't populated yet
    if custom_data is None:
        raise PreventUpdate
      
    df = income_df_csv.query(f"report_type == 'ANNUAL' and ticker == '{ticker}'")
    df = (df
        .assign(calc_net_income = lambda x: x["operating_income"] - x["income_tax_expense"],
                revenue_growth = lambda x: (x["total_revenue"] - x["total_revenue"].shift(-1))/x["total_revenue"].shift(-1)*100,
                gross_margin = lambda x: x["gross_profit"]/x["total_revenue"] * 100,
                operating_margin = lambda x: x["ebit"]/x["total_revenue"] * 100,
                net_margin = lambda x: (x["operating_income"] - x["income_tax_expense"])/x["total_revenue"] * 100,
                cogs_margin = lambda x: x["cost_of_revenue"]/x["total_revenue"] * 100,
                expense_margin = lambda x: x["operating_expenses"]/x["total_revenue"] * 100,
                tax_margin = lambda x: x["income_tax_expense"]/x["total_revenue"] * 100
                )
        .astype({"fiscal_date_ending":"datetime64[ns]"})
        )
    year = pd.to_datetime(hoverData["points"][0]["customdata"][0])
    plot_df = (
                pd.DataFrame(df[df.fiscal_date_ending == year][["calc_net_income","income_tax_expense","operating_expenses","cost_of_revenue"]].T)
                .reset_index()
            )

    if plot_df.shape[1] != 2:
        raise PreventUpdate
    
    plot_df.columns = ["col1", "col2"]
    plot_df.sort_values(by="col2",inplace=True,ascending=False)
    fig = px.pie(plot_df, values="col2", names="col1", color = "col1",title='Revenue Composition',hole=0.25,
                              color_discrete_map={  'cost_of_revenue':'navyblue',
                                                    'operating_expenses':'cyan',
                                                    'income_tax_expense':'royalblue',
                                                    'calc_net_income':'darkblue'})
    return fig,f"selected fiscal year is {year}"

if __name__ == "__main__":
    app.run(debug=True)