-- ============================================================
-- A7 - DISCOUNT IMPACT ANALYSIS
-- ============================================================
-- Business Question:
-- How do different discount levels relate to sales and profit?
--
-- SQL Concepts:
-- CASE, GROUP BY, SUM(), AVG()
--
-- Output:
-- Discount range, sales, profit, average discount,
-- and profit margin.
-- ============================================================

SELECT
    CASE
        WHEN DISCOUNT = 0 THEN 'No Discount'
        WHEN DISCOUNT <= 0.20 THEN 'Low Discount'
        WHEN DISCOUNT <= 0.40 THEN 'Medium Discount'
        ELSE 'High Discount'
    END AS DISCOUNT_RANGE,

    COUNT(*) AS TOTAL_ITEMS,

    ROUND(SUM(SALES), 2) AS TOTAL_SALES,

    ROUND(SUM(PROFIT), 2) AS TOTAL_PROFIT,

    ROUND(AVG(DISCOUNT) * 100, 2) AS AVG_DISCOUNT_PERCENT,

    ROUND(
        (SUM(PROFIT) / NULLIF(SUM(SALES), 0)) * 100,
        2
    ) AS PROFIT_MARGIN_PERCENT

FROM ORDER_ITEMS

GROUP BY
    CASE
        WHEN DISCOUNT = 0 THEN 'No Discount'
        WHEN DISCOUNT <= 0.20 THEN 'Low Discount'
        WHEN DISCOUNT <= 0.40 THEN 'Medium Discount'
        ELSE 'High Discount'
    END

ORDER BY
    AVG_DISCOUNT_PERCENT;