-- ============================================================
-- A2 - MONTH-OVER-MONTH SALES GROWTH
-- ============================================================
-- Business Question:
-- How did monthly sales change compared with the previous month?
--
-- Output:
-- Monthly sales, previous month's sales, and growth percentage
-- ============================================================

SELECT
    SALES_MONTH,
    TOTAL_SALES,
    PREVIOUS_MONTH_SALES,
    ROUND(
        (
            (TOTAL_SALES - PREVIOUS_MONTH_SALES)
            / NULLIF(PREVIOUS_MONTH_SALES, 0)
        ) * 100,2
        
    ) AS SALES_GROWTH_PERCENT
FROM (
    SELECT
        SALES_MONTH,
        TOTAL_SALES,
        LAG(TOTAL_SALES) OVER (
            ORDER BY SALES_MONTH
        ) AS PREVIOUS_MONTH_SALES
    FROM (
        SELECT
            TO_CHAR(o.ORDER_DATE, 'YYYY-MM') AS SALES_MONTH,
            ROUND(SUM(oi.SALES), 2) AS TOTAL_SALES
        FROM ORDERS o
        JOIN ORDER_ITEMS oi
            ON o.ORDER_ID = oi.ORDER_ID
        GROUP BY
            TO_CHAR(o.ORDER_DATE, 'YYYY-MM')
    )
)
ORDER BY SALES_MONTH;