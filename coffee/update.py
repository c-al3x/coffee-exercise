import pandas as pd
import requests
from requests import get
import os
import shutil
from datetime import datetime, timedelta                                                                         
def update():
    return None

response = get("https://www.theice.com/marketdata/publicdocs/futures_us_reports/coffee/coffee_cert_stock_" + f"{datetime.now():%Y%m%d}" + ".xls")
open("latest_coffee_cert_stock.xls", "wb").write(response.content) 
coffee_df = pd.read_excel("latest_coffee_cert_stock.xls", skiprows=4).set_index("Unnamed: 0")                    
latest_total = coffee_df.loc["Total in Bags", "Total"] 
cols = ["DATE", "OPEN", "HIGH", "LOW", "CLOSE", "VOL", "OI"]
latest_row = pd.DataFrame(columns=cols, data=[[f"{datetime.now():%m/%d/%Y}"] + ([latest_total] * 4) + [1, 1]])
coffee_ice_cert_stocks_df = pd.read_csv("csvs/coffee_ice_cert_stocks.csv")
coffee_ice_cert_stocks_df = pd.concat([coffee_ice_cert_stocks_df, latest_row])
coffee_ice_cert_stocks_df[["OPEN", "HIGH", "LOW", "CLOSE"]] = coffee_ice_cert_stocks_df[["OPEN", "HIGH", "LOW", "CLOSE"]].astype("int64")
coffee_ice_cert_stocks_df = coffee_ice_cert_stocks_df.drop_duplicates(subset=["DATE"], keep="last")
coffee_ice_cert_stocks_df.to_csv("csvs/coffee_ice_cert_stocks.csv", index=False)
os.remove("latest_coffee_cert_stock.xls")
shutil.copy(str(os.getcwd()) + "/csvs/coffee_ice_cert_stocks.csv", "/home/alex/OneDrive/fundamental_data/coffee/US/ice_certified_stocks/coffee_ice_cert_stocks.csv")
shutil.copy(str(os.getcwd()) + "/update.py", "/home/alex/OneDrive/scripts/coffee_script.py")
