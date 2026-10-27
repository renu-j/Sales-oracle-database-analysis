-- ============================================================
-- A8 - DISCOUNT VS PROFITABILITY BY CATEGORY
-- ============================================================
-- Business Question:
-- How does each discount level affect sales and profit
-- within each product category?
--
-- Output:
-- Category, Discount Range, Sales, Profit and Profit Margin.
-- ============================================================

SELECT
    p.CATEGORY,

    CASE
        WHEN oi.DISCOUNT = 0 THEN 'No Discount'
        WHEN oi.DISCOUNT <= 0.20 THEN 'Low Discount'
        WHEN oi.DISCOUNT <= 0.40 THEN 'Medium Discount'
        ELSE 'High Discount'
    END AS DISCOUNT_RANGE,

    SUM(oi.SALES) AS TOTAL_SALES,

    SUM(oi.PROFIT) AS TOTAL_PROFIT,

    (SUM(oi.PROFIT) / NULLIF(SUM(oi.SALES), 0)) * 100
        AS PROFIT_MARGIN_PERCENT

FROM ORDER_ITEMS oi

JOIN PRODUCTS p
    ON oi.PRODUCT_ID = p.PRODUCT_ID

GROUP BY
    p.CATEGORY,
    CASE
        WHEN oi.DISCOUNT = 0 THEN 'No Discount'
        WHEN oi.DISCOUNT <= 0.20 THEN 'Low Discount'
        WHEN oi.DISCOUNT <= 0.40 THEN 'Medium Discount'
        ELSE 'High Discount'
    END

ORDER BY
    p.CATEGORY,
    DISCOUNT_RANGE;