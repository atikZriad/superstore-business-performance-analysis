
/*
Project: Superstore Business Performance Analysis
Purpose: Validate row grain, completeness, consistency, and core KPI totals.
Database: PostgreSQL
Expected table: public.superstore

Run this script before performing business analysis.
These queries identify potential data-quality issues; they do not
automatically determine whether a record is incorrect.
Do not modify or delete source rows based on these checks alone.
*/


-- 1. Record count and identifier uniqueness
SELECT
    COUNT(*) AS row_count,
    COUNT(DISTINCT row_id) AS distinct_row_ids,
    COUNT(DISTINCT order_id) AS distinct_orders,
    COUNT(DISTINCT customer_id) AS distinct_customers
FROM public.superstore;


-- 2. Identify repeated row IDs
SELECT
    row_id,
    COUNT(*) AS copies
FROM public.superstore
GROUP BY row_id
HAVING COUNT(*) > 1
ORDER BY copies DESC, row_id;


-- 3. Check missing values in important analysis fields
SELECT
    COUNT(*) FILTER (
        WHERE order_id IS NULL OR BTRIM(order_id) = ''
    ) AS missing_order_id,

    COUNT(*) FILTER (
        WHERE customer_id IS NULL OR BTRIM(customer_id) = ''
    ) AS missing_customer_id,

    COUNT(*) FILTER (
        WHERE order_date IS NULL
    ) AS missing_order_date,

    COUNT(*) FILTER (
        WHERE ship_date IS NULL
    ) AS missing_ship_date,

    COUNT(*) FILTER (
        WHERE product_id IS NULL OR BTRIM(product_id) = ''
    ) AS missing_product_id,

    COUNT(*) FILTER (
        WHERE category IS NULL OR BTRIM(category) = ''
    ) AS missing_category,

    COUNT(*) FILTER (
        WHERE sub_category IS NULL OR BTRIM(sub_category) = ''
    ) AS missing_sub_category,

    COUNT(*) FILTER (
        WHERE sales IS NULL
    ) AS missing_sales,

    COUNT(*) FILTER (
        WHERE profit IS NULL
    ) AS missing_profit,

    COUNT(*) FILTER (
        WHERE quantity IS NULL
    ) AS missing_quantity,

    COUNT(*) FILTER (
        WHERE discount IS NULL
    ) AS missing_discount,

    COUNT(*) FILTER (
        WHERE postal_code IS NULL
    ) AS missing_postal_code
FROM public.superstore;


-- 4. Check date ranges and potentially invalid numeric values
SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,

    MIN(ship_date) AS first_ship_date,
    MAX(ship_date) AS last_ship_date,

    MIN(sales) AS min_line_sales,
    MAX(sales) AS max_line_sales,

    MIN(profit) AS min_line_profit,
    MAX(profit) AS max_line_profit,

    COUNT(*) FILTER (
        WHERE ship_date < order_date
    ) AS ship_before_order_rows,

    COUNT(*) FILTER (
        WHERE quantity <= 0
    ) AS nonpositive_quantity_rows,

    COUNT(*) FILTER (
        WHERE sales < 0
    ) AS negative_sales_rows,

    COUNT(*) FILTER (
        WHERE discount < 0 OR discount > 1
    ) AS discount_out_of_range_rows
FROM public.superstore;


-- 5. Baseline business KPIs
SELECT
    ROUND(SUM(sales)::numeric, 2) AS total_revenue,

    ROUND(SUM(profit)::numeric, 2) AS total_profit,

    ROUND(
        (SUM(profit) / NULLIF(SUM(sales), 0) * 100)::numeric,
        2
    ) AS overall_profit_margin_pct,

    COUNT(DISTINCT order_id) AS distinct_orders,

    COUNT(DISTINCT customer_id) AS distinct_customers,

    SUM(quantity) AS units_sold
FROM public.superstore;


-- 6. Inspect repeated row IDs with their associated order and product
SELECT
    row_id,
    COUNT(DISTINCT order_id) AS distinct_orders,
    COUNT(DISTINCT product_id) AS distinct_products,
    COUNT(*) AS total_records
FROM public.superstore
GROUP BY row_id
HAVING COUNT(*) > 1
ORDER BY total_records DESC, row_id;