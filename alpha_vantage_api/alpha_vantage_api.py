from alpha_vantage.timeseries import TimeSeries
import requests
from bs4 import BeautifulSoup
import pandas as pd
import io
import os
import time
import numpy as np

def read_api_key():
    # Gets the directory where THIS .py file actually sits
    script_dir = os.path.dirname(os.path.abspath(__file__))
    file_path = os.path.join(script_dir, "api_key.txt")
    with open(file_path) as file:
        API_key = file.read()
    API_key = API_key.strip()
    return API_key

def return_json(url):
    # replace the "demo" apikey below with your own key from https://www.alphavantage.co/support/#api-key
    url = url
    r = requests.get(url)
    data = r.json()
    return data

def query_all_statements(ticker,query_func = None):
    """
    """
    if query_func != None:
        function_names= query_func
    else:
        function_names= {   "INCOME_STATEMENT":"annualReports",
                            "BALANCE_SHEET":"annualReports",
                            "CASH_FLOW":"annualReports",
                            "OVERVIEW":"EMPTY",
                            "DIVIDENDS":"data",
                            "SPLITS":"data",
                            "SHARES_OUTSTANDING":"data",
                            "EARNINGS":"annualEarnings",
                            "EARNINGS_ESTIMATES":"estimates"
                            }

    for func in function_names:
        url = f'https://www.alphavantage.co/query?function={func}&symbol={ticker}&apikey={read_api_key()}'
        return_statement = return_json(url)

        # 1. Check for API limit or Error messages
        if "Information" in return_statement:
            print(f"⚠️ API Limit hit on {func}. Skipping...")
            time.sleep(60) # Wait a full minute if limited
            continue

        if func in ["INCOME_STATEMENT","BALANCE_SHEET","CASH_FLOW"]:
            print(f"key is {func}, value is {function_names[func]}")
            df = pd.json_normalize(return_statement.get(function_names[func]))#.set_index("fiscalDateEnding")
        elif func == "OVERVIEW":
            print(f"key is {func}, value is {function_names[func]}")
            df = pd.json_normalize(return_statement)#.set_index("Symbol")
        else:
            print(f"key is {func}, value is {function_names[func]}")
            df = pd.json_normalize(return_statement.get(function_names[func]))

        #path = f"stocks/{ticker}"

        #if not(os.path.exists(path)):
        #    os.mkdir(path)
        #df.to_csv(f"./{path}/{func}.csv")

        return df

def main():
    # Put the code you want to run here
    print("Executing main logic...")

if __name__ == "__main__":
    main()
