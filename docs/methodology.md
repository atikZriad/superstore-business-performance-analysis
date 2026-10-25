# Methodology

## Objective
Assess whether Superstore's revenue growth is translating into profitable growth, identify product and customer areas with weak profitability, and develop evidence-led follow-up actions.

## Source and Data Structure
The analysis uses the Sample Superstore transaction dataset for SQL practice. Each record represents a product line within an order, not a unique order.

The expected PostgreSQL table is `public.superstore`, using snake_case column names. The source dataset's redistribution rights have not been confirmed.

## Validation Approach
1. Validate row counts, Row ID uniqueness, distinct order and customer counts, date ranges, and missing values.
2. Reconcile revenue, profit, profit margin, orders, customers, and units against independent calculations from the CSV.
3. Aggregate data to the appropriate level before applying window functions or joining summary results.
4. Use distinct order and customer counts for their respective KPIs; do not treat product-line records as orders.
5. Treat unusual monthly results as investigation prompts rather than evidence of causation.
6. Resolve conflicting practice-note figures against the dataset and SQL outputs before reporting results.

## Interpretation Principles
- **Revenue and profit:** Revenue measures recorded sales, while profit reflects the dataset's supplied profit values. Profit margin is total profit divided by total revenue.
- **Average order value (AOV):** Revenue divided by distinct orders for the selected period.
- **Profit per active customer:** Period profit divided by the number of distinct customers active during that period. This is not customer lifetime value.
- **Customer profitability:** Negative cumulative recorded profit does not, by itself, justify discontinuing a customer relationship because acquisition costs and cost-to-serve are not included.
- **Discounts and losses:** An association between discount levels and losses does not establish causation. Product mix, pricing, cost structure, and order size may also influence profitability.

## Reproducibility
Run the SQL scripts in numerical order in PostgreSQL after loading the dataset. Reconcile query results with the findings register before capturing screenshots or exporting results for publication.

The raw CSV is excluded from the project package because redistribution rights have not been confirmed. The project should document the dataset source and loading requirements so the analysis can be reproduced independently.