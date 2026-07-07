USE retail_sales;

-- ===========================================================
-- Q1. Total Revenue
-- ===========================================================

SELECT ROUND(SUM(price),2) AS total_revenue
FROM order_items;

-- ===========================================================
-- Q2. Total Orders
-- ===========================================================

SELECT COUNT(*) AS total_orders
FROM orders;

-- ===========================================================
-- Q3. Total Customers
-- ===========================================================

SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM customers;

-- ===========================================================
-- Q4. Average Order Value
-- ===========================================================

WITH temp AS
(
    SELECT order_id,
           SUM(price) AS total_price
    FROM order_items
    GROUP BY order_id
)
SELECT ROUND(AVG(total_price),2) AS average_order_value
FROM temp;

-- ===========================================================
-- Q5. Top 10 Products by Revenue
-- ===========================================================

SELECT
    product_id,
    ROUND(SUM(price),2) AS total_revenue
FROM order_items
GROUP BY product_id
ORDER BY total_revenue DESC
LIMIT 10;

-- ===========================================================
-- Q6. Top 10 Customers by Spending
-- ===========================================================

SELECT
    c.customer_id,
    ROUND(SUM(oi.price),2) AS total_spending
FROM customers c
INNER JOIN orders o
ON c.customer_id=o.customer_id
INNER JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY c.customer_id
ORDER BY total_spending DESC
LIMIT 10;

-- ===========================================================
-- Q7. Revenue by State
-- ===========================================================

SELECT
    c.customer_state,
    ROUND(SUM(oi.price),2) AS total_revenue
FROM customers c
INNER JOIN orders o
ON c.customer_id=o.customer_id
INNER JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC;

-- ===========================================================
-- Q8. Monthly Revenue Trend
-- ===========================================================

SELECT
    DATE_FORMAT(o.order_purchase_timestamp,'%Y-%m') AS month,
    ROUND(SUM(oi.price),2) AS total_revenue
FROM orders o
INNER JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY month
ORDER BY month;

-- ===========================================================
-- Q9. Top 5 Product Categories by Revenue
-- ===========================================================

SELECT
    p.product_category_name,
    ROUND(SUM(oi.price),2) AS total_revenue
FROM products p
INNER JOIN order_items oi
ON p.product_id=oi.product_id
GROUP BY p.product_category_name
ORDER BY total_revenue DESC
LIMIT 5;

-- ===========================================================
-- Q10. Average Delivery Time
-- ===========================================================

SELECT
ROUND(
AVG(DATEDIFF(order_delivered_customer_date,
order_purchase_timestamp)),2
) AS average_delivery_time
FROM orders
WHERE order_status='delivered';

-- ===========================================================
-- Q11. Top 5 Customers by Number of Orders
-- ===========================================================

SELECT
customer_id,
COUNT(order_id) AS no_of_orders
FROM orders
GROUP BY customer_id
ORDER BY no_of_orders DESC
LIMIT 5;

-- ===========================================================
-- Q12. Customers Who Never Placed an Order
-- ===========================================================

SELECT
c.customer_id
FROM customers c
LEFT JOIN orders o
ON c.customer_id=o.customer_id
WHERE o.order_id IS NULL;

-- ===========================================================
-- Q13. Orders Having More Than One Product
-- ===========================================================

SELECT
order_id,
COUNT(product_id) AS total_products
FROM order_items
GROUP BY order_id
HAVING COUNT(product_id)>1;

-- ===========================================================
-- Q14. Top 3 Customers in Each State by Spending
-- ===========================================================

WITH temp AS
(
SELECT
c.customer_id,
c.customer_state,
SUM(oi.price) AS total_spending,
DENSE_RANK() OVER
(
PARTITION BY c.customer_state
ORDER BY SUM(oi.price) DESC
) AS dns
FROM customers c
INNER JOIN orders o
ON c.customer_id=o.customer_id
INNER JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY
c.customer_id,
c.customer_state
)

SELECT *
FROM temp
WHERE dns<=3;

-- ===========================================================
-- Q15. Top 3 Products in Each Month by Revenue
-- ===========================================================

WITH temp AS
(
SELECT
p.product_id,
p.product_category_name,
DATE_FORMAT(o.order_purchase_timestamp,'%Y-%m') AS months,
SUM(oi.price) AS revenue,
DENSE_RANK() OVER
(
PARTITION BY DATE_FORMAT(o.order_purchase_timestamp,'%Y-%m')
ORDER BY SUM(oi.price) DESC
) AS dns
FROM orders o
INNER JOIN order_items oi
ON o.order_id=oi.order_id
INNER JOIN products p
ON oi.product_id=p.product_id
GROUP BY
p.product_id,
p.product_category_name,
months
)

SELECT *
FROM temp
WHERE dns<=3;

-- ===========================================================
-- Q16. Customer Lifetime Value (CLV)
-- ===========================================================

SELECT
c.customer_id,
ROUND(SUM(oi.price),2) AS clv
FROM customers c
INNER JOIN orders o
ON c.customer_id=o.customer_id
INNER JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY c.customer_id
ORDER BY clv DESC;

-- ===========================================================
-- Q17. Month-over-Month Revenue Growth
-- ===========================================================

WITH temp AS
(
SELECT
DATE_FORMAT(o.order_purchase_timestamp,'%Y-%m') AS months,
SUM(oi.price) AS total_revenue
FROM orders o
INNER JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY months
)

SELECT
months,
total_revenue,
LAG(total_revenue)
OVER(ORDER BY months) AS previous_month_revenue,
ROUND(
total_revenue-
LAG(total_revenue)
OVER(ORDER BY months),2
) AS revenue_growth
FROM temp;

-- ===========================================================
-- Q18. Running Monthly Revenue
-- ===========================================================

WITH temp AS
(
SELECT
DATE_FORMAT(o.order_purchase_timestamp,'%Y-%m') AS months,
SUM(oi.price) AS revenue
FROM orders o
INNER JOIN order_items oi
ON o.order_id=oi.order_id
GROUP BY months
)

SELECT
months,
revenue,
SUM(revenue)
OVER(ORDER BY months) AS running_total
FROM temp;