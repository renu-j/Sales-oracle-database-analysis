-- ============================================================
-- A4 - CUSTOMERS ABOVE AVERAGE SALES
-- ============================================================
-- Business Question:
-- Which customers generate more sales than the average customer?
--
-- SQL Concept:
-- CTE (Common Table Expression)
--
-- Output:
-- Customers whose total sales are above the average customer.
-- ============================================================

WITH customer_sales AS (
    SELECT
        c.CUSTOMER_ID,
        c.CUSTOMER_NAME,
        c.SEGMENT,
        ROUND(SUM(oi.SALES), 2) AS TOTAL_SALES
    FROM CUSTOMERS c
    JOIN ORDERS o
        ON c.CUSTOMER_ID = o.CUSTOMER_ID
    JOIN ORDER_ITEMS oi
        ON o.ORDER_ID = oi.ORDER_ID
    GROUP BY
        c.CUSTOMER_ID,
        c.CUSTOMER_NAME,
        c.SEGMENT
)
SELECT
    CUSTOMER_ID,
    CUSTOMER_NAME,
    SEGMENT,
    TOTAL_SALES
FROM customer_sales
WHERE TOTAL_SALES > (
    SELECT AVG(TOTAL_SALES)
    FROM customer_sales
)
ORDER BY TOTAL_SALES DESC;