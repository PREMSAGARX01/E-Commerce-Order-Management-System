-- =====================================================================
-- Project     : E-Commerce Order Management System
-- File        : ecommerce_management_final.sql
-- Description : Complete MySQL 8.0+ database project covering:
--               CRUD, clauses, operators, sorting/grouping, aggregates,
--               keys, joins, subqueries, date/time functions, string
--               functions, window functions, and CASE expressions.
-- Version     : Final exam-ready version
-- =====================================================================

-- =====================================================================
-- SECTION 0: DATABASE SETUP
-- =====================================================================
DROP DATABASE IF EXISTS ecommerce_management;
CREATE DATABASE ecommerce_management;
USE ecommerce_management;

-- =====================================================================
-- SECTION 1: SCHEMA (Tables & Relationships)
-- =====================================================================

-- 1. Categories
CREATE TABLE Categories (
    category_id   INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

-- 2. Products
CREATE TABLE Products (
    product_id     INT AUTO_INCREMENT PRIMARY KEY,
    name           VARCHAR(150) NOT NULL,
    category_id    INT,
    price          DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    stock_quantity INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    added_date     DATE NOT NULL,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

-- 3. Customers
CREATE TABLE Customers (
    customer_id       INT AUTO_INCREMENT PRIMARY KEY,
    name              VARCHAR(150) NOT NULL,
    email             VARCHAR(150),
    phone_number      VARCHAR(20),
    address           VARCHAR(255),
    registration_date DATE NOT NULL
);

-- 4. Orders
-- cancelled_date records when an order was actually cancelled.
CREATE TABLE Orders (
    order_id       INT AUTO_INCREMENT PRIMARY KEY,
    customer_id    INT NOT NULL,
    order_date     DATE NOT NULL,
    cancelled_date DATE NULL,
    total_amount   DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0),
    status         ENUM('Pending','Shipped','Delivered','Cancelled')
                   NOT NULL DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- 5. Order_Items
-- Cascading delete keeps child records consistent when an order is deleted.
CREATE TABLE Order_Items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id      INT NOT NULL,
    product_id    INT NOT NULL,
    quantity      INT NOT NULL CHECK (quantity > 0),
    subtotal      DECIMAL(10,2) NOT NULL CHECK (subtotal >= 0),
    FOREIGN KEY (order_id)
        REFERENCES Orders(order_id)
        ON DELETE CASCADE,
    FOREIGN KEY (product_id)
        REFERENCES Products(product_id)
);

-- 6. Payments
CREATE TABLE Payments (
    payment_id     INT AUTO_INCREMENT PRIMARY KEY,
    order_id       INT NOT NULL,
    payment_date   DATE,
    payment_method ENUM('Credit Card','PayPal','UPI') NOT NULL,
    payment_status ENUM('Paid','Pending','Failed') NOT NULL DEFAULT 'Pending',
    FOREIGN KEY (order_id)
        REFERENCES Orders(order_id)
        ON DELETE CASCADE
);

-- 7. Shipping
CREATE TABLE Shipping (
    shipping_id     INT AUTO_INCREMENT PRIMARY KEY,
    order_id        INT NOT NULL,
    shipping_date   DATE,
    delivery_date   DATE,
    shipping_status ENUM('Dispatched','In Transit','Delivered')
                    NOT NULL DEFAULT 'Dispatched',
    FOREIGN KEY (order_id)
        REFERENCES Orders(order_id)
        ON DELETE CASCADE
);

-- =====================================================================
-- SECTION 2: SAMPLE DATA
-- =====================================================================

INSERT INTO Categories (category_name) VALUES
('Electronics'),
('Clothing'),
('Home & Kitchen'),
('Books'),
('Sports');

INSERT INTO Products
(name, category_id, price, stock_quantity, added_date)
VALUES
('Wireless Mouse',        1, 799.00,    150, '2023-01-15'),
('Bluetooth Headphones',  1, 2499.00,   600, '2022-11-20'),
('Smartphone Stand',      1, 399.00,       0, '2023-03-10'),
('4K Monitor',            1, 18999.00,    40, '2024-01-05'),
('Men''s T-Shirt',        2, 599.00,     300, '2023-02-01'),
('Women''s Jacket',       2, 2999.00,    120, '2023-06-15'),
('Running Shoes',         5, 3499.00,    250, '2023-04-22'),
('Yoga Mat',              5, 899.00,     700, '2022-09-10'),
('Non-stick Pan Set',     3, 1799.00,     90, '2023-07-01'),
('Electric Kettle',       3, 1299.00,    550, '2022-12-05'),
('The Alchemist (Book)',  4, 299.00,    1000, '2021-05-20'),
('Atomic Habits (Book)',  4, 399.00,     800, '2022-01-15'),
('Office Chair',          3, 6999.00,     25, '2024-02-10'),
('Gaming Keyboard',       1, 3499.00,    200, '2023-11-01'),
('Cricket Bat',           5, 1599.00,     60, '2023-05-18');

INSERT INTO Customers
(name, email, phone_number, address, registration_date)
VALUES
('Aarav Sharma',    'aarav.sharma@example.com', '9876500001', 'Mumbai, MH',    '2021-03-12'),
('Priya Nair',      'priya.nair@example.com',   '9876500002', 'Kochi, KL',     '2022-07-19'),
('Rohit Verma',     NULL,                       '9876500003', 'Delhi, DL',     '2023-01-05'),
('Sneha Iyer',      'sneha.iyer@example.com',   '9876500004', 'Chennai, TN',   '2020-11-23'),
('  Karan Mehta  ', 'karan.mehta@example.com',  '9876500005', 'Ahmedabad, GJ', '2023-08-14'),
('Anjali Gupta',    NULL,                       '9876500006', 'Pune, MH',      '2022-02-28'),
('Vikram Singh',    'vikram.singh@example.com', '9876500007', 'Jaipur, RJ',    '2024-01-10'),
('Neha Reddy',      'neha.reddy@example.com',   '9876500008', 'Hyderabad, TS', '2021-09-09'),
('Arjun Das',       NULL,                       '9876500009', 'Kolkata, WB',   '2023-12-01'),
('Meera Pillai',    'meera.pillai@example.com', '9876500010', 'Bengaluru, KA', '2022-05-17');

-- Vikram Singh (customer_id = 7) intentionally has no orders.

-- ---------------------------------------------------------------------
-- Orders 1-17
-- ---------------------------------------------------------------------
INSERT INTO Orders
(customer_id, order_date, cancelled_date, total_amount, status)
VALUES
(1,  '2024-05-10', NULL,         3296.00,  'Delivered'),
(1,  '2025-02-14', NULL,        18999.00,  'Delivered'),
(2,  '2024-08-22', NULL,          899.00,  'Delivered'),
(2,  '2025-03-01', NULL,         2999.00,  'Shipped'),
(3,  '2025-06-18', NULL,          399.00,  'Pending'),
(4,  '2023-12-05', NULL,         6999.00,  'Delivered'),
(4,  '2025-01-20', '2025-01-25', 1299.00, 'Cancelled'),
(4,  '2025-07-02', NULL,         3499.00,  'Delivered'),
(5,  '2025-04-11', NULL,          599.00,  'Delivered'),
(6,  '2024-10-30', NULL,         3499.00,  'Delivered'),
(6,  '2025-05-25', NULL,         1799.00,  'Shipped'),
(8,  '2025-06-01', NULL,          299.00,  'Pending'),
(8,  '2025-07-15', NULL,          399.00,  'Delivered'),
(8,  '2025-08-05', NULL,         1599.00,  'Delivered'),
(9,  '2025-03-19', NULL,         2499.00,  'Delivered'),
(10, '2025-07-28', NULL,          799.00,  'Pending'),
(10, '2025-08-20', '2025-08-25', 2499.00, 'Cancelled');

-- Orders 18-19 demonstrate Gold and Silver loyalty branches.
INSERT INTO Orders
(customer_id, order_date, cancelled_date, total_amount, status)
VALUES
(1, '2025-09-01', NULL, 25998.00, 'Delivered'),
(4, '2025-09-05', NULL, 14995.00, 'Delivered');

-- Orders 20-21 are dedicated demonstration orders for product CASE branches.
INSERT INTO Orders
(customer_id, order_date, cancelled_date, total_amount, status)
VALUES
(6, '2025-09-08', NULL, 467480.00, 'Delivered'),
(2, '2025-09-10', NULL, 874750.00, 'Delivered');

-- ---------------------------------------------------------------------
-- Order items
-- ---------------------------------------------------------------------
INSERT INTO Order_Items
(order_id, product_id, quantity, subtotal)
VALUES
(1,  1, 1,   799.00),
(1,  5, 1,   599.00),
(1,  8, 2,  1798.00),
(2,  4, 1, 18999.00),
(3,  8, 1,   899.00),
(4,  6, 1,  2999.00),
(5,  3, 1,   399.00),
(6, 13, 1,  6999.00),
(7, 10, 1,  1299.00),
(8, 14, 1,  3499.00),
(9,  5, 1,   599.00),
(10,14, 1,  3499.00),
(11, 9, 1,  1799.00),
(12,11, 1,   299.00),
(13,12, 1,   399.00),
(14,15, 1,  1599.00),
(15, 2, 1,  2499.00),
(16, 1, 1,   799.00),
(17, 2, 1,  2499.00),
(18,13, 1,  6999.00),
(18, 4, 1, 18999.00),
(19, 6, 5, 14995.00),
(20, 8, 520, 467480.00),
(21, 7, 250, 874750.00);

-- All order totals now match their line-item subtotals.
UPDATE Orders o
JOIN (
    SELECT order_id, SUM(subtotal) AS items_total
    FROM Order_Items
    GROUP BY order_id
) t ON t.order_id = o.order_id
SET o.total_amount = t.items_total;

-- ---------------------------------------------------------------------
-- Payments
-- ---------------------------------------------------------------------
INSERT INTO Payments
(order_id, payment_date, payment_method, payment_status)
VALUES
(1,  '2024-05-10', 'Credit Card', 'Paid'),
(2,  '2025-02-14', 'UPI',         'Paid'),
(3,  '2024-08-22', 'PayPal',      'Paid'),
(4,  '2025-03-01', 'Credit Card', 'Paid'),
(5,  '2025-06-18', 'UPI',         'Paid'),
(6,  '2023-12-05', 'Credit Card', 'Paid'),
(7,  '2025-01-20', 'PayPal',      'Failed'),
(8,  '2025-07-02', 'UPI',         'Paid'),
(9,  '2025-04-11', 'Credit Card', 'Paid'),
(10, '2024-10-30', 'UPI',         'Paid'),
(11, '2025-05-25', 'Credit Card', 'Pending'),
(12, '2025-06-01', 'PayPal',      'Paid'),
(13, '2025-07-15', 'UPI',         'Paid'),
(14, '2025-08-05', 'Credit Card', 'Paid'),
(15, '2025-03-19', 'UPI',         'Paid'),
(16, '2025-07-28', 'PayPal',      'Pending'),
(17, '2025-08-20', 'Credit Card', 'Failed'),
(18, '2025-09-01', 'Credit Card', 'Paid'),
(19, '2025-09-05', 'UPI',         'Paid'),
(20, '2025-09-08', 'Credit Card', 'Paid'),
(21, '2025-09-10', 'UPI',         'Paid');

-- ---------------------------------------------------------------------
-- Shipping
-- ---------------------------------------------------------------------
INSERT INTO Shipping
(order_id, shipping_date, delivery_date, shipping_status)
VALUES
(1,  '2024-05-11', '2024-05-14', 'Delivered'),
(2,  '2025-02-15', '2025-02-19', 'Delivered'),
(3,  '2024-08-23', '2024-08-26', 'Delivered'),
(4,  '2025-03-02', NULL,         'In Transit'),
(6,  '2023-12-06', '2023-12-10', 'Delivered'),
(8,  '2025-07-03', '2025-07-07', 'Delivered'),
(9,  '2025-04-12', '2025-04-15', 'Delivered'),
(10, '2024-10-31', '2024-11-03', 'Delivered'),
(11, '2025-05-26', NULL,         'Dispatched'),
(13, '2025-07-16', '2025-07-19', 'Delivered'),
(14, '2025-08-06', '2025-08-09', 'Delivered'),
(15, '2025-03-20', '2025-03-24', 'Delivered');

-- =====================================================================
-- SECTION 3: TASK 2 - SQL CLAUSES (WHERE, HAVING, LIMIT)
-- =====================================================================

-- 3.1 Orders placed in the last 6 months
SELECT *
FROM Orders
WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

-- 3.2 Top 5 highest-priced products
SELECT product_id, name, price
FROM Products
ORDER BY price DESC
LIMIT 5;

-- 3.3 Customers who have placed more than 3 orders
SELECT c.customer_id,
       c.name,
       COUNT(o.order_id) AS total_orders
FROM Customers c
JOIN Orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
HAVING COUNT(o.order_id) > 3;

-- =====================================================================
-- SECTION 4: TASK 3 - SQL OPERATORS (AND, OR, NOT)
-- =====================================================================

-- 4.1 Pending orders whose payment is Paid
SELECT o.order_id,
       o.status,
       p.payment_status
FROM Orders o
JOIN Payments p ON p.order_id = o.order_id
WHERE o.status = 'Pending'
  AND p.payment_status = 'Paid';

-- 4.2 Products that are NOT out of stock
SELECT product_id,
       name,
       stock_quantity
FROM Products
WHERE NOT stock_quantity = 0;

-- 4.3 Customers registered after 2022 OR having an order above 10000
SELECT DISTINCT c.customer_id,
       c.name,
       c.registration_date
FROM Customers c
LEFT JOIN Orders o ON o.customer_id = c.customer_id
WHERE c.registration_date > '2022-12-31'
   OR o.total_amount > 10000;

-- =====================================================================
-- SECTION 5: TASK 4 - SORTING & GROUPING
-- =====================================================================

-- 5.1 All products sorted by price descending
SELECT product_id,
       name,
       price
FROM Products
ORDER BY price DESC;

-- 5.2 Number of orders placed by each customer
SELECT c.customer_id,
       c.name,
       COUNT(o.order_id) AS order_count
FROM Customers c
LEFT JOIN Orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY order_count DESC;

-- 5.3 Total revenue generated per category
-- Cancelled order items are excluded from revenue.
SELECT cat.category_id,
       cat.category_name,
       COALESCE(SUM(
           CASE
               WHEN o.status <> 'Cancelled' THEN oi.subtotal
               ELSE 0
           END
       ), 0) AS total_revenue
FROM Categories cat
LEFT JOIN Products p
    ON p.category_id = cat.category_id
LEFT JOIN Order_Items oi
    ON oi.product_id = p.product_id
LEFT JOIN Orders o
    ON o.order_id = oi.order_id
GROUP BY cat.category_id, cat.category_name
ORDER BY total_revenue DESC;

-- =====================================================================
-- SECTION 6: TASK 5 - AGGREGATE FUNCTIONS
-- =====================================================================

-- 6.1 Total revenue generated by the store
SELECT SUM(total_amount) AS total_revenue
FROM Orders
WHERE status <> 'Cancelled';

-- 6.2 Most purchased product by total quantity sold
SELECT p.product_id,
       p.name,
       SUM(oi.quantity) AS total_quantity_sold
FROM Order_Items oi
JOIN Products p ON p.product_id = oi.product_id
JOIN Orders o ON o.order_id = oi.order_id
WHERE o.status <> 'Cancelled'
GROUP BY p.product_id, p.name
ORDER BY total_quantity_sold DESC
LIMIT 1;

-- 6.3 Average order value
SELECT AVG(total_amount) AS average_order_value
FROM Orders
WHERE status <> 'Cancelled';

-- Bonus: MAX, MIN and COUNT together
SELECT MAX(total_amount) AS highest_order_value,
       MIN(total_amount) AS lowest_order_value,
       COUNT(*) AS total_orders
FROM Orders;

-- =====================================================================
-- SECTION 7: TASK 6 - PRIMARY & FOREIGN KEY RELATIONSHIPS
-- =====================================================================
-- Primary keys:
--   Categories.category_id
--   Products.product_id
--   Customers.customer_id
--   Orders.order_id
--   Order_Items.order_item_id
--   Payments.payment_id
--   Shipping.shipping_id
--
-- Foreign keys:
--   Products.category_id -> Categories.category_id
--   Orders.customer_id -> Customers.customer_id
--   Order_Items.order_id -> Orders.order_id (CASCADE DELETE)
--   Order_Items.product_id -> Products.product_id
--   Payments.order_id -> Orders.order_id (CASCADE DELETE)
--   Shipping.order_id -> Orders.order_id (CASCADE DELETE)

-- =====================================================================
-- SECTION 8: TASK 7 - JOINS
-- =====================================================================

-- 8.1 INNER JOIN: products with category names
SELECT p.product_id,
       p.name,
       c.category_name
FROM Products p
INNER JOIN Categories c
    ON p.category_id = c.category_id;

-- 8.2 LEFT JOIN: all orders with customer details
SELECT o.order_id,
       o.order_date,
       o.total_amount,
       o.status,
       c.customer_id,
       c.name AS customer_name,
       c.email
FROM Orders o
LEFT JOIN Customers c
    ON o.customer_id = c.customer_id;

-- 8.3 RIGHT JOIN: orders that have no Shipping row
SELECT o.order_id,
       o.status,
       s.shipping_id,
       s.shipping_status
FROM Shipping s
RIGHT JOIN Orders o
    ON s.order_id = o.order_id
WHERE s.shipping_id IS NULL;

-- 8.4 FULL OUTER JOIN simulation.
-- MySQL has no native FULL OUTER JOIN, so LEFT JOIN + RIGHT JOIN
-- are combined using UNION.
SELECT c.customer_id,
       c.name,
       o.order_id
FROM Customers c
LEFT JOIN Orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL

UNION

SELECT c.customer_id,
       c.name,
       o.order_id
FROM Customers c
RIGHT JOIN Orders o
    ON c.customer_id = o.customer_id
WHERE c.customer_id IS NULL;

-- =====================================================================
-- SECTION 9: TASK 8 - SUBQUERIES
-- =====================================================================

-- 9.1 Orders placed by customers who registered after 2022
SELECT *
FROM Orders
WHERE customer_id IN (
    SELECT customer_id
    FROM Customers
    WHERE registration_date > '2022-12-31'
);

-- 9.2 Customer(s) who have spent the most
SELECT customer_id,
       name,
       total_spent
FROM (
    SELECT c.customer_id,
           c.name,
           SUM(o.total_amount) AS total_spent
    FROM Customers c
    JOIN Orders o
        ON o.customer_id = c.customer_id
    WHERE o.status <> 'Cancelled'
    GROUP BY c.customer_id, c.name
) AS spending
WHERE total_spent = (
    SELECT MAX(total_spent)
    FROM (
        SELECT customer_id,
               SUM(total_amount) AS total_spent
        FROM Orders
        WHERE status <> 'Cancelled'
        GROUP BY customer_id
    ) AS t
);

-- 9.3 Products that have never been ordered
SELECT p.product_id,
       p.name
FROM Products p
WHERE NOT EXISTS (
    SELECT 1
    FROM Order_Items oi
    WHERE oi.product_id = p.product_id
);

-- =====================================================================
-- SECTION 10: TASK 9 - DATE & TIME FUNCTIONS
-- =====================================================================

-- 10.1 Count orders by year-month
SELECT DATE_FORMAT(order_date, '%Y-%m') AS order_year_month,
       COUNT(*) AS orders_count
FROM Orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY order_year_month;

-- 10.2 Delivery time in days
SELECT shipping_id,
       order_id,
       shipping_date,
       delivery_date,
       DATEDIFF(delivery_date, shipping_date) AS delivery_time_days
FROM Shipping
WHERE delivery_date IS NOT NULL;

-- 10.3 Format order date as DD-MM-YYYY
SELECT order_id,
       DATE_FORMAT(order_date, '%d-%m-%Y') AS formatted_order_date
FROM Orders;

-- =====================================================================
-- SECTION 11: TASK 10 - STRING MANIPULATION FUNCTIONS
-- =====================================================================

-- 11.1 Convert product names to uppercase
SELECT product_id,
       UPPER(name) AS product_name_upper
FROM Products;

-- 11.2 Trim whitespace from customer names
SELECT customer_id,
       TRIM(name) AS trimmed_name
FROM Customers;

-- 11.3 Replace missing emails
SELECT customer_id,
       name,
       COALESCE(email, 'Not Provided') AS email
FROM Customers;

-- =====================================================================
-- SECTION 12: TASK 11 - WINDOW FUNCTIONS
-- =====================================================================

-- 12.1 Rank customers based on total spending
SELECT customer_id,
       name,
       total_spent,
       RANK() OVER (ORDER BY total_spent DESC) AS spending_rank
FROM (
    SELECT c.customer_id,
           c.name,
           COALESCE(SUM(o.total_amount), 0) AS total_spent
    FROM Customers c
    LEFT JOIN Orders o
        ON o.customer_id = c.customer_id
       AND o.status <> 'Cancelled'
    GROUP BY c.customer_id, c.name
) AS spending;

-- 12.2 Cumulative total revenue per month
SELECT order_month,
       monthly_revenue,
       SUM(monthly_revenue) OVER (ORDER BY order_month) AS cumulative_revenue
FROM (
    SELECT DATE_FORMAT(order_date, '%Y-%m') AS order_month,
           SUM(total_amount) AS monthly_revenue
    FROM Orders
    WHERE status <> 'Cancelled'
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
) AS monthly
ORDER BY order_month;

-- 12.3 Running total of orders placed
SELECT order_id,
       customer_id,
       order_date,
       total_amount,
       COUNT(*) OVER (
           ORDER BY order_date, order_id
       ) AS running_order_count
FROM Orders
ORDER BY order_date, order_id;

-- =====================================================================
-- SECTION 13: TASK 12 - SQL CASE EXPRESSIONS
-- =====================================================================

-- 13.1 Loyalty status based on total spending
SELECT c.customer_id,
       c.name,
       COALESCE(SUM(o.total_amount), 0) AS total_spent,
       CASE
           WHEN COALESCE(SUM(o.total_amount), 0) > 50000
               THEN 'Gold'
           WHEN COALESCE(SUM(o.total_amount), 0) BETWEEN 20000 AND 50000
               THEN 'Silver'
           ELSE 'Bronze'
       END AS Loyalty_Status
FROM Customers c
LEFT JOIN Orders o
    ON o.customer_id = c.customer_id
   AND o.status <> 'Cancelled'
GROUP BY c.customer_id, c.name;

-- 13.2 Product category based on units sold
-- Cancelled-order quantities are excluded.
SELECT p.product_id,
       p.name,
       COALESCE(SUM(
           CASE
               WHEN o.status <> 'Cancelled' THEN oi.quantity
               ELSE 0
           END
       ), 0) AS units_sold,
       CASE
           WHEN COALESCE(SUM(
               CASE
                   WHEN o.status <> 'Cancelled' THEN oi.quantity
                   ELSE 0
               END
           ), 0) > 500
               THEN 'Best Seller'
           WHEN COALESCE(SUM(
               CASE
                   WHEN o.status <> 'Cancelled' THEN oi.quantity
                   ELSE 0
               END
           ), 0) BETWEEN 200 AND 500
               THEN 'Popular'
           ELSE 'Regular'
       END AS product_category
FROM Products p
LEFT JOIN Order_Items oi
    ON oi.product_id = p.product_id
LEFT JOIN Orders o
    ON o.order_id = oi.order_id
GROUP BY p.product_id, p.name;

-- =====================================================================
-- SECTION 14: TASK 1 - CRUD OPERATIONS
-- =====================================================================

-- 14.1 CREATE: Insert a new product
INSERT INTO Products
(name, category_id, price, stock_quantity, added_date)
VALUES
('Wireless Earbuds', 1, 1999.00, 300, CURDATE());

SET @new_product_id = LAST_INSERT_ID();

-- 14.2 CREATE: Insert a new customer
INSERT INTO Customers
(name, email, phone_number, address, registration_date)
VALUES
('Ishaan Kapoor',
 'ishaan.kapoor@example.com',
 '9876500011',
 'Nagpur, MH',
 CURDATE());

SET @new_customer_id = LAST_INSERT_ID();

-- 14.3 CREATE: Insert an order for the newly created customer
INSERT INTO Orders
(customer_id, order_date, total_amount, status)
VALUES
(@new_customer_id, CURDATE(), 1999.00, 'Pending');

-- 14.4 UPDATE: Deduct stock for the ordered product
UPDATE Products
SET stock_quantity = stock_quantity - 1
WHERE product_id = @new_product_id;

-- 14.5 DELETE: Delete cancelled orders older than 30 days.
-- Child Order_Items, Payments and Shipping rows are automatically
-- removed because their foreign keys use ON DELETE CASCADE.
DELETE FROM Orders
WHERE status = 'Cancelled'
  AND cancelled_date IS NOT NULL
  AND cancelled_date < DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- =====================================================================
-- END OF SCRIPT
-- =====================================================================
