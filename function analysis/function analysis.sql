-- ============================================================
-- FUNCTION - GET PROFIT MARGIN
-- ============================================================
-- Business Question:
-- What is the profit margin for a given sales and profit value?
--
-- Input:
-- Total Sales
-- Total Profit
--
-- Output:
-- Profit Margin Percentage
-- ============================================================

CREATE OR REPLACE FUNCTION GET_PROFIT_MARGIN (
    P_SALES  IN NUMBER,--function receive 
    P_PROFIT IN NUMBER
)
RETURN NUMBER --return type
AS
BEGIN

    RETURN NVL(
        (P_PROFIT / NULLIF(P_SALES, 0)) * 100,--calculation
        0
    );

END;
/



-- ============================================================
-- TEST GET_PROFIT_MARGIN
-- ============================================================
-- Purpose:
-- Test the function using the total sales and total profit
-- from our verified retail dataset.
-- ============================================================

SELECT
    GET_PROFIT_MARGIN(
        2297200.8603,
        286397.0217
    ) AS PROFIT_MARGIN_PERCENT
FROM DUAL;

 --Calculate profit margin using actual sales and profit
-- from the ORDER_ITEMS table.

SELECT
    GET_PROFIT_MARGIN(
        SUM(SALES),
        SUM(PROFIT)
    ) AS PROFIT_MARGIN_PERCENT
FROM ORDER_ITEMS;


---categority wise profit margin

SELECT
    p.CATEGORY,
    SUM(oi.SALES) AS TOTAL_SALES,
    SUM(oi.PROFIT) AS TOTAL_PROFIT,
    GET_PROFIT_MARGIN(
        SUM(oi.SALES),
        SUM(oi.PROFIT)
    ) AS PROFIT_MARGIN_PERCENT
FROM PRODUCTS p
JOIN ORDER_ITEMS oi
    ON p.PRODUCT_ID = oi.PRODUCT_ID
GROUP BY p.CATEGORY
ORDER BY p.CATEGORY;