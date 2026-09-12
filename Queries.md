# E-Commerce Order Management System — SQL Queries & Expected Outputs

This document contains the SQL query/code and the expected output for the analytical queries in the project. Outputs are based on the sample data before the final CRUD/delete section is executed.

> **Important:** Queries using `CURDATE()` can vary depending on the date on which they are executed.

---

## Task 2 — SQL Clauses

### 2.1 Orders placed in the last 6 months

**SQL Query**
```sql
SELECT *
FROM Orders
WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);
```

**Expected Output**
The result depends on the current date because the query uses `CURDATE()`. When the script was prepared with the sample order dates, it returns orders whose `order_date` falls within the previous six months.

---

### 2.2 Top 5 highest-priced products

**SQL Query**
```sql
SELECT product_id, name, price
FROM Products
ORDER BY price DESC
LIMIT 5;
```

**Expected Output**
```text
product_id | name                 | price
-----------+----------------------+--------
4          | 4K Monitor           | 18999
13         | Office Chair         | 6999
7          | Running Shoes        | 3499
14         | Gaming Keyboard      | 3499
6          | Women's Jacket       | 2999
```

---

### 2.3 Customers who placed more than 3 orders

**SQL Query**
```sql
SELECT c.customer_id, c.name, COUNT(o.order_id) AS total_orders
FROM Customers c
JOIN Orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
HAVING COUNT(o.order_id) > 3;
```

**Expected Output**
```text
customer_id | name        | total_orders
------------+-------------+-------------
4           | Sneha Iyer  | 4
```

---

## Task 3 — SQL Operators

### 3.1 Pending orders whose payment is Paid

**SQL Query**
```sql
SELECT o.order_id, o.status, p.payment_status
FROM Orders o
JOIN Payments p ON p.order_id = o.order_id
WHERE o.status = 'Pending'
  AND p.payment_status = 'Paid';
```

**Expected Output**
```text
order_id | status  | payment_status
---------+---------+---------------
5        | Pending | Paid
12       | Pending | Paid
```

---

### 3.2 Products NOT out of stock

**SQL Query**
```sql
SELECT product_id, name, stock_quantity
FROM Products
WHERE NOT stock_quantity = 0;
```

**Expected Output**
14 rows: every original product except product 3, `Smartphone Stand`, whose stock is 0.

---

### 3.3 Customers registered after 2022 OR having an order above 10000

**SQL Query**
```sql
SELECT DISTINCT c.customer_id, c.name, c.registration_date
FROM Customers c
LEFT JOIN Orders o ON o.customer_id = c.customer_id
WHERE c.registration_date > '2022-12-31'
   OR o.total_amount > 10000;
```

**Expected Output**
```text
customer_id | name          | registration_date
------------+---------------+-----------------
1           | Aarav Sharma  | 2021-03-12
2           | Priya Nair    | 2022-07-19
3           | Rohit Verma   | 2023-01-05
4           | Sneha Iyer    | 2020-11-23
5           | Karan Mehta   | 2023-08-14
6           | Anjali Gupta  | 2022-02-28
7           | Vikram Singh  | 2024-01-10
9           | Arjun Das     | 2023-12-01
```

---

## Task 4 — Sorting & Grouping

### 4.1 Products sorted by price descending

**SQL Query**
```sql
SELECT product_id, name, price
FROM Products
ORDER BY price DESC;
```

**Expected Output**
```text
4  | 4K Monitor           | 18999
13 | Office Chair         | 6999
7  | Running Shoes        | 3499
14 | Gaming Keyboard      | 3499
6  | Women's Jacket       | 2999
2  | Bluetooth Headphones | 2499
9  | Non-stick Pan Set    | 1799
15 | Cricket Bat          | 1599
10 | Electric Kettle      | 1299
8  | Yoga Mat             | 899
1  | Wireless Mouse       | 799
5  | Men's T-Shirt        | 599
3  | Smartphone Stand     | 399
12 | Atomic Habits (Book) | 399
11 | The Alchemist (Book) | 299
```

---

### 4.2 Order count per customer

**SQL Query**
```sql
SELECT c.customer_id, c.name, COUNT(o.order_id) AS total_orders
FROM Customers c
LEFT JOIN Orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_orders DESC;
```

**Expected Output**
```text
customer_id | name          | total_orders
------------+---------------+-------------
4           | Sneha Iyer    | 4
1           | Aarav Sharma  | 3
2           | Priya Nair    | 3
6           | Anjali Gupta  | 3
8           | Neha Reddy    | 3
10          | Meera Pillai  | 2
3           | Rohit Verma   | 1
5           | Karan Mehta   | 1
9           | Arjun Das     | 1
7           | Vikram Singh  | 0
```

Customers tied at the same count may appear in a different order because no secondary sort is specified.

---

### 4.3 Revenue by category excluding cancelled orders

**SQL Query**
```sql
SELECT c.category_name,
       SUM(oi.subtotal) AS category_revenue
FROM Categories c
JOIN Products p ON p.category_id = c.category_id
JOIN Order_Items oi ON oi.product_id = p.product_id
JOIN Orders o ON o.order_id = oi.order_id
WHERE o.status <> 'Cancelled'
GROUP BY c.category_id, c.category_name
ORDER BY category_revenue DESC;
```

**Expected Output**
```text
category_name    | category_revenue
-----------------+-----------------
Sports           | 1346526
Electronics      | 49492
Clothing         | 19192
Home & Kitchen   | 15797
Books            | 698
```

---

## Task 5 — Aggregate Functions

### 5.1 Total revenue excluding cancelled orders

**SQL Query**
```sql
SELECT SUM(total_amount) AS total_revenue
FROM Orders
WHERE status <> 'Cancelled';
```

**Expected Output**
```text
total_revenue
-------------
1431705
```

---

### 5.2 Most purchased product

**SQL Query**
```sql
SELECT p.product_id, p.name, SUM(oi.quantity) AS total_units_sold
FROM Products p
JOIN Order_Items oi ON oi.product_id = p.product_id
JOIN Orders o ON o.order_id = oi.order_id
WHERE o.status <> 'Cancelled'
GROUP BY p.product_id, p.name
ORDER BY total_units_sold DESC
LIMIT 1;
```

**Expected Output**
```text
product_id | name     | total_units_sold
-----------+----------+-----------------
8          | Yoga Mat | 523
```

---

### 5.3 Average order value excluding cancelled orders

**SQL Query**
```sql
SELECT AVG(total_amount) AS average_order_value
FROM Orders
WHERE status <> 'Cancelled';
```

**Expected Output**
```text
average_order_value
-------------------
75353.947368...
```

There are 19 non-cancelled orders, so the calculation is `1431705 / 19`.

---

### Bonus aggregate query

**SQL Query**
```sql
SELECT MAX(total_amount) AS highest_order,
       MIN(total_amount) AS lowest_order,
       COUNT(*) AS total_orders
FROM Orders;
```

**Expected Output**
```text
highest_order | lowest_order | total_orders
--------------+--------------+-------------
874750        | 299          | 21
```

---

## Task 6 — Primary Key / Foreign Key Relationships

This section is demonstrated through the table definitions and foreign-key constraints in the schema.

**Key relationships**
```text
Categories 1 ────< Products
Customers  1 ────< Orders
Orders     1 ────< Order_Items
Products   1 ────< Order_Items
Orders     1 ────< Payments
Orders     1 ────< Shipping
```

`Order_Items`, `Payments`, and `Shipping` reference `Orders`. The `Orders` → `Order_Items`, `Payments`, and `Shipping` relationships use `ON DELETE CASCADE` where defined in the SQL script.

---

## Task 7 — Joins

### 7.1 Inner join: Orders with customer names

**SQL Query**
```sql
SELECT o.order_id, c.name, o.order_date, o.total_amount, o.status
FROM Orders o
JOIN Customers c ON c.customer_id = o.customer_id;
```

**Expected Output**
21 rows — one row for each sample order, with the corresponding customer name.

---

### 7.2 Left join: Customers and their orders

**SQL Query**
```sql
SELECT c.customer_id, c.name, o.order_id, o.total_amount
FROM Customers c
LEFT JOIN Orders o ON o.customer_id = c.customer_id;
```

**Expected Output**
22 rows because customer 7 has no order and therefore contributes one NULL-order row.

---

### 7.3 Orders without shipping records

**SQL Query**
```sql
SELECT o.order_id, o.status
FROM Orders o
LEFT JOIN Shipping s ON s.order_id = o.order_id
WHERE s.order_id IS NULL;
```

**Expected Output**
```text
5
7
12
16
17
18
19
20
21
```

---

### 7.4 Full outer join demonstration

**SQL Query**
```sql
SELECT c.customer_id, c.name, o.order_id
FROM Customers c
LEFT JOIN Orders o ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL

UNION

SELECT c.customer_id, c.name, o.order_id
FROM Customers c
RIGHT JOIN Orders o ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
```

**Expected Output**
```text
customer_id | name         | order_id
------------+--------------+---------
7           | Vikram Singh | NULL
```

This particular query returns the unmatched rows, rather than all rows of a conventional FULL OUTER JOIN.

---

## Task 8 — Subqueries

### 8.1 Orders by customers registered after 2022

**SQL Query**
```sql
SELECT *
FROM Orders
WHERE customer_id IN (
    SELECT customer_id
    FROM Customers
    WHERE registration_date > '2022-12-31'
);
```

**Expected Order IDs**
```text
5
9
15
```

These belong to customers 3, 5, and 9. Customer 7 also registered after 2022 but has no orders.

---

### 8.2 Customer with the highest spending excluding cancelled orders

**SQL Query**
```sql
SELECT c.customer_id, c.name, SUM(o.total_amount) AS total_spent
FROM Customers c
JOIN Orders o ON o.customer_id = c.customer_id
WHERE o.status <> 'Cancelled'
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC
LIMIT 1;
```

**Expected Output**
```text
customer_id | name       | total_spent
------------+------------+------------
2           | Priya Nair | 878648
```

---

### 8.3 Products never ordered

**SQL Query**
```sql
SELECT p.product_id, p.name
FROM Products p
WHERE NOT EXISTS (
    SELECT 1
    FROM Order_Items oi
    WHERE oi.product_id = p.product_id
);
```

**Expected Output**
```text
0 rows
```

All 15 original products appear in at least one `Order_Items` row. This query does not exclude cancelled orders, so the Electric Kettle still counts as ordered through order 7.

---

## Task 9 — Date & Time Functions

### 9.1 Orders grouped by year and month

**SQL Query**
```sql
SELECT YEAR(order_date) AS order_year,
       MONTH(order_date) AS order_month,
       COUNT(*) AS total_orders
FROM Orders
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY order_year, order_month;
```

**Expected Output**
```text
2023-12 | 1
2024-05 | 1
2024-08 | 1
2024-10 | 1
2025-01 | 1
2025-02 | 1
2025-03 | 2
2025-04 | 1
2025-05 | 1
2025-06 | 2
2025-07 | 3
2025-08 | 2
2025-09 | 4
```

---

### 9.2 Delivery time in days

**SQL Query**
```sql
SELECT o.order_id,
       DATEDIFF(s.delivery_date, o.order_date) AS delivery_days
FROM Orders o
JOIN Shipping s ON s.order_id = o.order_id
WHERE s.delivery_date IS NOT NULL;
```

**Expected Output**
```text
order_id | delivery_days
---------+--------------
1        | 3
2        | 4
3        | 3
6        | 4
8        | 4
9        | 3
10       | 3
13       | 3
14       | 3
15       | 4
```

---

### 9.3 Date formatting example

**SQL Query**
```sql
SELECT order_id,
       DATE_FORMAT(order_date, '%d-%m-%Y') AS formatted_order_date
FROM Orders;
```

**Expected Output**
Dates are displayed in `DD-MM-YYYY` format, for example:
```text
order_id | formatted_order_date
---------+---------------------
1        | 10-05-2024
2        | 14-02-2025
3        | 22-08-2024
...
```

---

## Task 10 — String Functions

### 10.1 Convert product names to uppercase

**SQL Query**
```sql
SELECT product_id, UPPER(name) AS product_name_upper
FROM Products;
```

**Expected Output**
15 rows, with product names converted to uppercase.

Example:
```text
1 | WIRELESS MOUSE
2 | BLUETOOTH HEADPHONES
3 | SMARTPHONE STAND
4 | 4K MONITOR
...
```

---

### 10.2 Trim customer names

**SQL Query**
```sql
SELECT customer_id, TRIM(name) AS cleaned_name
FROM Customers;
```

**Expected Output**
```text
customer_id | cleaned_name
------------+--------------
5           | Karan Mehta
```

For customer 5, the leading/trailing spaces in the stored name are removed.

---

### 10.3 Replace missing emails

**SQL Query**
```sql
SELECT customer_id,
       name,
       COALESCE(email, 'Not Provided') AS email
FROM Customers;
```

**Expected Output**
Customers with missing email values display:
```text
3 | Rohit Verma  | Not Provided
6 | Anjali Gupta | Not Provided
9 | Arjun Das    | Not Provided
```

---

## Task 11 — Window Functions

### 11.1 Rank customers by spending

**SQL Query**
```sql
SELECT c.customer_id,
       c.name,
       COALESCE(SUM(CASE WHEN o.status <> 'Cancelled'
                         THEN o.total_amount ELSE 0 END), 0) AS total_spent,
       RANK() OVER (
           ORDER BY COALESCE(SUM(CASE WHEN o.status <> 'Cancelled'
                                      THEN o.total_amount ELSE 0 END), 0) DESC
       ) AS spending_rank
FROM Customers c
LEFT JOIN Orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY spending_rank;
```

**Expected Output**
```text
rank | customer_id | name          | total_spent
-----+--------------+---------------+------------
1    | 2            | Priya Nair    | 878648
2    | 6            | Anjali Gupta  | 472778
3    | 1            | Aarav Sharma  | 48193
4    | 4            | Sneha Iyer    | 25493
5    | 9            | Arjun Das     | 2499
6    | 8            | Neha Reddy    | 2297
7    | 10           | Meera Pillai  | 799
8    | 5            | Karan Mehta   | 599
9    | 3            | Rohit Verma   | 399
10   | 7            | Vikram Singh  | 0
```

---

### 11.2 Cumulative monthly revenue

**SQL Query**
```sql
SELECT DATE_FORMAT(order_date, '%Y-%m') AS order_month,
       SUM(total_amount) AS monthly_revenue,
       SUM(SUM(total_amount)) OVER (
           ORDER BY DATE_FORMAT(order_date, '%Y-%m')
       ) AS cumulative_revenue
FROM Orders
WHERE status <> 'Cancelled'
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY order_month;
```

**Expected Output**
```text
order_month | monthly_revenue | cumulative_revenue
------------+-----------------+-------------------
2023-12     | 6999            | 6999
2024-05     | 3196            | 10195
2024-08     | 899             | 11094
2024-10     | 3499            | 14593
2025-02     | 18999           | 33592
2025-03     | 5498            | 39090
2025-04     | 599             | 39689
2025-05     | 1799            | 41488
2025-06     | 698             | 42186
2025-07     | 4697            | 46883
2025-08     | 1599            | 48482
2025-09     | 1383223         | 1431705
```

January 2025 does not appear because its only order was cancelled and is excluded.

---

### 11.3 Running total of order count

**SQL Query**
```sql
SELECT order_id,
       order_date,
       COUNT(*) OVER (
           ORDER BY order_date, order_id
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS running_order_count
FROM Orders
ORDER BY order_date, order_id;
```

**Expected Output**
21 rows, starting with:
```text
order_id | order_date | running_order_count
---------+------------+--------------------
6        | 2023-12-05 | 1
1        | 2024-05-10 | 2
3        | 2024-08-22 | 3
10       | 2024-10-30 | 4
...
```
and ending with:
```text
21       | 2025-09-10 | 21
```

---

## Task 12 — CASE Expressions

### 12.1 Customer loyalty status

**SQL Query**
```sql
SELECT c.customer_id,
       c.name,
       COALESCE(SUM(CASE WHEN o.status <> 'Cancelled'
                         THEN o.total_amount ELSE 0 END), 0) AS total_spent,
       CASE
           WHEN COALESCE(SUM(CASE WHEN o.status <> 'Cancelled'
                                  THEN o.total_amount ELSE 0 END), 0) >= 50000
               THEN 'Gold'
           WHEN COALESCE(SUM(CASE WHEN o.status <> 'Cancelled'
                                  THEN o.total_amount ELSE 0 END), 0) >= 10000
               THEN 'Silver'
           ELSE 'Bronze'
       END AS loyalty_status
FROM Customers c
LEFT JOIN Orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC;
```

**Expected Output**
```text
customer_id | name          | total_spent | loyalty_status
------------+---------------+-------------+---------------
2           | Priya Nair    | 878648      | Gold
6           | Anjali Gupta  | 472778      | Gold
1           | Aarav Sharma  | 48193       | Silver
4           | Sneha Iyer    | 25493       | Silver
9           | Arjun Das     | 2499        | Bronze
8           | Neha Reddy    | 2297        | Bronze
10          | Meera Pillai  | 799         | Bronze
5           | Karan Mehta   | 599         | Bronze
3           | Rohit Verma   | 399         | Bronze
7           | Vikram Singh  | 0           | Bronze
```

---

### 12.2 Product sales classification

**SQL Query**
```sql
SELECT p.product_id,
       p.name,
       COALESCE(SUM(CASE WHEN o.status <> 'Cancelled'
                         THEN oi.quantity ELSE 0 END), 0) AS units_sold,
       CASE
           WHEN COALESCE(SUM(CASE WHEN o.status <> 'Cancelled'
                                  THEN oi.quantity ELSE 0 END), 0) >= 500
               THEN 'Best Seller'
           WHEN COALESCE(SUM(CASE WHEN o.status <> 'Cancelled'
                                  THEN oi.quantity ELSE 0 END), 0) >= 100
               THEN 'Popular'
           ELSE 'Regular'
       END AS sales_category
FROM Products p
LEFT JOIN Order_Items oi ON oi.product_id = p.product_id
LEFT JOIN Orders o ON o.order_id = oi.order_id
GROUP BY p.product_id, p.name
ORDER BY p.product_id;
```

**Expected Output**
```text
product_id | units_sold | sales_category
-----------+------------+---------------
1          | 2          | Regular
2          | 1          | Regular
3          | 1          | Regular
4          | 2          | Regular
5          | 2          | Regular
6          | 6          | Regular
7          | 250        | Popular
8          | 523        | Best Seller
9          | 1          | Regular
10         | 0          | Regular
11         | 1          | Regular
12         | 1          | Regular
13         | 2          | Regular
14         | 2          | Regular
15         | 1          | Regular
```

---

# Task 1 — CRUD Operations

The CRUD section is executed near the end of the script.

### INSERT — New product

```sql
INSERT INTO Products (name, category_id, price, stock_quantity, created_date)
VALUES ('Wireless Earbuds', 1, 1999, 300, CURDATE());

SET @new_product_id = LAST_INSERT_ID();
```

**Expected result:** one new product is inserted with price 1999 and stock 300.

---

### INSERT — New customer

```sql
INSERT INTO Customers (name, email, phone, registration_date)
VALUES ('Ishaan Kapoor', 'ishaan@example.com', '9876543210', CURDATE());

SET @new_customer_id = LAST_INSERT_ID();
```

**Expected result:** one new customer is inserted.

---

### INSERT — New order

```sql
INSERT INTO Orders (customer_id, order_date, total_amount, status)
VALUES (@new_customer_id, CURDATE(), 1999, 'Pending');
```

**Expected result:** one new Pending order for Ishaan Kapoor.

---

### UPDATE — Product stock

```sql
UPDATE Products
SET stock_quantity = stock_quantity - 1
WHERE product_id = @new_product_id;
```

**Expected result:** Wireless Earbuds stock changes from 300 to 299.

---

### DELETE — Old cancelled orders

```sql
DELETE FROM Orders
WHERE status = 'Cancelled'
  AND cancelled_date < DATE_SUB(CURDATE(), INTERVAL 30 DAY);
```

**Expected result on 2026-09-12:** orders 7 and 17 are deleted because both cancelled dates are more than 30 days old.

Because of the defined cascading foreign keys, related `Order_Items` and `Payments` rows for those orders are also removed.

---

# Final Database Counts After the Complete Script

Assuming the complete script is executed on **2026-09-12**:

```text
Categories   | 5
Products     | 16
Customers    | 11
Orders       | 20
Order_Items  | 22
Payments     | 19
Shipping     | 12
```

The analytical query outputs above refer to the **21 original sample orders before the final CRUD/delete section**, because those queries occur before CRUD in the script.

