from .loader import Loader
import pandas as pd
from pathlib import Path

cwd = Path(__file__).parent.parent

class CSVLoader(Loader):
    stock_csvname = cwd / 'data' / 'stock.csv'
    def get_data(self,csvname):
        result = pd.read_csv(csvname)
        stock = pd.read_csv(self.stock_csvname)
        merge_result = pd.merge(result,stock,on = "stock_id",how ="inner")
        return merge_result