--anlyze monlthy sales , profit and quantuty trends 
--This query groups our sales data by month to analyze monthly sales,
-- profit, and quantity trends.

SELECT
    TO_CHAR(o.ORDER_DATE, 'YYYY-MM') AS SALES_MONTH,--orderdate into year format 
    ROUND(SUM(oi.SALES), 2) AS TOTAL_SALES,--total sales for each month 
    ROUND(SUM(oi.PROFIT), 2) AS TOTAL_PROFIT,--total profit for each month 
    SUM(oi.QUANTITY) AS TOTAL_QUANTITY--total unit s
FROM ORDERS o
JOIN ORDER_ITEMS oi
    ON o.ORDER_ID = oi.ORDER_ID
GROUP BY TO_CHAR(o.ORDER_DATE, 'YYYY-MM')
ORDER BY SALES_MONTH;