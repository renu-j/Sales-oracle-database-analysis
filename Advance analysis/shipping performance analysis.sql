-- ============================================================
-- A5 - SHIPPING PERFORMANCE
-- ============================================================
-- Business Question:
-- How many days does each shipping mode take on average?
--
-- SQL Concept:
-- Date arithmetic
--
-- Output:
-- Average delivery days and total orders for each
-- shipping mode.
-- ============================================================

SELECT
    o.SHIP_MODE,
    ROUND(AVG(o.SHIP_DATE - o.ORDER_DATE), 2) AS AVG_DELIVERY_DAYS,
    COUNT(DISTINCT o.ORDER_ID) AS TOTAL_ORDERS
FROM ORDERS o
GROUP BY
    o.SHIP_MODE
ORDER BY
    AVG_DELIVERY_DAYS;