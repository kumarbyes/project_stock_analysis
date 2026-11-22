from abc import ABC, abstractmethod
from dash import Dash, dcc, html, dash_table

class DashElement(ABC):
    def __init__(self,id):
        self.id = id
    def __str__(self):
        return f"Creating an {self.id}"
    def __call__(self):
        print("Instance is called via special method")
    @abstractmethod
    def create_object(self):
         pass
    

class MarkdownElement(DashElement):
    def create_object(self):
        component = dcc.Markdown(  id=self.id,
                                        style={ 'textAlign':'center',
                                                'fontSize':30,
                                                'fontWeight':'bold',
                                                'fontFamily':'sans-serif'})
        return component

class RadioElement(DashElement):
    def create_object(self,options,value,inline=False):
        component = dcc.RadioItems( id=self.id,
                                    options = options,
                                    value= value,
                                    inline=inline)
        return component

class DropDownElement(DashElement):
    def create_object(self,options,value):
        component = dcc.Dropdown(   id=self.id,
                                    options=options,
                                    value=value)
        return component

class GraphElement(DashElement):
    def create_object(self):
        component = dcc.Graph(id=self.id)
        return component
    