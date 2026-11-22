from abc import ABC, abstractmethod
import numpy as np
import plotly.express as px
import pandas as pd
import plotly.graph_objects as go

class PlotlyGraph(ABC):
    template_name = "superhero"
    blues = ['#F0F8FF', '#D0E1FD', '#A2C2FC', '#6395ED', '#2A52BE', '#1D2951']
    def __init__(self,df,report_type,column_name,comparison_type):
        self.df = df
        self.report_type = report_type
        self.column_name = column_name
        self.comparison_type = comparison_type
    
    @abstractmethod
    def create_plot(self):
         pass

class BarGraph(PlotlyGraph):
    def __init__(self,df,report_type,column_name,comparison_type):
        super().__init__(df,report_type,column_name,comparison_type)

    def create_plot(self):
        fig = px.bar(   self.df,
                        x= "year_str" if self.report_type == "ANNUAL" else "fiscal_date_ending",
                        y= self.column_name,
                        color="ticker" if self.comparison_type == "stock" else None,
                        title= f"{" ".join(self.column_name).upper().replace("_"," ")} over the years" if self.comparison_type == "stock" else f"{", ".join(self.column_name).upper().replace("_"," ")} over the years" ,
                        hover_name = "fiscal_date_ending",
                        custom_data = ["fiscal_date_ending"],
                        barmode='group',
                        color_discrete_sequence=self.blues)

        fig.update_xaxes(   type="category", 
                            tickmode="auto",
                            range=None)
        return fig

class LineGraph(PlotlyGraph):
    def __init__(self,df,report_type,column_name,comparison_type):
        super().__init__(df,report_type,column_name,comparison_type)

    def create_plot(self):
        fig = px.line(  self.df, 
                        x="year_str" if self.report_type == "ANNUAL" else "fiscal_date_ending",
                        y= self.column_name,
                        markers=True,
                        title= f"{" ".join(self.column_name).upper().replace("_"," ")} over the years" if self.comparison_type == "stock" else f"{", ".join(self.column_name).upper().replace("_"," ")} over the years" ,
                        custom_data = ["fiscal_date_ending"],
                        color="ticker",
                        color_discrete_sequence=self.blues)

        dates = pd.to_datetime(self.df["fiscal_date_ending"])   
        unique_years = sorted(dates.dt.year.unique())
        clean_ticks = [f"{yr}-01-01" for yr in unique_years]
        fig.update_xaxes(   type="date",
                            tickmode="array",
                            tickvals=clean_ticks,
                            tickformat="%Y",
                            range=[dates.min() - pd.DateOffset(months=6), dates.max() + pd.DateOffset(months=6)])

        fig.update_layout(  template=self.template_name,
                            xaxis_title="Fiscal Year",
                            bargap=0.2,
                            bargroupgap=0.05,
                            margin=dict(l=40, r=40, t=60, b=40))
        return fig
    
class PieGraph(PlotlyGraph):
    def __init__(self,df):
        self.df = df

    def create_plot(self,color_discrete_map,title):
        fig = px.pie(self.df, values="col2", names="col1", color = "col1",title=title,hole=0.25,
                              color_discrete_map=color_discrete_map)
        fig.update_traces(sort=False, selector=dict(type='pie'),direction="clockwise")
        return fig 

class HorizontalBarGraph(PlotlyGraph):
    def __init__(self,df):
        self.df = df

    def create_plot(self):
        assets_val = self.df.loc[self.df["col1"] == "total_assets", "col2"].values[0]
        equity_val = self.df.loc[self.df["col1"] == "total_shareholder_equity", "col2"].values[0]
        liabilities_val = self.df.loc[self.df["col1"] == "total_liabilities", "col2"].values[0]
    
        fig = go.Figure()
    
        fig.add_trace(
            go.Bar(
                y=["Assets", "Liabilities & Equity"],
                x=[assets_val, 0],
                name="Total Assets",
                orientation="h",
                marker=dict(color="#7DA6FF"),
                hovertemplate="Total Assets: %{x:,.0f}<extra></extra>",
            )
        )
    
        fig.add_trace(
            go.Bar(
                y=["Assets", "Liabilities & Equity"],
                x=[0, liabilities_val],
                name="Total Liabilities",
                orientation="h",
                marker=dict(color="#A9C7FF"),
                hovertemplate="Total Liabilities: %{x:,.0f}<extra></extra>",
            )
        )
    
        fig.add_trace(
            go.Bar(
                y=["Assets", "Liabilities & Equity"],
                x=[0, equity_val],
                name="Total Shareholder Equity",
                orientation="h",
                marker=dict(color="#D6E4FF"),
                hovertemplate="Total Equity: %{x:,.0f}<extra></extra>",
            )
        )
    
        fig.update_layout(
            barmode="stack",
            title="Balance Sheet Tally Verification",
            xaxis_title="USD",
            yaxis_title="",
            showlegend=False
        )
        return fig

class WaterfallPlot(PlotlyGraph):
    def __init__(self,df):
        self.df = df

    def create_plot(self):
        values = np.array(self.df,dtype=float)[0]

        highest_val = np.nanmax(values)
        denom = 1.0
        if highest_val >= 1000000000:
            denom = 1000000000
        elif highest_val >= 1000000:
            denom = 1000000

        fig = go.Figure(go.Waterfall(
                                    name = "cashflow", orientation = "v",
                                    measure = ["relative", "relative", "relative", "relative","relative" if values[4] > 0 else "total"],
                                    x = ["net_income", "depreciation_depletion_and_amortization", "stock_based_compensation", "change_in_inventory","operating_cashflow"],
                                    textposition = "outside",
                                    text = [values[0]/denom,values[1]/denom, 
                                            values[2]/denom, values[3]/denom, values[4]/denom],
                                    y = [values[0],values[1], 
                                            values[2], values[3],-values[4] if values[4] > 0 else values[4]],
                                    connector = {"line":{"color":"rgb(63, 63, 63)"}},
                                    hoverinfo="skip"
                                    ))

        fig.update_layout(title = "Waterfall Chart from net income to operating Cashflow")

        sum_first_four_values = sum(list(filter(lambda values: values > 0, values[:3])))
        operating_cf = values[4]
        total = sum_first_four_values - operating_cf
        fig.update_yaxes(
            range=[-operating_cf*0.3 if total < 0 else -operating_cf*0.2,sum_first_four_values+sum_first_four_values*0.4]
        )

        return fig
