CREATE OR ALTER PROCEDURE load_silver_layer AS
    BEGIN
        BEGIN TRY
            INSERT INTO dim_customers (customer_id, customer_name, customer_gender, customer_age, customer_email, customer_contact, 
                customer_state, customer_city)(
                SELECT
                    "Customer_ID", 
                    "Customer_Name",
                    "Gender",
                    "Age",
                    "Customer_Email",
                    "Customer_Contact",
                    "State",
                    "City"
                FROM bronze_bank_transactions
            );


            INSERT INTO dim_account(customer_key, account_type, account_bank_branch)(
                SELECT
                    dc.customer_key,
                    bb.Account_Type,
                    bb.Bank_Branch
                FROM bronze_bank_transactions AS bb
                INNER JOIN dim_customers AS dc
                ON bb.Customer_ID = dc.customer_id
            );


            INSERT INTO dim_merchant(merchant_id, merchant_category)(
                SELECT
                    Merchant_ID,
                    Merchant_Category
                FROM bronze_bank_transactions
            );


            INSERT INTO dim_device(transaction_device, device_type)(
                SELECT
                    DISTINCT Transaction_Device,
                    Device_Type
                FROM bronze_bank_transactions
            );


            INSERT INTO fact_transactions (transaction_id, account_key, merchant_key, device_key, transaction_datetime, transaction_currency, 
                  transaction_amount, account_balance, transaction_description, transaction_type, transaction_location, transaction_is_fraud)(
                SELECT
                    bb.Transaction_ID,
                    da.account_key,
                    dm.merchant_key,
                    dd.device_key,
                    bb.Transaction_Datetime,
                    bb.Transaction_Currency,
                    bb.Transaction_Amount,
                    bb.Account_Balance,
                    bb.Transaction_Description,
                    bb.Transaction_Type,
                    bb.Transaction_Location,
                    CASE 
                        WHEN bb.Is_Fraud = 0 THEN 'False'
                        ELSE 'True'
                    END AS Is_Fraud
                FROM bronze_bank_transactions AS bb
                INNER JOIN dim_customers AS dc
                ON bb.Customer_ID = dc.customer_id
                INNER JOIN dim_account AS da
                ON dc.customer_key = da.customer_key
                INNER JOIN dim_device AS dd
                ON dd.transaction_device = bb.Transaction_Device AND dd.device_type = bb.Device_Type
                INNER JOIN dim_merchant AS dm
                ON dm.merchant_id =  bb.Merchant_ID
            );
        END TRY

        BEGIN CATCH
            PRINT 'An error occured loading the silver layer'
            PRINT 'Error message: ' + ERROR_MESSAGE();
        END CATCH

    END
