CREATE SCHEMA bronze_layer;
GO


DROP TABLE IF EXISTS bronze_bank_transactions;
CREATE TABLE bronze_bank_transactions (
    "Customer_ID" VARCHAR(50), 
    "Customer_Name" VARCHAR(100),
    "Gender" VARCHAR(6),
    "Age" INT,
    "State" VARCHAR(100),
    "City" VARCHAR(100),
    "Bank_Branch" VARCHAR(60),
    "Account_Type" VARCHAR(20),
    "Transaction_ID" VARCHAR(36),
    "Transaction_Date" DATETIME2,
    "Transaction_Time" DATETIME2,
    "Transaction_Amount" DECIMAL(8,2),
    "Merchant_ID" VARCHAR(50),
    "Transaction_Type" VARCHAR(50),
    "Merchant_Category" VARCHAR(50),
    "Account_Balance" DECIMAL(8,2),
    "Transaction_Device" VARCHAR(50),
    "Transaction_Location" VARCHAR(100),
    "Device_Type" VARCHAR(50), 
    "Is_Fraud" VARCHAR(5),
    "Transaction_Currency" VARCHAR(5),
    "Customer_Contact" VARCHAR(30),
    "Transaction_Description" VARCHAR(100),
    "Customer_Email" VARCHAR(100),
    "Transaction_Datetime" DATETIME2,
);
