# Data Cleansing Process for Australia Bond Yield Data
# Import all packages
import pandas as pd
import glob
import os 
import re

# Folder Path for Australia
folder_path = r"D:\Important Documents\Economic Data\World Government Bonds Rates Data\Australia"

# Obtain All .csv Data
csv_files = glob.glob(os.path.join(folder_path, "*.csv"))

# ISO Code information for Australia
iso_code = "AUS"
iso_number = "036"

# Initialize data frame lists
data_frames = []

# Perform looping process for all files within code
for file in csv_files:
    data_frame = pd.read_csv(file) # Read CSV File
    data_frame = data_frame.loc[:, ~data_frame.columns.str.contains("Change", case = False)] # Drop "Change %" column if it exists
    rename_dict = {
        "Price": "BondPrice",
        "Open": "YieldOpen",
        "High": "YieldHigh",
        "Low": "YieldLow",
        "Date": "DatePeriod" 
    } # Rename columns for consistency
    data_frame.rename(columns = rename_dict, inplace = True)
    data_frame["DatePeriod"] = pd.to_datetime(data_frame["DatePeriod"], 
    format = "%m/%d/%Y", errors = "coerce").dt.strftime("%Y-%m-%d") # Convert Date column to YYYY-MM-DD
    filename = os.path.basename(file)
    match = re.search(r"(\d+)-(Month|Year)", filename, re.IGNORECASE)
    if match:
        num = match.group(1)
        unit = match.group(2).lower()
        yield_maturity = f"{num}{'M' if unit.startswith('month') else 'Y'}"
    else:
        yield_maturity = "Unknown" # Extract Yield Maturity info
    # Add ID and Maturity Time Columns
    data_frame["ID"] = f"{iso_code}{iso_number}-GBY{yield_maturity}"
    data_frame["BondMaturity"] = yield_maturity

    data_frames.append(data_frame)

# Combine all Extracted .csv Files
merged_dataframe = pd.concat(data_frames, ignore_index = True)

# Reorder columns
columns_order = ["ID", "BondMaturity", "DatePeriod", "BondPrice", "YieldOpen", "YieldHigh", "YieldLow"]
merged_dataframe = merged_dataframe[columns_order]

# Sort by Bond Maturity Time (numerically) and Date
def maturity_sort_key(m):
    if "M" in m:
        return int(m.replace("M", ""))
    elif "Y" in m:
        return int(m.replace("Y", ""))
    else:
        return 999 #Unknown maturities go last

merged_dataframe["SortKey"] = merged_dataframe["BondMaturity"].apply(maturity_sort_key)

merged_dataframe = (
    merged_dataframe.sort_values(by = ["SortKey", "DatePeriod"])
    .drop(columns = "SortKey").reset_index(drop = True)
)

# Save all processes into excel file and determined path
output_path = os.path.join("D:\Important Documents\Economic Data\World Government Bonds Rates Data\Australia", "Australia Bond Yields.xlsx")
merged_dataframe.to_excel(output_path, index = False, sheet_name = "Data")

print(f"All processes have completed, the cleansed dataset is available as Excel file:\n{output_path}")