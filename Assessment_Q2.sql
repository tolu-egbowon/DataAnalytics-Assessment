WITH monthly_txn_counts AS (
    SELECT 
        owner_id,
        YEAR(transaction_date) AS txn_year,
        MONTH(transaction_date) AS txn_month,
        COUNT(*) AS txn_count
    FROM savings_savingsaccount
    GROUP BY owner_id, YEAR(transaction_date), MONTH(transaction_date)
),
avg_txn_per_month AS (
    SELECT
        owner_id,
        AVG(txn_count) AS avg_monthly_txns
    FROM monthly_txn_counts
    GROUP BY owner_id
),
categorized AS (
    SELECT
        owner_id,
        avg_monthly_txns,
        CASE
            WHEN avg_monthly_txns >= 10 THEN 'High Frequency'
            WHEN avg_monthly_txns BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM avg_txn_per_month
)
SELECT
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_monthly_txns), 2) AS avg_transactions_per_month
FROM categorized
GROUP BY frequency_category
ORDER BY 
    CASE frequency_category
        WHEN 'High Frequency' THEN 1
        WHEN 'Medium Frequency' THEN 2
        WHEN 'Low Frequency' THEN 3
    END;
    
