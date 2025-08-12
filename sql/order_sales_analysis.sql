-- Active: 1752368596382@@localhost@3306@ecommerce_db

/* 1. What is the total number of orders per month ? */

SELECT
    YEAR(order_purchase_timestamp) AS years,
    MONTH(order_purchase_timestamp) AS months,
    COUNT(order_id) AS orders_per_month
FROM orders_dataset
GROUP BY
    YEAR(order_purchase_timestamp),
    MONTH(order_purchase_timestamp)
ORDER BY years, months;

/* 2. What is the monthly revenue trend ? */

SELECT DATE_FORMAT(
        od.order_purchase_timestamp, '%Y-%m'
    ) year_months, SUM(opd.payment_value) AS Revenue_Trends
FROM
    orders_dataset od
    JOIN order_payments_dataset opd ON od.order_id = opd.order_id
GROUP BY
    year_months
ORDER BY year_months;

/* 3. What are the top 10 best - selling products by revenue and quantity ? */

SELECT
    oitd.product_id,
    pd.product_category_name,
    COUNT(oitd.product_id) AS total_quantity,
    ROUND(
        SUM(
            oitd.price + oitd.freight_value
        ),
        2
    ) AS total_revenue
FROM
    order_items_dataset oitd
    JOIN products_dataset pd ON oitd.product_id = pd.product_id
GROUP BY
    oitd.product_id,
    pd.product_category_name
ORDER BY total_quantity DESC, total_revenue DESC
LIMIT 10;

/* 4. What is the average delivery time vs estimated delivery time ? */

SELECT
    ROUND(
        AVG(
            DATEDIFF(
                order_delivered_customer_date,
                order_approved_at
            )
        ),
        2
    ) AS avg_delivery_time,
    ROUND(
        AVG(
            DATEDIFF(
                order_estimated_delivery_date,
                order_approved_at
            )
        ),
        2
    ) AS avg_estimated_time
FROM orders_dataset
WHERE
    order_delivered_customer_date IS NOT NULL
    AND order_estimated_delivery_date IS NOT NULL
    AND order_approved_at IS NOT NULL;