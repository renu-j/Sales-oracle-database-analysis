-- analysis 

--1. top 3 products by sales within each category
--which 3 product generate teh highest sales ?
--- using teh subquery 


SELECT
    PRODUCT_ID,
    PRODUCT_NAME,
    CATEGORY,
    TOTAL_SALES,
    SALES_RANK
FROM (
    -- Rank products by total sales within each category
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
        -- Calculate total sales for each product
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
WHERE SALES_RANK <= 3-- keep only top 3 
ORDER BY CATEGORY, SALES_RANK;


2.-- ============================================================
-- A2. - CUSTOMERS ABOVE AVERAGE SALES
-- ============================================================
-- Business Question:
-- Which customers generate more sales than the average customer?
--
-- Business Purpose:
-- Identify customers who contribute above-average revenue.
-- ============================================================

WITH customer_sales AS (--temporary result set 
    SELECT
        c.CUSTOMER_ID,
        c.CUSTOMER_NAME,
        c.SEGMENT,
        ROUND(SUM(oi.SALES), 2) AS TOTAL_SALES--calculate total sales for each customer
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
    SELECT AVG(TOTAL_SALES)--calcukate average
    FROM customer_sales
)
ORDER BY TOTAL_SALES DESC;

-- ============================================================
-- A3 - SHIPPING PERFORMANCE
-- ============================================================
-- Business Question:
-- How many days does each shipping mode take on average?
--
-- SQL Concept:
-- Date arithmetic
--
-- Output:
-- Average delivery days and total orders for each
-- shipping mode.
-- ============================================================

SELECT
    o.SHIP_MODE,
    ROUND(AVG(o.SHIP_DATE - o.ORDER_DATE), 2) AS AVG_DELIVERY_DAYS,--calculates how many days an order took to ship and ist average 
    COUNT(DISTINCT o.ORDER_ID) AS TOTAL_ORDERS
FROM ORDERS o
GROUP BY
    o.SHIP_MODE
ORDER BY
    AVG_DELIVERY_DAYS;
--

-- ============================================================
-- A4. - CUSTOMER PURCHASE FREQUENCY
-- ============================================================
-- Business Question:
-- Which customers are one-time, occasional, or repeat buyers?
--
-- SQL Concepts:
-- CTE, COUNT(), CASE
--
-- Output:
-- Customer order count and purchase-frequency classification.
-- ============================================================

WITH customer_orders AS (--cte temporary result set
    SELECT
        c.CUSTOMER_ID,
        c.CUSTOMER_NAME,
        c.SEGMENT,
        COUNT(DISTINCT o.ORDER_ID) AS TOTAL_ORDERS
    FROM CUSTOMERS c
    JOIN ORDERS o
        ON c.CUSTOMER_ID = o.CUSTOMER_ID
    GROUP BY
        c.CUSTOMER_ID,
        c.CUSTOMER_NAME,
        c.SEGMENT
)
SELECT
    CUSTOMER_ID,
    CUSTOMER_NAME,
    SEGMENT,
    TOTAL_ORDERS,
    CASE
        WHEN TOTAL_ORDERS = 1 THEN 'One-Time Customer'
        WHEN TOTAL_ORDERS BETWEEN 2 AND 3 THEN 'Occasional Customer'
        ELSE 'Repeat Customer'
    END AS CUSTOMER_TYPE
FROM customer_orders--use of the cte 
ORDER BY TOTAL_ORDERS DESC;