-- ============================================================
-- PRODUCT ANALYSIS
-- ============================================================
-- Business Question:
-- Which products are generating the most sales, profit,
-- and quantity sold?

SELECT
    p.PRODUCT_ID,
    p.PRODUCT_NAME,
    p.CATEGORY,
    ROUND(SUM(oi.SALES), 2) AS TOTAL_SALES,
    ROUND(SUM(oi.PROFIT), 2) AS TOTAL_PROFIT,
    SUM(oi.QUANTITY) AS TOTAL_QUANTITY
FROM PRODUCTS p
JOIN ORDER_ITEMS oi
    ON p.PRODUCT_ID = oi.PRODUCT_ID
GROUP BY
    p.PRODUCT_ID,
    p.PRODUCT_NAME,
    p.CATEGORY
ORDER BY TOTAL_SALES DESC;