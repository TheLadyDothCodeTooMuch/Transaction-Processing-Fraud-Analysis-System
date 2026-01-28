-- Which accounts are most frequently involved in fraudulent transactions?
SELECT
    da.account_type,
    COUNT(*) AS No_of_Transactions,
    SUM(CASE
            WHEN ft.transaction_is_fraud = 'True' THEN 1
            ELSE 0
        END) AS No_of_Fraudulent_Transactions,
    CONCAT(CAST(SUM(CASE
            WHEN ft.transaction_is_fraud = 'True' THEN 1
            ELSE 0
        END) * 100 /COUNT(*) AS decimal(5,2)), '%') AS Rate_of_Fraud
FROM fact_transactions AS ft
INNER JOIN dim_account AS da
ON ft.account_key = da.account_key
GROUP BY da.account_type
ORDER BY No_of_Transactions DESC;


-- Which merchants have the highest fraud rates (not just counts)?
SELECT
    dm.merchant_category,
    COUNT(ft.transaction_is_fraud) AS No_of_Fraudulent_Transactions,
    CONCAT((COUNT(ft.transaction_is_fraud) * 100)/SUM(COUNT(ft.transaction_is_fraud)) OVER(), '%') AS Perc_of_Fraudulent_Transaction
FROM fact_transactions AS ft
INNER JOIN dim_merchant AS dm
ON ft.merchant_key = dm.merchant_key
WHERE ft.transaction_is_fraud = 'True'
GROUP BY dm.merchant_category
ORDER BY No_of_Fraudulent_Transactions DESC
;


-- Are there specific devices strongly associated with fraud?
SELECT
    dd.device_type,
    COUNT(ft.transaction_is_fraud) AS No_of_Fraudulent_Transactions
FROM fact_transactions AS ft
INNER JOIN dim_device AS dd
ON ft.device_key = dd.device_key
WHERE ft.transaction_is_fraud = 'True'
GROUP BY dd.device_type 
ORDER BY No_of_Fraudulent_Transactions DESC
;


-- Does fraud spike at certain times of day / days of week / months?
-- Day of the month
SELECT
    DAY(transaction_datetime) AS Days_of_The_Month,
    COUNT(transaction_is_fraud) AS No_of_Fraudulent_Transactions
FROM fact_transactions
WHERE transaction_is_fraud = 'True'
GROUP BY DAY(transaction_datetime)
ORDER BY No_of_Fraudulent_Transactions DESC
;


-- Days of week
SELECT 
    DATENAME(WEEKDAY, transaction_datetime) AS Week_Day,
    COUNT(transaction_is_fraud) AS No_of_Fraudulent_Transactions
FROM fact_transactions
WHERE transaction_is_fraud = 'True'
GROUP BY DATENAME(dw, transaction_datetime)
ORDER BY No_of_Fraudulent_Transactions DESC
;

-- hour of day
SELECT 
    DATEPART(HOUR, transaction_datetime) AS Hour_of_The_Day,
    COUNT(transaction_is_fraud) AS No_of_Fraudulent_Transactions
FROM fact_transactions
WHERE transaction_is_fraud = 'True'
GROUP BY DATEPART(HOUR, transaction_datetime)
ORDER BY No_of_Fraudulent_Transactions DESC
;


-- Are high-value transactions more likely to be fraudulent than low-value ones?
SELECT
    CASE 
        WHEN transaction_amount BETWEEN 70001 AND  100000 THEN 'High'
        WHEN transaction_amount BETWEEN 30001 AND 70000 THEN 'Medium'
        WHEN transaction_amount BETWEEN 1 AND 30000 THEN 'Low'
    END AS amount_range,
    COUNT(transaction_is_fraud) AS No_of_Fraudulent_Transaction
FROM fact_transactions
WHERE transaction_is_fraud = 'True'
GROUP BY 
    CASE 
        WHEN transaction_amount BETWEEN 70001 AND  100000 THEN 'High'
        WHEN transaction_amount BETWEEN 30001 AND 70000 THEN 'Medium'
        WHEN transaction_amount BETWEEN 1 AND 30000 THEN 'Low'
    END
ORDER BY No_of_Fraudulent_Transaction DESC
;


-- Scammed customers grouped by age and gender
SELECT 
    dc.customer_gender,
    CASE 
        WHEN dc.customer_age BETWEEN 16 AND 30 THEN 'Gen Z/Millennial'
        WHEN dc.customer_age BETWEEN 31 AND 50 THEN 'Adult'
        ELSE 'Senior' 
    END AS Age_Group,
    COUNT(*) AS total_transactions,
    SUM(CASE 
            WHEN ft.transaction_is_fraud = 'True' THEN 1 
            ELSE 0
        END) AS fraud_count
FROM fact_transactions AS ft
INNER JOIN dim_account AS da
ON ft.account_key = da.account_key
INNER JOIN dim_customers AS dc 
ON da.customer_key = dc.customer_key
GROUP BY dc.customer_gender, 
        CASE 
            WHEN dc.customer_age BETWEEN 16 AND 30 THEN 'Gen Z/Millennial'
            WHEN dc.customer_age BETWEEN 31 AND 50 THEN 'Adult'
            ELSE 'Senior' 
        END
ORDER BY fraud_count DESC;
