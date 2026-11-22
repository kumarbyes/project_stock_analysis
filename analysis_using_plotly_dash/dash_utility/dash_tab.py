from dash import Dash, dcc, html, dash_table
import dash_bootstrap_components as dbc
from dash.dependencies import Output, Input
from dash.exceptions import PreventUpdate
from dash_bootstrap_templates import load_figure_template
from .dash_elements import *

class FinanceTab:
    def __init__(self,id,label,statement,component):
        self.id = id
        self.label = label
        self.statement = statement
        self.default_component = component
    def create_tab(self):
        tab = dcc.Tab(  label=self.label,
                        children=[
                            dbc.Row([
                                        MarkdownElement(id=f"{self.label}_title").create_object()
                                    ]),
                            dbc.Row([
                                    dbc.Col([   
                                                html.P("Select your comparison type :"),

                                                RadioElement(id=f"{self.label}_output_picker").create_object(["stock","component"],"stock"),

                                                html.P("Select one or more Stocks :"),

                                                DropDownElement(id=f"{self.label}_stock_dropdown").create_object(self.statement.get_unique_ticker(),["AAPL"]),

                                                html.Br(),          

                                                html.P("Select a Column to Plot :"),

                                                DropDownElement(id=f"{self.label}_component_dropdown").create_object(self.statement.get_numeric_columns(),self.default_component),

                                                html.Br(),

                                                html.P("Select plot type :"),

                                                RadioElement(id=f"{self.label}_graph_picker").create_object(["bar","line"],"bar",inline=True),

                                                html.Br(), 

                                                html.P("Last x Years:"),

                                                RadioElement(id=f"{self.label}_year_picker").create_object([5,10,15,20],5,inline=True),

                                                html.P("Report type:"),

                                                RadioElement(id=f"{self.label}_reporttype").create_object(["ANNUAL","QUARTERLY"],"ANNUAL",inline=True),

                                        ],width=2),

                                    dbc.Col([
                                                dcc.Graph(id=f"{self.label}_first_plot")
                                        ]),
                                    dbc.Col([
                                                dcc.Graph(id=f"{self.label}_second_plot")
                                        ],width=4)

                                    ])
                        ])
        return tab