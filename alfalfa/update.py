import pandas as pd
import requests
from requests import get
import os
import shutil
from datetime import datetime, timedelta

#data_source = "archive/Alfalfa-California-Weekly.xls"
data_source = "/home/alex/OneDrive/Dario/ALFALFA/Alfalfa-California-Weekly.xlsx"

def update():
    return None

alfalfa_types = {"SUPREME", "PREMIUM", "GOOD", "FAIR"}
for alfalfa_type in alfalfa_types:
    alfalfa_df = pd.read_csv("csvs/alfalfa_" + alfalfa_type.lower() + ".csv")
    latest_row = pd.DataFrame(pd.read_excel(data_source, sheet_name=alfalfa_type, skiprows=3).iloc[-1]).transpose()
    latest_row["DATE"] = latest_row["DATE"].dt.strftime("%m/%d/%Y")
    latest_row = latest_row.rename(columns={"VOLUME": "VOL"})
    alfalfa_df = pd.concat([alfalfa_df, latest_row]).drop_duplicates(subset=["DATE"], keep="last")
    alfalfa_df.to_csv("csvs/alfalfa_" + alfalfa_type.lower() + ".csv", index=False)
    #print("I just finished generating the alfalfa file for " + alfalfa_type)
    #print("Now, I'm going to generate the aggregate file for alfalfa.")
    #alfalfa_agg_df = pd.read_csv("csvs/alfalfa_Aggregate.csv")
    #latest_agg_row = pd.DataFrame(alfalfa_agg_df.iloc[-1]).transpose()
    shutil.copy("csvs/alfalfa_" + alfalfa_type.lower() + ".csv", "/home/alex/OneDrive/prices/feed/US/CA/forage/hay/alfalfa/")

shutil.copy(str(os.getcwd()) + "/update.py", "/home/alex/OneDrive/scripts/alfalfa_script.py")
