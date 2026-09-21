SELECT
    o.order_date,
    SUM(oi.quantity * p.price) AS daily_revenue,
    SUM(
        SUM(oi.quantity * p.price)
    ) OVER (
        ORDER BY o.order_date
    ) AS running_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY o.order_date
ORDER BY o.order_date;