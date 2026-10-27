-- ============================================================
-- TOP 3 PRODUCTS BY SALES WITHIN EACH CATEGORY
-- ============================================================
-- Business Question:
-- For each category, which 3 products generate
-- the highest total sales?


 
SELECT
    PRODUCT_ID,
    PRODUCT_NAME,
    CATEGORY,
    TOTAL_SALES,
    SALES_RANK
FROM (
    SELECT
        PRODUCT_ID,
        PRODUCT_NAME,
        CATEGORY,
        TOTAL_SALES,
        RANK() OVER (
            PARTITION BY CATEGORY
            ORDER BY TOTAL_SALES DESC
        ) AS SALES_RANK
    FROM (
        SELECT
            p.PRODUCT_ID,
            p.PRODUCT_NAME,
            p.CATEGORY,
            ROUND(SUM(oi.SALES), 2) AS TOTAL_SALES
        FROM PRODUCTS p
        JOIN ORDER_ITEMS oi
            ON p.PRODUCT_ID = oi.PRODUCT_ID
        GROUP BY
            p.PRODUCT_ID,
            p.PRODUCT_NAME,
            p.CATEGORY
    )
)
WHERE SALES_RANK <= 3
ORDER BY
    CATEGORY,
    SALES_RANK;