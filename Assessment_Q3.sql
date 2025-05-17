WITH savings_last_txn AS (
    SELECT 
        plan_id,
        owner_id,
        MAX(transaction_date) AS last_transaction_date
    FROM savings_savingsaccount
    WHERE transaction_status = 'success'
    GROUP BY plan_id, owner_id
),
investments_last_txn AS (
    SELECT 
        id AS plan_id,
        owner_id,
        MAX(last_charge_date) AS last_transaction_date
    FROM plans_plan
    WHERE is_a_fund = 1 OR is_fixed_investment = 1
      AND status_id = 1  -- assuming 1 means active
    GROUP BY id, owner_id
),
active_savings_plans AS (
    SELECT id AS plan_id, owner_id, 'Savings' AS type
    FROM plans_plan
    WHERE status_id = 1  -- active savings plans only
      AND is_a_fund = 0 AND is_fixed_investment = 0 -- assuming these flags identify savings
),
-- Combine savings plans with last txn dates
savings_with_txn AS (
    SELECT asp.plan_id, asp.owner_id, asp.type,
           COALESCE(slt.last_transaction_date, '1900-01-01') AS last_transaction_date
    FROM active_savings_plans asp
    LEFT JOIN savings_last_txn slt ON asp.plan_id = slt.plan_id
),
-- Combine savings and investments
all_accounts AS (
    SELECT
        plan_id,
        owner_id,
        type,
        last_transaction_date
    FROM savings_with_txn

    UNION ALL

    SELECT
        plan_id,
        owner_id,
        'Investment' AS type,
        last_transaction_date
    FROM investments_last_txn
)
SELECT
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    DATEDIFF(CURRENT_DATE, last_transaction_date) AS inactivity_days
FROM all_accounts
WHERE last_transaction_date < DATE_SUB(CURRENT_DATE, INTERVAL 365 DAY)
ORDER BY inactivity_days DESC;
