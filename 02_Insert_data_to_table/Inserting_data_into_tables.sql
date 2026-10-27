
-- inserting into the staging table from the csv superstore
INSERT INTO STG_SUPERSTORE (
    ROW_ID,
    ORDER_ID,
    ORDER_DATE,
    SHIP_DATE,
    SHIP_MODE,
    CUSTOMER_ID,
    CUSTOMER_NAME,
    SEGMENT,
    COUNTRY,
    CITY,
    STATE,
    POSTAL_CODE,
    REGION,
    PRODUCT_ID,
    CATEGORY,
    SUB_CATEGORY,
    PRODUCT_NAME,
    SALES,
    QUANTITY,
    DISCOUNT,
    PROFIT
)
SELECT
    ROW_ID,
    ORDER_ID,
    TO_DATE(ORDER_DATE, 'DD/MM/RR'),
    TO_DATE(SHIP_DATE, 'DD/MM/RR'),
    SHIP_MODE,
    CUSTOMER_ID,
    CUSTOMER_NAME,
    SEGMENT,
    COUNTRY,
    CITY,
    STATE,
    POSTAL_CODE,
    REGION,
    PRODUCT_ID,
    CATEGORY,
    SUB_CATEGORY,
    PRODUCT_NAME,
    SALES,
    QUANTITY,
    DISCOUNT,
    PROFIT
FROM SUPERSTORE
WHERE ORDER_ID IS NOT NULL
  AND CUSTOMER_ID IS NOT NULL
  AND PRODUCT_ID IS NOT NULL
  AND ORDER_DATE IS NOT NULL
  AND SHIP_DATE IS NOT NULL
  AND SALES >= 0
  AND QUANTITY > 0
  AND DISCOUNT BETWEEN 0 AND 1
  AND TO_DATE(ORDER_DATE, 'DD/MM/RR')
      <= TO_DATE(SHIP_DATE, 'DD/MM/RR');

COMMIT;


-- inserting into the customer table

MERGE INTO CUSTOMERS c
USING (
    SELECT
        CUSTOMER_ID,
        MAX(CUSTOMER_NAME) AS CUSTOMER_NAME,
        MAX(SEGMENT)       AS SEGMENT,
        MAX(COUNTRY)       AS COUNTRY,
        MAX(CITY)          AS CITY,
        MAX(STATE)         AS STATE,
        MAX(REGION)        AS REGION
    FROM STG_SUPERSTORE
    GROUP BY CUSTOMER_ID
) s
ON (c.CUSTOMER_ID = s.CUSTOMER_ID)

WHEN MATCHED THEN
    UPDATE SET
        c.CUSTOMER_NAME = s.CUSTOMER_NAME,
        c.SEGMENT       = s.SEGMENT,
        c.COUNTRY       = s.COUNTRY,
        c.CITY          = s.CITY,
        c.STATE         = s.STATE,
        c.REGION        = s.REGION

WHEN NOT MATCHED THEN
    INSERT (
        CUSTOMER_ID,
        CUSTOMER_NAME,
        SEGMENT,
        COUNTRY,
        CITY,
        STATE,
        REGION
    )
    VALUES (
        s.CUSTOMER_ID,
        s.CUSTOMER_NAME,
        s.SEGMENT,
        s.COUNTRY,
        s.CITY,
        s.STATE,
        s.REGION
    );

COMMIT;


-- inserting into the orders_table

    MERGE INTO ORDERS o
USING (
    SELECT
        ORDER_ID,
        MAX(CUSTOMER_ID) AS CUSTOMER_ID,
        MIN(ORDER_DATE)  AS ORDER_DATE,
        MAX(SHIP_DATE)   AS SHIP_DATE,
        MAX(SHIP_MODE)   AS SHIP_MODE,
        MAX(REGION)      AS REGION
    FROM STG_SUPERSTORE
    GROUP BY ORDER_ID
) s
ON (o.ORDER_ID = s.ORDER_ID)

WHEN MATCHED THEN
    UPDATE SET
        o.CUSTOMER_ID = s.CUSTOMER_ID,
        o.ORDER_DATE  = s.ORDER_DATE,
        o.SHIP_DATE   = s.SHIP_DATE,
        o.SHIP_MODE   = s.SHIP_MODE,
        o.REGION      = s.REGION

WHEN NOT MATCHED THEN
    INSERT (
        ORDER_ID,
        CUSTOMER_ID,
        ORDER_DATE,
        SHIP_DATE,
        SHIP_MODE,
        REGION
    )
    VALUES (
        s.ORDER_ID,
        s.CUSTOMER_ID,
        s.ORDER_DATE,
        s.SHIP_DATE,
        s.SHIP_MODE,
        s.REGION
    );

COMMIT;


-- insert into products table


MERGE INTO PRODUCTS p
USING (
    SELECT
        PRODUCT_ID,
        MAX(PRODUCT_NAME) AS PRODUCT_NAME,
        MAX(CATEGORY)     AS CATEGORY,
        MAX(SUB_CATEGORY) AS SUB_CATEGORY
    FROM STG_SUPERSTORE
    GROUP BY PRODUCT_ID
) s
ON (p.PRODUCT_ID = s.PRODUCT_ID)

WHEN MATCHED THEN
    UPDATE SET
        p.PRODUCT_NAME = s.PRODUCT_NAME,
        p.CATEGORY     = s.CATEGORY,
        p.SUB_CATEGORY = s.SUB_CATEGORY

WHEN NOT MATCHED THEN
    INSERT (
        PRODUCT_ID,
        PRODUCT_NAME,
        CATEGORY,
        SUB_CATEGORY
    )
    VALUES (
        s.PRODUCT_ID,
        s.PRODUCT_NAME,
        s.CATEGORY,
        s.SUB_CATEGORY
    );

COMMIT;


-- insert into order_items

--insertion into the orders_items
INSERT INTO ORDER_ITEMS (
    ORDER_ITEM_ID,
    ORDER_ID,
    PRODUCT_ID,
    QUANTITY,
    SALES,
    DISCOUNT,
    PROFIT
)
SELECT
    ROW_ID,
    ORDER_ID,
    PRODUCT_ID,
    QUANTITY,
    SALES,
    DISCOUNT,
    PROFIT
FROM STG_SUPERSTORE;

COMMIT;



