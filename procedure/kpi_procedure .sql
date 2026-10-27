-- ============================================================
-- PROCEDURE - GET SALES KPIs
-- ============================================================
-- Business Question:
-- What is the overall sales performance for a selected
-- date range?
--
-- Input:
-- Start Date and End Date
--
-- Output:
-- Total Sales
-- Total Profit
-- Total Quantity
-- Total Orders
-- Total Customers
-- Profit Margin
-- ============================================================

CREATE OR REPLACE PROCEDURE GET_SALES_KPIS (
    P_START_DATE       IN  DATE,--these are in parameter 
    P_END_DATE         IN  DATE,
    P_TOTAL_SALES      OUT NUMBER,--out parameter 
    P_TOTAL_PROFIT     OUT NUMBER,
    P_TOTAL_QUANTITY   OUT NUMBER,
    P_TOTAL_ORDERS     OUT NUMBER,
    P_TOTAL_CUSTOMERS  OUT NUMBER,
    P_PROFIT_MARGIN    OUT NUMBER
)
AS
BEGIN

    SELECT
        NVL(SUM(oi.SALES), 0),
        NVL(SUM(oi.PROFIT), 0),
        NVL(SUM(oi.QUANTITY), 0),
        COUNT(DISTINCT o.ORDER_ID),
        COUNT(DISTINCT o.CUSTOMER_ID),
        NVL(
            (SUM(oi.PROFIT) / NULLIF(SUM(oi.SALES), 0)) * 100,
            0
        )
    INTO
        P_TOTAL_SALES,
        P_TOTAL_PROFIT,
        P_TOTAL_QUANTITY,
        P_TOTAL_ORDERS,
        P_TOTAL_CUSTOMERS,
        P_PROFIT_MARGIN
    FROM ORDERS o
    JOIN ORDER_ITEMS oi
        ON o.ORDER_ID = oi.ORDER_ID
    WHERE o.ORDER_DATE BETWEEN P_START_DATE AND P_END_DATE;

END;
/


--testing the get_sales_kpis
--tetsing full availble data range 
--Execute the procedure for the full available date range
-- and display the returned KPI values.



SET SERVEROUTPUT ON;-- Enable DBMS_OUTPUT so the test results are displayed

DECLARE
    V_TOTAL_SALES      NUMBER;
    V_TOTAL_PROFIT     NUMBER;
    V_TOTAL_QUANTITY   NUMBER;
    V_TOTAL_ORDERS     NUMBER;
    V_TOTAL_CUSTOMERS  NUMBER;
    V_PROFIT_MARGIN    NUMBER;
BEGIN

    GET_SALES_KPIS(
        TO_DATE('01-01-2014', 'DD-MM-YYYY'),
        TO_DATE('31-12-2017', 'DD-MM-YYYY'),
        V_TOTAL_SALES,
        V_TOTAL_PROFIT,
        V_TOTAL_QUANTITY,
        V_TOTAL_ORDERS,
        V_TOTAL_CUSTOMERS,
        V_PROFIT_MARGIN
    );

    DBMS_OUTPUT.PUT_LINE('TOTAL SALES: ' || V_TOTAL_SALES);
    DBMS_OUTPUT.PUT_LINE('TOTAL PROFIT: ' || V_TOTAL_PROFIT);
    DBMS_OUTPUT.PUT_LINE('TOTAL QUANTITY: ' || V_TOTAL_QUANTITY);
    DBMS_OUTPUT.PUT_LINE('TOTAL ORDERS: ' || V_TOTAL_ORDERS);
    DBMS_OUTPUT.PUT_LINE('TOTAL CUSTOMERS: ' || V_TOTAL_CUSTOMERS);
    DBMS_OUTPUT.PUT_LINE('PROFIT MARGIN: ' || V_PROFIT_MARGIN || '%');

END;
/