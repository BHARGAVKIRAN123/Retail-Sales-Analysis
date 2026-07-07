USE retail_sales;

-- Total Records

SELECT COUNT(*) AS customers FROM customers;

SELECT COUNT(*) AS orders FROM orders;

SELECT COUNT(*) AS order_items FROM order_items;

SELECT COUNT(*) AS products FROM products;

SELECT COUNT(*) AS payments FROM payments;

SELECT COUNT(*) AS reviews FROM reviews;

-- Null Value Check

SELECT
SUM(customer_id IS NULL) AS customer_id_null
FROM customers;

SELECT
SUM(order_purchase_timestamp IS NULL) AS purchase_null,
SUM(order_approved_at IS NULL) AS approved_null,
SUM(order_delivered_carrier_date IS NULL) AS carrier_null,
SUM(order_delivered_customer_date IS NULL) AS delivered_null,
SUM(order_estimated_delivery_date IS NULL) AS estimated_null
FROM orders;

SELECT
SUM(product_category_name IS NULL) AS category_null,
SUM(product_name_lenght IS NULL) AS name_null,
SUM(product_description_lenght IS NULL) AS description_null,
SUM(product_photos_qty IS NULL) AS photos_null,
SUM(product_weight_g IS NULL) AS weight_null,
SUM(product_length_cm IS NULL) AS length_null,
SUM(product_height_cm IS NULL) AS height_null,
SUM(product_width_cm IS NULL) AS width_null
FROM products;

-- Duplicate Check

SELECT
order_id,
order_item,
COUNT(*) AS cnt
FROM order_items
GROUP BY order_id,order_item
HAVING COUNT(*)>1;

SELECT
review_id,
COUNT(*) AS cnt
FROM reviews
GROUP BY review_id
HAVING COUNT(*)>1;

-- Foreign Key Check

SELECT
TABLE_NAME,
COLUMN_NAME,
CONSTRAINT_NAME,
REFERENCED_TABLE_NAME,
REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA='retail_sales'
AND REFERENCED_TABLE_NAME IS NOT NULL;