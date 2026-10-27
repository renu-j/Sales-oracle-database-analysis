-- ============================================================
-- A6 - CUSTOMER PURCHASE FREQUENCY
-- ============================================================
-- Business Question:
-- Which customers are one-time, occasional, or repeat buyers?
--
-- SQL Concepts:
-- CTE, COUNT(), CASE
--
-- Output:
-- Customer order count and purchase-frequency classification.
-- ============================================================

WITH customer_orders AS (
    SELECT
        c.CUSTOMER_ID,
        c.CUSTOMER_NAME,
        c.SEGMENT,
        COUNT(DISTINCT o.ORDER_ID) AS TOTAL_ORDERS
    FROM CUSTOMERS c
    JOIN ORDERS o
        ON c.CUSTOMER_ID = o.CUSTOMER_ID
    GROUP BY
        c.CUSTOMER_ID,
        c.CUSTOMER_NAME,
        c.SEGMENT
)
SELECT
    CUSTOMER_ID,
    CUSTOMER_NAME,
    SEGMENT,
    TOTAL_ORDERS,
    CASE
        WHEN TOTAL_ORDERS = 1 THEN 'One-Time Customer'
        WHEN TOTAL_ORDERS BETWEEN 2 AND 3 THEN 'Occasional Customer'
        ELSE 'Repeat Customer'
    END AS CUSTOMER_TYPE
FROM customer_orders
ORDER BY TOTAL_ORDERS DESC;