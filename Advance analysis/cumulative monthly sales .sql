-- ============================================================
-- A3 - CUMULATIVE MONTHLY SALES
-- ============================================================
-- Business Question:
-- How much total sales has the business accumulated
-- up to each month?
--
-- Output:
-- Monthly sales and cumulative sales.
-- ============================================================

SELECT
    SALES_MONTH,
    TOTAL_SALES,
    ROUND(
        SUM(TOTAL_SALES) OVER (ORDER BY SALES_MONTH),
        2
    ) AS CUMULATIVE_SALES
FROM (
    SELECT
        TO_CHAR(o.ORDER_DATE, 'YYYY-MM') AS SALES_MONTH,
        ROUND(SUM(oi.SALES), 2) AS TOTAL_SALES
    FROM ORDERS o
    JOIN ORDER_ITEMS oi
        ON o.ORDER_ID = oi.ORDER_ID
    GROUP BY TO_CHAR(o.ORDER_DATE, 'YYYY-MM')
)
ORDER BY SALES_MONTH;