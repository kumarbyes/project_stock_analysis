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
    Fetches and normalizes financial statement data from the Alpha Vantage API.

    Loops through a provided dictionary of Alpha Vantage API functions, sends HTTP 
    requests for the specified ticker, handles standard API rate limits by pausing 
    execution, and flattens the resulting JSON data into a pandas DataFrame.

    Args:
        ticker (str): The stock symbol to query (e.g., 'AAPL', 'MSFT').
        query_func (dict, optional): A dictionary where keys are Alpha Vantage 
            API function strings (e.g., 'INCOME_STATEMENT', 'OVERVIEW') and values 
            are the expected JSON data keys to extract. Defaults to None.

    Returns:
        pandas.DataFrame: A normalized DataFrame containing the data from the 
        final API function processed in the loop. Returns None if query_func is None.
    """
    if query_func != None:
        function_names = query_func
    else:
        return

    key, value = next(iter(function_names.items()))

    for func in function_names:
        url = f'https://www.alphavantage.co/query?function={func}&symbol={ticker}&apikey={read_api_key()}'
        return_statement = return_json(url)

        # 1. Check for API limit or Error messages
        if "Information" in return_statement:
            print(f"⚠️ API Limit hit on {func}. Skipping...")
            time.sleep(60) # Wait a full minute if limited
            continue

        if func in ["INCOME_STATEMENT","BALANCE_SHEET","CASH_FLOW"]:
            print(f"key is {func}")#, value is {function_names[func]}")
            df = pd.json_normalize(return_statement)#.get(function_names[func]))#.set_index("fiscalDateEnding")
        elif func == "OVERVIEW":
            print(f"key is {func}, value is {function_names[func]}")
            df = pd.json_normalize(return_statement)#.set_index("Symbol")
        else:
            print(f"key is {func}, value is {function_names[func]}")
            df = pd.json_normalize(return_statement.get(function_names[func]))

    return df

def main():
    # Put the code you want to run here
    print("Executing main logic...")

if __name__ == "__main__":
    main()
