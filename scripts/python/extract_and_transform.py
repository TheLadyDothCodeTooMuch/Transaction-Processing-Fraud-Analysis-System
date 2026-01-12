import pandas as pd

# all columns
REQUIRED_COLUMNS = [
    "Customer_ID",
    "Customer_Name",
    "Gender",
    "Age",
    "State",
    "City",
    "Bank_Branch",
    "Account_Type",
    "Transaction_ID",
    "Transaction_Date",
    "Transaction_Time",
    "Transaction_Amount",
    "Merchant_ID",
    "Transaction_Type",
    "Merchant_Category",
    "Account_Balance",
    "Transaction_Device",
    "Transaction_Location",
    "Device_Type",
    "Is_Fraud",
    "Transaction_Currency",
    "Customer_Contact",
    "Transaction_Description",
    "Customer_Email",
]

# all columns that contain qualitative context
DESCRIPTIVE_COLUMNS = [
    "Customer_Name",
    "Gender",
    "State",
    "City",
    "Bank_Branch",
    "Account_Type",
    "Merchant_Category",
    "Transaction_Device",
    "Device_Type",
    "Transaction_Description",
    "Customer_Email",
]

ID_COLUMNS = ["Customer_ID", "Transaction_ID", "Merchant_ID"]

KEY_COLUMNS = [
    "Transaction_Date",
    "Transaction_Time",
    "Transaction_Amount",
    "Account_Balance",
    "Is_Fraud",
    "Transaction_Currency",
]


def main():
    df = extract("Bank_Transaction_Fraud_Detection.csv")
    invalid_df, valid_df = all_checks(df)


def extract(csv_file):
    return pd.read_csv(csv_file)


def all_checks(df):
    check_missing_column(df)
    df = check_nulls_key_columns(df)
    df = remove_whitespace_from_descriptive_columns(df)
    df = replace_blanks(df)
    df = change_datetime(df)
    invalid_df, valid_df = split_valid_and_invalid(df)
    return invalid_df, valid_df


def check_missing_column(df):
    # Returns items that are in the first set but NOT in the second
    missing_column = set(REQUIRED_COLUMNS) - set(df.columns)

    if missing_column:
        raise ValueError(f"This column is missing: {missing_column}")


def check_nulls_key_columns(df):
    # identifies and prints all important columns which have null values
    problem_columns = []
    for column in ID_COLUMNS + KEY_COLUMNS:
        if df[column].isnull().any():
            problem_columns.append(column)

    if len(problem_columns) > 0:
        raise ValueError(f"Null columms were found: {problem_columns}")
    else:
        return df


def remove_whitespace_from_descriptive_columns(df):
    # creates a copy of the current dataframe to avoid accidental modification
    df = df.copy()
    change_types = lambda col: col.str.strip().str.title()
    # use the apply method to loop through each column specified, as each column is a series
    df[DESCRIPTIVE_COLUMNS] = df[DESCRIPTIVE_COLUMNS].astype(str).apply(change_types)
    return df


def replace_blanks(df):
    df = df.copy()
    # converts all N/A or null values in each of the columns to the specified values
    df["Gender"] = df["Gender"].fillna("UNKNOWN")
    df["Merchant_Category"] = df["Merchant_Category"].fillna("UNCLASSIFIED")
    df["Transaction_Description"] = df["Transaction_Description"].fillna("UNKNOWN")
    return df


def change_datetime(df):
    # merges both time period columns into a singular datetime column
    df["Transaction_Datetime"] = pd.to_datetime(
        df["Transaction_Date"] + " " + df["Transaction_Time"], errors="coerce", dayfirst=True
    )
    # changes the original date column to an SQL friendly column (replaces '/' with '-')
    df["Transaction_Date"] = pd.to_datetime(
        df["Transaction_Date"], errors="coerce", dayfirst=True
    ).dt.strftime("%Y-%m-%d")
    
    return df


def split_valid_and_invalid(df):
    df = df.copy()
    # Helper to find whitespace-only strings
    empty_value = lambda col: col.str.strip().eq("")
    rejected_values_df = (
        # selects all null entries in any of the key columns
        df[KEY_COLUMNS].isnull().any(axis=1)
        # selects all null entries in any of the key columns after removing the whitespace
        | (df[KEY_COLUMNS].astype(str).apply(empty_value).any(axis=1))
        | (df["Transaction_Amount"] < 0)
        | (df["Account_Balance"] < 0)
        | (df["Age"] < 16)
        | (df["Age"] > 100)
        # all Is_Fraud values that are NOT true or false
        | (~df["Is_Fraud"].isin([0, 1]))
    )

    invalid_values_df = df[rejected_values_df].copy()
    # all the rows not rejected (i.e valid) are stored in this new dataframe
    valid_values_df = df[~rejected_values_df].copy()
    return invalid_values_df, valid_values_df


if __name__ == "__main__":
    main()
