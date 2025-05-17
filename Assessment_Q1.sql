WITH savings AS (
    SELECT owner_id, 
           SUM(confirmed_amount) AS total_savings, 
           COUNT(*) AS savings_count
    FROM savings_savingsaccount
    WHERE confirmed_amount > 0
    GROUP BY owner_id
),
investments AS (
    SELECT owner_id, 
           SUM(amount) AS total_investments, 
           COUNT(*) AS investment_count
    FROM plans_plan
    WHERE is_a_fund = 1 OR is_fixed_investment = 1
    GROUP BY owner_id
)
SELECT
    u.id AS user_id,
    COALESCE(u.name, CONCAT(u.first_name, ' ', u.last_name)) AS full_name,
    s.savings_count,
    i.investment_count,
    s.total_savings + i.total_investments AS total_deposits
FROM users_customuser u
JOIN savings s ON u.id = s.owner_id
JOIN investments i ON u.id = i.owner_id
ORDER BY total_deposits DESC
LIMIT 100;


