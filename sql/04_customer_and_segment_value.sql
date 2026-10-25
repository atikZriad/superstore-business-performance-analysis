/* Business question: Where is customer value concentrated, and which customers
or segments are unprofitable? Customer metrics are calculated at customer grain. */

-- Segment-level revenue and profit per active customer
SELECT segment,
       COUNT(DISTINCT customer_id) AS active_customers,
       COUNT(DISTINCT order_id) AS orders,
       ROUND(SUM(sales)::numeric, 2) AS revenue,
       ROUND(SUM(profit)::numeric, 2) AS profit,
       ROUND((SUM(profit) / NULLIF(SUM(sales), 0) * 100)::numeric, 2) AS profit_margin_pct,
       ROUND((SUM(sales) / NULLIF(COUNT(DISTINCT customer_id), 0))::numeric, 2) AS revenue_per_active_customer,
       ROUND((SUM(profit) / NULLIF(COUNT(DISTINCT customer_id), 0))::numeric, 2) AS profit_per_active_customer
FROM public.superstore
GROUP BY segment
ORDER BY SUM(profit) DESC;

-- Largest loss-making customers
WITH customer_economics AS (
    SELECT customer_id,
           MIN(customer_name) AS customer_name,
           MIN(segment) AS segment,
           SUM(sales) AS revenue,
           SUM(profit) AS profit,
           COUNT(DISTINCT order_id) AS orders,
           AVG(discount) AS average_line_discount
    FROM public.superstore
    GROUP BY customer_id
)
SELECT customer_id,
       customer_name,
       segment,
       ROUND(revenue::numeric, 2) AS revenue,
       ROUND(profit::numeric, 2) AS profit,
       orders,
       ROUND((profit / NULLIF(revenue, 0) * 100)::numeric, 2) AS profit_margin_pct,
       ROUND(average_line_discount::numeric, 4) AS average_line_discount
FROM customer_economics
WHERE profit < 0
ORDER BY profit ASC
LIMIT 25;

-- Revenue concentration among top customers (top 10 share of all revenue)
WITH customer_revenue AS (
    SELECT customer_id, SUM(sales) AS revenue
    FROM public.superstore
    GROUP BY customer_id
), ranked AS (
    SELECT *, ROW_NUMBER() OVER (ORDER BY revenue DESC) AS revenue_rank
    FROM customer_revenue
)
SELECT COUNT(*) FILTER (WHERE revenue_rank <= 10) AS customers_in_top_10,
       ROUND((SUM(revenue) FILTER (WHERE revenue_rank <= 10))::numeric, 2) AS top_10_revenue,
       ROUND((SUM(revenue) FILTER (WHERE revenue_rank <= 10)
             / NULLIF(SUM(revenue), 0) * 100)::numeric, 2) AS top_10_revenue_share_pct,
       ROUND(SUM(revenue)::numeric, 2) AS total_revenue
FROM ranked;

-- New vs repeat customers by month, based on each customer's first observed order date.
WITH customer_first_order AS (
    SELECT customer_id, MIN(order_date) AS first_order_date
    FROM public.superstore
    GROUP BY customer_id
), monthly_customer_activity AS (
    SELECT DATE_TRUNC('month', s.order_date)::date AS month,
           s.customer_id,
           MIN(s.order_date) AS first_activity_in_month,
           MIN(c.first_order_date) AS first_order_date
    FROM public.superstore s
    JOIN customer_first_order c USING (customer_id)
    GROUP BY 1, 2
)
SELECT month,
       COUNT(*) FILTER (WHERE DATE_TRUNC('month', first_order_date)::date = month) AS new_customers,
       COUNT(*) FILTER (WHERE DATE_TRUNC('month', first_order_date)::date < month) AS previously_acquired_active_customers,
       COUNT(*) AS active_customers
FROM monthly_customer_activity
GROUP BY month
ORDER BY month;
