-- ============================================================
-- VIEW - MONTHLY SALES
-- ============================================================
-- Business Question:
-- How are sales, profit and quantity changing month by month?
--reuse monthly sales 
-- Output:
-- Sales Month
-- Total Sales
-- Total Profit
-- Total Quantity
-- ============================================================

CREATE OR REPLACE VIEW VW_MONTHLY_SALES AS
SELECT
    TO_CHAR(o.ORDER_DATE, 'YYYY-MM') AS SALES_MONTH,
    SUM(oi.SALES) AS TOTAL_SALES,
    SUM(oi.PROFIT) AS TOTAL_PROFIT,
    SUM(oi.QUANTITY) AS TOTAL_QUANTITY
FROM ORDERS o
JOIN ORDER_ITEMS oi
    ON o.ORDER_ID = oi.ORDER_ID
GROUP BY
    TO_CHAR(o.ORDER_DATE, 'YYYY-MM');


--tetsing the view :

    SELECT *
FROM VW_MONTHLY_SALES
ORDER BY SALES_MONTH;