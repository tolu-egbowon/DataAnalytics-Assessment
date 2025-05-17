WITH customer_transactions AS (
    SELECT 
        u.id AS customer_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
        TIMESTAMPDIFF(MONTH, u.created_on, CURDATE()) AS tenure_months,
        COUNT(s.id) AS total_transactions,
        IFNULL(AVG(s.confirmed_amount * 0.001), 0) AS avg_profit_per_transaction
    FROM users_customuser u
    LEFT JOIN savings_savingsaccount s
        ON u.id = s.owner_id
        AND s.transaction_status = 'success'
    GROUP BY u.id, u.first_name, u.last_name, u.created_on
),
clv_estimation AS (
    SELECT 
        customer_id,
        name,
        tenure_months,
        total_transactions,
        ROUND(
            CASE 
                WHEN tenure_months > 0 THEN (total_transactions / tenure_months) * 12 * avg_profit_per_transaction
                ELSE 0
            END, 
        2) AS estimated_clv
    FROM customer_transactions
)
SELECT *
FROM clv_estimation
ORDER BY estimated_clv DESC;





