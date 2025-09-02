-- Active: 1756496750776@@127.0.0.1@3306@ecommerce_db
/*
Getting the customers RFM
*/

WITH 
    Customer_RFM_CTE AS
    (
    SELECT 
        od.customer_id, 
        DATEDIFF(
            '2018-10-18',
            MAX(order_purchase_timestamp) 
        ) AS Recency,
        COUNT(DISTINCT od.order_id) AS Frequency,
        ROUND(SUM(opd.payment_value), 2) AS Monetary
    FROM
        orders_dataset AS od
    JOIN order_payments_dataset AS opd 
    ON od.order_id = opd.order_id
    WHERE od.order_status = 'delivered'
    GROUP BY customer_id
    ),

    RFM_Scores AS
    (
    SELECT 
        customer_id,
        Recency,
        Frequency,
        Monetary,
        NTILE(5) OVER ( ORDER BY Recency ASC ) AS R_score,
        NTILE(5) OVER ( ORDER BY Frequency DESC ) AS F_score,
        NTILE(5) OVER ( ORDER BY Monetary DESC ) AS M_score

    FROM Customer_RFM_CTE
    )
SELECT customer_id,
    CONCAT_WS('-', R_score, F_score, M_score) AS RFM_Segments,
    (R_score + F_score + M_score) AS RFM_Score_SUM
FROM RFM_Scores
;