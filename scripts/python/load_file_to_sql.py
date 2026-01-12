import pandas as pd
from sqlalchemy import create_engine
from extract_and_transform import all_checks, extract


def get_engine():
    # insert connection string here
    connection_url = (CONNECTION_STRING)
    return create_engine(connection_url)


def load_bronze(valid_df, table_name="bronze_bank_transactions"):
    engine = get_engine()
    try:
        # uses if_exists='append' so previous history in Bronze is not deleted
        valid_df.to_sql(table_name, engine, if_exists="append", index=False)
    except Exception as other_error:
        print(f"Error: Could not load data to SQL server: {other_error}")


def main():
    try:
        print("Extracting data...")
        df = extract("Bank_Transaction_Fraud_Detection.csv")

        print("Running validation and cleaning...")
        invalid_df, valid_df = all_checks(df)
        
        # handles invalid data (logs it to a local CSV for review)
        if not invalid_df.empty:
            invalid_df = invalid_df.copy()
            print(f"Warning: {len(invalid_df)} rows failed validation...")
            invalid_df.to_csv("invalid_records.csv")
            print("Rejected records saved to 'invalid_records.csv'")

        # loads the Cleaned Data to Bronze Layer
        if not valid_df.empty:
            print("Loading valid data to Bronze layer...")
            load_bronze(valid_df)
            print(f"Done. {len(valid_df)} rows have been loaded into the Bronze layer")
        else:
            print("No valid data found")
    except FileNotFoundError as file_error:
        print(f"Error: This file might be in a different folder: {file_error}")


if __name__ == "__main__":
    main()
