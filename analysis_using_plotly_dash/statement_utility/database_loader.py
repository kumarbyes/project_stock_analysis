from .loader import Loader
from .fin_tables import *
import pandas as pd

class DatabaseLoader(Loader):
    stock_table = Stock
    def get_data(self,table):
        stmt = (
                select(table,self.stock_table)
                .join(
                    self.stock_table, 
                    and_(
                        table.stock_id == self.stock_table.stock_id
                )))
        result = pd.read_sql(stmt, engine)
        return result