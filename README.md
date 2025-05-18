# DataAnalytics-Assessment
 Assessment 1: Total Deposits Overview
Objective:
Determine the top 100 users based on the total value of their savings and investments.

Approach:
Savings Aggregation:

Calculate the total confirmed savings (SUM(confirmed_amount)) per user from the savings_savingsaccount table.

Investments Aggregation:

Sum investment amounts (SUM(amount)) from the plans_plan table for users with either is_a_fund = 1 or is_fixed_investment = 1.

User Data Join:

Join the user data with the savings and investment summaries on owner_id.

Final Output:

Present full name, savings/investment counts, and total deposits (savings + investments).

Sort by total deposits and limit to the top 100 users.

Challenges:
Name Handling: Some users may not have a name field filled. Used COALESCE with CONCAT(first_name, last_name) as fallback.

Data Join Limitations: Ensured only users with both savings and investments were included—could modify to outer joins if partial data is desired.

 Assessment 2: Customer Transaction Frequency Segmentation
Objective:
Classify users based on how frequently they transact monthly.

Approach:
Transaction Counts:

Count all transactions per user grouped by year and month.

Monthly Average Calculation:

Take the average of these monthly counts to determine user-level frequency.

Categorization:

Bucket users as:

High Frequency: ≥10 txns/month

Medium Frequency: 3–9

Low Frequency: <3

Final Summary:

Count users per category and calculate average monthly transactions per category.

Challenges:
Month Boundary Handling: Handled year/month separately to avoid misgrouping across years.

Averaging Method: Used AVG(txn_count) instead of total/number of months to account for inactive months.

 Assessment 3: Inactive Financial Plans Detection
Objective:
Identify investment and savings plans with no transactions in over a year.

Approach:
Last Successful Transactions:

For savings: use the latest transaction_date with status = 'success'.

For investments: use last_charge_date, filtered by active status (status_id = 1).

Plan Identification:

Only include active savings plans not marked as funds or fixed investments.

Combining Plans:

Merge savings and investment plans with their latest transaction dates.

Inactivity Flag:

Calculate days since the last transaction.

Filter plans with inactivity over 365 days.

Challenges:
Transaction Mismatch: Different transaction sources (savings_savingsaccount vs. plans_plan) needed merging logic.

Missing Dates: Used COALESCE(..., '1900-01-01') as a fallback for null transaction dates to avoid join failures.

Logical Assumptions: Assumed status_id = 1 meant “active.”

 Assessment 4: Customer Lifetime Value (CLV) Estimation
Objective:
Estimate each customer’s lifetime value based on tenure, transaction volume, and average profits.

Approach:
Customer Profiling:

Extract tenure (in months) since user creation.

Calculate the total number of successful savings transactions.

Estimate average profit per transaction using confirmed_amount * 0.001.

CLV Calculation:

Project yearly transaction activity and multiply by profit to estimate CLV:
CLV=(
transactions
tenure
)
×
12
×
avg_profit
CLV=( 
tenure
transactions
​
 )×12×avg_profit
Output:

Provide customer ID, name, tenure, transaction details, and calculated CLV.

Challenges:
Zero-Tenure Edge Cases: Handled tenure_months = 0 with conditional logic to prevent divide-by-zero errors.

Profit Assumption: Used 0.1% (0.001) multiplier as an assumed profit rate; should ideally come from business logic.

Data Skew: Users with very short tenure but many transactions may appear overvalued—highlight for stakeholder review.






