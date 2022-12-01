import pandas as pd
import numpy as np
import sys
import shutil

def main():
    name = "alfalfa"
    csvs = [name + "_" + i + ".csv" for i in ["supreme", "premium", "good", "fair"]]
    num_of_csvs = len(csvs)
    first_csv_df = pd.read_csv(csvs[0])
    days = len(first_csv_df.index)
    dates = first_csv_df["DATE"]
    aggregate = np.matrix([[0.0, 0.0, 0.0, 0.0, 0.0, 0.0] for i in range(days)])
    for csv in csvs:
        print("I'm all prepared and adding this CSV to the aggregate!")
        print(csv)
        csv_df = pd.read_csv(csv)
        aggregate += pd.read_csv(csv).drop(["DATE"], axis=1).to_numpy()
    aggregate /= np.matrix([[num_of_csvs, num_of_csvs, num_of_csvs, num_of_csvs, 1.0, 1.0] for i in range(days)])
    aggregate_df = pd.DataFrame(aggregate, columns=["OPEN", "HIGH", "LOW", "CLOSE", "VOL", "OI"])
    aggregate_df.insert(loc=0, column="DATE", value=dates.tolist())
    aggregate_df["OI"] /= aggregate_df["OI"]
    aggregate_df[["OPEN", "HIGH", "LOW", "CLOSE", "VOL"]] = aggregate_df[["OPEN", "HIGH", "LOW", "CLOSE", "VOL"]].round(decimals=2)
    for col in ["OPEN", "HIGH", "LOW", "CLOSE", "VOL"]:
        aggregate_df[col] = aggregate_df[col].map("{:.2f}".format)
    aggregate_df[["OI"]] = aggregate_df[["OI"]].astype("int64")
    #aggregate_df.to_csv(name + "_Aggregate_generated.csv", index=False)
    aggregate_df.to_csv(name + "_Aggregate.csv", index=False)
    shutil.copy("csvs/alfalfa_Aggregate.csv", "/home/alex/OneDrive/prices/feed/US/CA/forage/hay/alfalfa/")

main()
