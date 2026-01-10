CREATE SCHEMA silver_layer;
GO

DROP TABLE IF EXISTS dim_customers;
CREATE TABLE dim_customers (
    customer_key INT PRIMARY KEY IDENTITY(1,1),
    customer_id VARCHAR(50) NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    customer_gender VARCHAR(6) NOT NULL,
    customer_age INT,
    customer_email VARCHAR(30) NOT NULL,
    customer_contact VARCHAR(30) NOT NULL,
    customer_state VARCHAR(100),
    customer_city VARCHAR(100),
    table_create_date DATETIME2 DEFAULT GETDATE() 
);

DROP TABLE IF EXISTS dim_account;
CREATE TABLE dim_account (
    account_key INT PRIMARY KEY IDENTITY(1,1),
    customer_key INT,
    account_type VARCHAR(20) NOT NULL,
    account_bank_branch VARCHAR(60) NOT NULL,
    table_create_date DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_dim_customer_key FOREIGN KEY (customer_key) REFERENCES dim_customers(customer_key)
);

DROP TABLE IF EXISTS dim_merchant;
CREATE TABLE dim_merchant (
    merchant_key INT PRIMARY KEY IDENTITY(1,1),
    merchant_id VARCHAR(50),
    merchant_category VARCHAR(50),
    table_create_date DATETIME2 DEFAULT GETDATE()
);

DROP TABLE IF EXISTS dim_device;
CREATE TABLE dim_device (
    device_key INT PRIMARY KEY IDENTITY(1,1),
    transaction_device VARCHAR(50),
    device_type VARCHAR(50),
    table_create_date DATETIME2 DEFAULT GETDATE()
);

DROP TABLE IF EXISTS fact_transactions;
CREATE TABLE fact_transactions (
    transaction_key INT PRIMARY KEY IDENTITY(1,1),
    transaction_id VARCHAR(36) NOT NULL,
    account_key INT,
    merchant_key INT,
    device_key INT,
    transaction_datetime DATETIME2 NOT NULL,
    transaction_currency VARCHAR(10),
    transaction_amount DECIMAL(8,2) NOT NULL,
    account_balance DECIMAL(10,2) NOT NULL,
    transaction_description VARCHAR(100) NOT NULL,
    transaction_type VARCHAR(50) NOT NULL,
    transaction_location VARCHAR(100) NOT NULL,
    transaction_is_fraud VARCHAR(5) NOT NULL,
    table_create_date DATETIME2 DEFAULT GETDATE(),
    CONSTRAINT fk_dim_account_key FOREIGN KEY (account_key) REFERENCES dim_account(account_key),
    CONSTRAINT fk_dim_merchant_key FOREIGN KEY (merchant_key) REFERENCES dim_merchant(merchant_key),
    CONSTRAINT fk_dim_device_key FOREIGN KEY (device_key) REFERENCES dim_device(device_key)
);
