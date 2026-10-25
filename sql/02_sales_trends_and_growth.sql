
/*
Project: Superstore Business Performance Analysis
Business question: Is revenue growth translating into profitable growth?

Monthly grain: One row per calendar month.
Annual grain: One row per year.

Purpose:
1. Track monthly revenue, profit, and profit margin.
2. Compare performance with the previous month.
3. Compare annual performance.
4. Smooth monthly fluctuations using a rolling 3-month revenue average.
*/

-- 1. Monthly performance and month-over-month changes
WITH monthly AS (
    SELECT
        DATE_TRUNC('month', order_date)::date AS month,
        SUM(sales) AS revenue,
        SUM(profit) AS profit,
        COUNT(DISTINCT order_id) AS orders,
        SUM(quantity) AS units_sold
    FROM public.superstore
    GROUP BY 1
), compared AS (
    SELECT
        *,
        profit / NULLIF(revenue, 0) * 100 AS profit_margin_pct,
        LAG(revenue) OVER (ORDER BY month) AS prior_revenue,
        LAG(profit) OVER (ORDER BY month) AS prior_profit,
        LAG( profit / NULLIF(revenue, 0) * 100) OVER (ORDER BY month) AS prior_margin_pct
    FROM monthly
)
SELECT
    month,
    ROUND(revenue::numeric, 2) AS revenue,
    ROUND(profit::numeric, 2) AS profit,
    ROUND(profit_margin_pct::numeric, 2) AS profit_margin_pct,
    orders,
    units_sold,
    ROUND((revenue / NULLIF(orders, 0))::numeric,2) AS average_order_value,
    ROUND(((revenue - prior_revenue) / NULLIF(prior_revenue, 0) * 100)::numeric,2) AS revenue_mom_pct,
    ROUND((profit - prior_profit)::numeric,2) AS profit_change_amount,
    ROUND(((profit - prior_profit) / NULLIF(prior_profit, 0) * 100)::numeric,2) AS profit_change_pct,
    ROUND((profit_margin_pct - prior_margin_pct)::numeric,2) AS margin_change_pp
FROM compared
ORDER BY month;

-- 2. Annual performance and year-over-year growth
WITH annual AS (
    SELECT
        EXTRACT(YEAR FROM order_date)::int AS year,
        SUM(sales) AS revenue,
        SUM(profit) AS profit,
        COUNT(DISTINCT order_id) AS orders,
        COUNT(DISTINCT customer_id) AS active_customers
    FROM public.superstore
    GROUP BY 1
), compared AS (
    SELECT
        *,
        profit / NULLIF(revenue, 0) * 100 AS profit_margin_pct,
        LAG(revenue) OVER (ORDER BY year) AS prior_revenue,
        LAG(profit) OVER (ORDER BY year) AS prior_profit,
        LAG(profit / NULLIF(revenue, 0) * 100) OVER (ORDER BY year) AS prior_margin_pct
    FROM annual
)
SELECT
    year,
    ROUND(revenue::numeric, 2) AS revenue,
    ROUND(profit::numeric, 2) AS profit,
    ROUND(profit_margin_pct::numeric, 2) AS profit_margin_pct,
    orders,
    active_customers,
    ROUND((revenue / NULLIF(orders, 0))::numeric, 2) AS average_order_value,
    ROUND(((revenue - prior_revenue) / NULLIF(prior_revenue, 0) * 100)::numeric, 2) AS revenue_yoy_pct,
    ROUND(((profit - prior_profit) / NULLIF(prior_profit, 0) * 100)::numeric, 2) AS profit_yoy_pct,
    ROUND((profit_margin_pct - prior_margin_pct)::numeric, 2) AS margin_change_pp
FROM compared
ORDER BY year;


-- 3. Rolling 3-month average revenue
WITH monthly AS (
    SELECT
        DATE_TRUNC('month', order_date)::date AS month,
        SUM(sales) AS revenue
    FROM public.superstore
    GROUP BY 1
)
SELECT
    month,
    ROUND(revenue::numeric, 2) AS monthly_revenue,
    ROUND(AVG(revenue) OVER (ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)::numeric, 2) AS rolling_3_month_avg_revenue
FROM monthly
ORDER BY month;