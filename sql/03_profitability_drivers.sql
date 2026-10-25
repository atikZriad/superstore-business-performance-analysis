
/*
Business question: Which product areas generate revenue but destroy profit?
*/

-- 1. Full-period category and subcategory economics
SELECT
  category,
  sub_category,
  ROUND(SUM(sales)::numeric, 2) AS revenue,
  ROUND(SUM(profit)::numeric, 2) AS profit,
  ROUND((SUM(profit) / NULLIF(SUM(sales), 0) * 100)::numeric, 2) AS profit_margin_pct,
  SUM(quantity) AS units_sold,
  COUNT(DISTINCT order_id) AS orders,
  ROUND(AVG(discount)::numeric, 4) AS average_line_discount
FROM public.superstore
GROUP BY category, sub_category
ORDER BY SUM(profit) ASC;

-- 2. Monthly category economics
SELECT DATE_TRUNC('month', order_date)::date AS month,
       category,
       ROUND(SUM(sales)::numeric, 2) AS revenue,
       ROUND(SUM(profit)::numeric, 2) AS profit,
       ROUND((SUM(profit) / NULLIF(SUM(sales), 0) * 100)::numeric, 2) AS profit_margin_pct,
       SUM(quantity) AS units_sold,
       COUNT(DISTINCT order_id) AS orders
FROM public.superstore
GROUP BY 1, 2
ORDER BY 1, 2;

-- 3. Investigate the March 2015 anomaly by subcategory
SELECT sub_category,
       ROUND(SUM(sales)::numeric, 2) AS revenue,
       ROUND(SUM(profit)::numeric, 2) AS profit,
       ROUND((SUM(profit) / NULLIF(SUM(sales), 0) * 100)::numeric, 2) AS profit_margin_pct,
       COUNT(DISTINCT order_id) AS orders,
       SUM(quantity) AS units_sold,
       ROUND(AVG(discount)::numeric, 4) AS average_line_discount
FROM public.superstore
WHERE order_date >= DATE '2015-03-01'
  AND order_date < DATE '2015-04-01'
GROUP BY sub_category
ORDER BY SUM(profit) ASC;

-- 4. Largest loss-making individual orders
WITH order_economics AS (
    SELECT order_id,
           MIN(order_date) AS order_date,
           MIN(customer_id) AS customer_id,
           MIN(customer_name) AS customer_name,
           SUM(sales) AS revenue,
           SUM(profit) AS profit,
           SUM(quantity) AS units,
           AVG(discount) AS average_line_discount
    FROM public.superstore
    GROUP BY order_id
)
SELECT order_id,
       order_date,
       customer_id,
       customer_name,
       ROUND(revenue::numeric, 2) AS revenue,
       ROUND(profit::numeric, 2) AS profit,
       units,
       ROUND(average_line_discount::numeric, 4) AS average_line_discount
FROM order_economics
WHERE profit < 0
ORDER BY profit ASC
LIMIT 25;

-- 5. Product-level profitability across the full period
SELECT category,
       sub_category,
       product_id,
       product_name,
       ROUND(SUM(sales)::numeric, 2) AS revenue,
       ROUND(SUM(profit)::numeric, 2) AS profit,
       ROUND((SUM(profit) / NULLIF(SUM(sales), 0) * 100)::numeric, 2) AS profit_margin_pct,
       SUM(quantity) AS units_sold,
       COUNT(DISTINCT order_id) AS orders,
       ROUND(AVG(discount)::numeric, 4) AS average_line_discount
FROM public.superstore
GROUP BY category, sub_category, product_id, product_name
ORDER BY SUM(profit) ASC
LIMIT 25;

-- 6. Investigate the largest loss-making order
SELECT order_id,
       order_date,
       product_id,
       product_name,
       category,
       sub_category,
       sales,
       quantity,
       discount,
       profit
FROM public.superstore
WHERE order_id = 'CA-2017-108196'
ORDER BY profit ASC;