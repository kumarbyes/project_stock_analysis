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
bal_df_csv = pd.read_csv("./analysis_using_plotly_dash/balance_sheet.csv")

calculated_column_names = (["calc_net_income","revenue_growth","gross_margin",
                            "operating_margin","net_margin","cogs_margin",
                            "expense_margin","tax_margin"
                            ])

calculated_column_names_bal = (["current_ratio","liabilities_to_equity","return_on_equity"])

template_name = "superhero"
load_figure_template(template_name)

dbc_css = "https://cdn.jsdelivr.net/gh/AnnMarieW/dash-bootstrap-templates/dbc.min.css"

app = Dash(__name__,external_stylesheets=[dbc.themes.SUPERHERO,dbc_css],suppress_callback_exceptions=True)

app.layout = html.Div([
                        dcc.Tabs([
                            dcc.Tab(label="Income Statement",
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
                                                            html.P("Select one or more Stocks :"),
                                                            dcc.Dropdown(id="stock_selector",
                                                                        options=income_df_csv["ticker"].unique(),
                                                                        value="AAPL",
                                                                        className="dbc",
                                                                        multi=True),
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
                                                            html.P("Report type:"),
                                                            dcc.RadioItems(id="income_reporttype",
                                                                           options = ["ANNUAL","QUARTERLY"],
                                                                           value="ANNUAL",
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
                                        ]),
                            dcc.Tab(label="Balance Sheet",
                                    children=[
                                        dbc.Row([
                                            dcc.Markdown(id="bal_markdown_title",
                                                         style={'textAlign':'center',
                                                                'fontSize':30,
                                                                'fontWeight':'bold',
                                                                'fontFamily':'sans-serif'})
                                                ]),
                                        dbc.Row([
                                                dbc.Col([
                                                            html.P("Select your comparison type :"),
                                                            dcc.RadioItems(id="tab2_OutputPicker",
                                                                           options = ["stock","component"],
                                                                           value="stock"),
                                                            html.Br(), 
                                                            html.P("Select a Stock :"),
                                                            dcc.Dropdown(id="tab2_stock_dropdown",
                                                                        options=bal_df_csv["ticker"].unique()),
                                                            html.Br(),          
                                                            html.P("Select a Component to Plot :"),
                                                            dcc.Dropdown(id="tab2_comp_dropdown",
                                                                         options=list(bal_df_csv.select_dtypes(include='number').columns[1:-1]) + calculated_column_names_bal),
                                                            html.Br(), 
                                                            html.P("Select plot type :"),
                                                            dcc.RadioItems(id="bal_graph_picker",
                                                                           options = ["bar","line"],
                                                                           value="bar",
                                                                           inline=True),
                                                            html.Br(), 
                                                            html.P("Last x Years:"),
                                                            dcc.RadioItems(id="bal_year_picker",
                                                                           options = [5,10,15,20],
                                                                           value=5,
                                                                           inline=True),
                                                    ],width=2),
                                                dbc.Col([
                                                            dcc.Graph(id="bal_first_plot")
                                                    ]),
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
    Input("income_reporttype","value"),
)
def plot_tab1(tickers,column_name,graph_type,last_x_years,report_type):
    if not tickers:
        raise PreventUpdate
    
    df = income_df_csv.query(f"report_type == '{report_type}' and ticker in @tickers")
    df = (df
        #.iloc[:last_x_years]
        .assign(calc_net_income = lambda x: x["operating_income"] - x["income_tax_expense"],
                #revenue_growth = lambda x: (x["total_revenue"] - x["total_revenue"].shift(-1))/x["total_revenue"].shift(-1)*100,
                revenue_growth = lambda x: (x["total_revenue"] - x.groupby("ticker")["total_revenue"].shift(-1)) 
                                            / x.groupby("ticker")["total_revenue"].shift(-1) * 100,
                gross_margin = lambda x: x["gross_profit"]/x["total_revenue"] * 100,
                operating_margin = lambda x: x["ebit"]/x["total_revenue"] * 100,
                net_margin = lambda x: (x["operating_income"] - x["income_tax_expense"])/x["total_revenue"] * 100,
                cogs_margin = lambda x: x["cost_of_revenue"]/x["total_revenue"] * 100,
                expense_margin = lambda x: x["operating_expenses"]/x["total_revenue"] * 100,
                tax_margin = lambda x: x["income_tax_expense"]/x["total_revenue"] * 100,
                year_str = lambda x: pd.to_datetime(x["fiscal_date_ending"]).dt.year.astype(str)
                )
        .groupby("ticker").head(last_x_years)
        .sort_values(by="fiscal_date_ending")
    )

    #df = df.sort_values("year_str")

    blues = ['#F0F8FF', '#D0E1FD', '#A2C2FC', '#6395ED', '#2A52BE', '#1D2951']

    if graph_type == "bar":
        fig = px.bar(df,
                    x= "year_str" if report_type == "ANNUAL" else "fiscal_date_ending",
                    y=column_name,
                    color="ticker",
                    title= f"{column_name} over the years",
                    hover_name = "fiscal_date_ending",
                    custom_data = ["fiscal_date_ending"],
                    barmode='group',
                    color_discrete_sequence=blues,
                    )

        fig.update_xaxes(
            type="category", 
            tickmode="auto",
            range=None
        )
    else:
        fig = px.line(df, 
                    x='fiscal_date_ending',
                    y=column_name,
                    markers=True,
                    custom_data = ["fiscal_date_ending"],
                    color="ticker",
                    color_discrete_sequence=blues)

        dates = pd.to_datetime(df["fiscal_date_ending"])   
        unique_years = sorted(dates.dt.year.unique())
        clean_ticks = [f"{yr}-01-01" for yr in unique_years]
        fig.update_xaxes(type="date",
                        tickmode="array",
                        tickvals=clean_ticks,
                        tickformat="%Y",
                        range=[dates.min() - pd.DateOffset(months=6), dates.max() + pd.DateOffset(months=6)])

    fig.update_layout(
        template=template_name,
        xaxis_title="Fiscal Year",
        #yaxis_title=column_name.replace("_", " ").title(),
        bargap=0.2,
        bargroupgap=0.05,
        margin=dict(l=40, r=40, t=60, b=40)
    )

    title =  "**NO TITLE**"
    return title,fig

@app.callback(
    Output("second_plot","figure"),
    Output("debug_md","children"),
    Input("first_plot","hoverData"),
    Input("stock_selector","value"),
    Input("income_reporttype","value"),
)
def plot_tab11(hoverData,tickers,report_type):
    # 1. Broad safety catch for missing or empty hover data
    if not hoverData or "points" not in hoverData or not tickers:
        raise PreventUpdate
    point = hoverData["points"][0]
    custom_data = point.get("customdata")
    
    # 2. Crash protection: Exit early if customdata isn't populated yet
    if custom_data is None:
        raise PreventUpdate
      
    df = income_df_csv.query(f"report_type == '{report_type}' and ticker in @tickers")
    df = (df
        .assign(calc_net_income = lambda x: x["operating_income"] - x["income_tax_expense"],
                revenue_growth = lambda x: (x["total_revenue"] - x.groupby("ticker")["total_revenue"].shift(-1)) 
                                            / x.groupby("ticker")["total_revenue"].shift(-1) * 100,
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
                pd.DataFrame(df[df.fiscal_date_ending == year][["cost_of_revenue","operating_expenses","income_tax_expense","calc_net_income"]].T)
                .reset_index()
            )

    if plot_df.shape[1] != 2:
        raise PreventUpdate
    
    plot_df.columns = ["col1", "col2"]
    #plot_df.sort_values(by="col2",inplace=True,ascending=False)
    fig = px.pie(plot_df, values="col2", names="col1", color = "col1",title='Revenue Composition',hole=0.25,
                              color_discrete_map={  'cost_of_revenue':'navyblue',
                                                    'operating_expenses':'cyan',
                                                    'income_tax_expense':'royalblue',
                                                    'calc_net_income':'darkblue'})
    fig.update_traces(sort=False, selector=dict(type='pie'),direction="clockwise")

    return fig,f"selected fiscal year is {year}"

@app.callback(
    Output("tab2_stock_dropdown", "multi"),
    Output("tab2_stock_dropdown", "value"),
    Output("tab2_comp_dropdown", "multi"),
    Output("tab2_comp_dropdown", "value"),
    Input("tab2_OutputPicker", "value")
)
def toggle_dropdown_modes(comparison_type):
    if comparison_type == "stock":
        # Multi-stock selection, single financial structural item
        return True, ["AAPL"], False, "total_current_assets"
    else:
        # Single stock selection, multi structural item component layout
        return False, "AAPL", True, ["total_current_assets", "total_current_liabilities"]


@app.callback(
    Output("bal_markdown_title","children"),
    Output("bal_first_plot","figure"),
    Input("tab2_stock_dropdown","value"),
    Input("tab2_comp_dropdown","value"),
    Input("bal_graph_picker","value"),
    Input("bal_year_picker","value"),
    Input("tab2_OutputPicker","value"),
)
def plot_tab2(tickers,column_name,graph_type,last_x_years,comparison_type):
    if not tickers or not column_name or not graph_type or not last_x_years or not comparison_type:
        raise PreventUpdate
    
    df = bal_df_csv.query(f"report_type == 'ANNUAL' and ticker in @tickers")
    df = (df
            .assign(current_ratio = lambda x: x["total_current_assets"]/x["total_current_liabilities"],
                    liabilities_to_equity = lambda x: x["total_liabilities"]/x["total_shareholder_equity"],
                    return_on_equity = lambda x: income_df_csv["net_income"]/x["total_shareholder_equity"] *100,
                    year_str = lambda x: pd.to_datetime(x["fiscal_date_ending"]).dt.year.astype(str)
                    )  
            .groupby("ticker").head(last_x_years)
    )

    df = df.sort_values("year_str")

    blues = ['#D6E4FF', '#A9C7FF', '#7DA6FF', '#4A7FFF', '#1D4ED8', '#1E3A8A']

    if graph_type == "bar":
        fig = px.bar(df,
                    x="fiscal_date_ending",
                    y=column_name,
                    color= "ticker" if comparison_type == "stock" else None,
                    title= f"{" ".join(column_name).upper().replace("_"," ")} over the years" if comparison_type == "stock" else f"{", ".join(column_name).upper().replace("_"," ")} over the years" ,
                    hover_name = "fiscal_date_ending",
                    custom_data = ["fiscal_date_ending"],
                    barmode='group',
                    color_discrete_sequence=blues,
                    )

        fig.update_xaxes(
            type="category", 
            tickmode="auto",
            range=None
        )
    else:
        fig = px.line(df, 
                    x='fiscal_date_ending',
                    y=column_name,
                    #markers=True,
                    custom_data = ["fiscal_date_ending"],
                    color="ticker" if comparison_type == "stock" else None,
                    color_discrete_sequence=blues)

        dates = pd.to_datetime(df["fiscal_date_ending"])   
        unique_years = sorted(dates.dt.year.unique())
        clean_ticks = [f"{yr}-01-01" for yr in unique_years]
        fig.update_xaxes(type="date",
                        tickmode="array",
                        tickvals=clean_ticks,
                        tickformat="%Y",
                        range=[dates.min() - pd.DateOffset(months=6), dates.max() + pd.DateOffset(months=6)])

    fig.update_layout(
        template=template_name,
        xaxis_title="Fiscal Year",
        #yaxis_title=column_name.replace("_", " ").title(),
        bargap=0.2,
        bargroupgap=0.05,
        margin=dict(l=40, r=40, t=60, b=40)
    )

    title =  "**NO TITLE**"
    return title,fig

if __name__ == "__main__":
    app.run(debug=True)