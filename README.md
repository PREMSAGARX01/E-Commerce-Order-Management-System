# E-Commerce Order Management System

A practical **MySQL 8.0+ relational database project** for managing an
e-commerce business. The system stores and analyzes product, category,
customer, order, order-item, payment, and shipping information while
demonstrating core and advanced SQL concepts.

## Project Overview

The database is designed around seven related tables:

-   **Categories** --- product categories
-   **Products** --- product details, prices, stock, category, and added
    date
-   **Customers** --- customer contact and registration information
-   **Orders** --- customer orders, dates, totals, status, and
    cancellation dates
-   **Order_Items** --- products and quantities belonging to orders
-   **Payments** --- payment details and payment status
-   **Shipping** --- shipping and delivery details

The project demonstrates SQL from basic data retrieval and CRUD
operations through joins, subqueries, date/string functions, window
functions, and `CASE` expressions.

------------------------------------------------------------------------

## Requirements

-   **MySQL 8.0+**
-   MySQL Server running locally or on an accessible server
-   MySQL Workbench, or VS Code with a MySQL/SQL extension

------------------------------------------------------------------------

## How to Run

### MySQL Command Line

From the directory containing the SQL file:

``` bash
mysql -u root -p < ecommerce_management_final-1.sql
```

### MySQL Workbench

1.  Start MySQL Server.
2.  Open MySQL Workbench.
3.  Connect to the MySQL server.
4.  Open `ecommerce_management_final-1.sql`.
5.  Execute the complete script from the beginning.

### VS Code

1.  Start MySQL Server.
2.  Open `ecommerce_management_final-1.sql`.
3.  Connect the SQL extension to the MySQL server.
4.  Execute the complete script from the beginning.
5.  Refresh the database explorer after execution.

The script creates/recreates the `ecommerce_management` database,
creates the seven tables, inserts the sample data, synchronizes order
totals with order-item subtotals, and executes the demonstration
queries. The CRUD demonstration is located at the end of the script.

------------------------------------------------------------------------

## Database Schema

### Relationship Overview

``` text
Categories
    │
    └──< Products
              │
              └──< Order_Items >── Orders >── Customers
                                      │
                                      ├──< Payments
                                      │
                                      └──< Shipping
```

### Tables

#### 1. Categories

Stores the available product categories.

-   `category_id` --- Primary Key
-   `category_name`

#### 2. Products

Stores products available for sale.

-   `product_id` --- Primary Key
-   `name`
-   `category_id` --- Foreign Key → `Categories`
-   `price`
-   `stock_quantity`
-   `added_date`

#### 3. Customers

Stores customer information.

-   `customer_id` --- Primary Key
-   `name`
-   `email`
-   `phone_number`
-   `address`
-   `registration_date`

#### 4. Orders

Stores customer order information.

-   `order_id` --- Primary Key
-   `customer_id` --- Foreign Key → `Customers`
-   `order_date`
-   `cancelled_date`
-   `total_amount`
-   `status`

Order status values used by the script include:

``` text
Pending
Shipped
Delivered
Cancelled
```

#### 5. Order_Items

Stores the individual products contained in each order.

-   `order_item_id` --- Primary Key
-   `order_id` --- Foreign Key → `Orders`
-   `product_id` --- Foreign Key → `Products`
-   `quantity`
-   `subtotal`

The `order_id` foreign key uses `ON DELETE CASCADE`.

#### 6. Payments

Stores payment information for orders.

-   `payment_id` --- Primary Key
-   `order_id` --- Foreign Key → `Orders`
-   `payment_date`
-   `payment_method`
-   `payment_status`

The `order_id` foreign key uses `ON DELETE CASCADE`.

Payment methods used by the script include:

``` text
Credit Card
PayPal
UPI
```

Payment statuses include:

``` text
Paid
Pending
Failed
```

#### 7. Shipping

Stores shipping and delivery information.

-   `shipping_id` --- Primary Key
-   `order_id` --- Foreign Key → `Orders`
-   `shipping_date`
-   `delivery_date`
-   `shipping_status`

The `order_id` foreign key uses `ON DELETE CASCADE`.

Shipping statuses include:

``` text
Dispatched
In Transit
Delivered
```

------------------------------------------------------------------------

## Data Integrity

The schema includes constraints to improve data quality and referential
integrity.

Examples include:

-   Primary keys for unique row identification
-   Foreign keys for relationships between tables
-   `NOT NULL` constraints where required
-   `UNIQUE` constraints where required
-   `CHECK` constraints for valid numeric/status values
-   `ON DELETE CASCADE` for order-dependent records

### Order and Line-Item Totals

After the sample `Order_Items` are inserted, the script synchronizes
`Orders.total_amount` with the sum of the corresponding line-item
subtotals.

This keeps the sample order totals consistent with their order details.

### Cancellation Tracking

`Orders` contains:

``` sql
cancelled_date DATE NULL
```

The cancellation date allows the final CRUD deletion query to identify
cancelled orders that have been cancelled for more than 30 days.

### Cancelled Sales

Queries that calculate revenue or sales performance exclude cancelled
orders where appropriate.

------------------------------------------------------------------------

## Requirement Coverage

    \# Requirement                  Covered In
  ---- ---------------------------- -----------------------
     1 CRUD operations              Task 1 / CRUD section
     2 `WHERE`, `HAVING`, `LIMIT`   Task 2
     3 `AND`, `OR`, `NOT`           Task 3
     4 `ORDER BY`, `GROUP BY`       Task 4
     5 Aggregate functions          Task 5
     6 Primary and Foreign Keys     Schema / Task 6
     7 Joins                        Task 7
     8 Subqueries                   Task 8
     9 Date and Time functions      Task 9
    10 String functions             Task 10
    11 Window functions             Task 11
    12 `CASE` expressions           Task 12

### Aggregate Functions

The project demonstrates:

``` sql
SUM()
AVG()
MAX()
MIN()
COUNT()
```

### Joins

The project demonstrates:

``` text
INNER JOIN
LEFT JOIN
RIGHT JOIN
FULL OUTER JOIN emulation
```

MySQL does not provide a native `FULL OUTER JOIN`. The project therefore
demonstrates the standard `LEFT JOIN` + `RIGHT JOIN` + `UNION` approach.

### Subqueries

The project includes subqueries for filtering and comparison tasks and
uses `NOT EXISTS` for identifying products that have never been ordered.

### Date and Time Functions

The project demonstrates functions including:

``` sql
CURDATE()
YEAR()
MONTH()
DATE_FORMAT()
DATE_SUB()
```

Monthly analysis uses year-month formatting:

``` sql
DATE_FORMAT(order_date, '%Y-%m')
```

This prevents the same calendar month from different years from being
grouped together.

### String Functions

The project demonstrates string manipulation functions including:

``` sql
UPPER()
LOWER()
CONCAT()
LENGTH()
```

### Window Functions

The project demonstrates analytical window functions including:

``` sql
RANK()
SUM() OVER (...)
COUNT() OVER (...)
```

These calculations preserve individual result rows while performing
calculations across related rows.

### CASE Expressions

The project uses `CASE` expressions for classification tasks.

Customer classifications include:

``` text
Gold
Silver
Bronze
```

Product sales classifications include:

``` text
Best Seller
Popular
Regular
```

The sample data includes dedicated high-volume demonstration orders so
the different CASE branches can be reached without changing the line
items of unrelated sample orders.

------------------------------------------------------------------------

## CRUD Demonstration

The CRUD section is located at the end of the SQL script.

### CREATE

The script inserts:

-   A new product
-   A new customer
-   A new order associated with the newly created customer

`LAST_INSERT_ID()` is used to capture newly generated IDs rather than
relying on a hard-coded customer ID.

### READ

The project contains numerous `SELECT` queries for retrieving and
analyzing database information.

### UPDATE

The CRUD section demonstrates updating product stock after the new order
is created.

### DELETE

The final CRUD query deletes cancelled orders whose `cancelled_date` is
more than 30 days before the current date.

Because dependent order tables use `ON DELETE CASCADE`, associated
`Order_Items`, `Payments`, and `Shipping` records are removed
automatically when an eligible order is deleted.

> The CRUD section contains a real `DELETE` operation. For demonstration
> purposes, execute individual queries carefully rather than repeatedly
> rerunning the complete script against a database whose data you want
> to preserve.

------------------------------------------------------------------------

## Verification

After running the script, the database can be checked with:

``` sql
USE ecommerce_management;
SHOW TABLES;
```

The expected tables are:

``` text
Categories
Products
Customers
Orders
Order_Items
Payments
Shipping
```

Sample data can be inspected with:

``` sql
SELECT * FROM Categories;
SELECT * FROM Products;
SELECT * FROM Customers;
SELECT * FROM Orders;
SELECT * FROM Order_Items;
SELECT * FROM Payments;
SELECT * FROM Shipping;
```

To verify the relationship between orders and their line items:

``` sql
SELECT
    o.order_id,
    o.total_amount,
    COALESCE(SUM(oi.subtotal), 0) AS item_total
FROM Orders o
LEFT JOIN Order_Items oi
    ON oi.order_id = o.order_id
GROUP BY o.order_id, o.total_amount;
```

------------------------------------------------------------------------

## Script Organization

The SQL file is organized into sections covering:

``` text
Database setup
Schema creation
Sample data
Task 2 — Filtering
Task 3 — Operators
Task 4 — Sorting and grouping
Task 5 — Aggregation
Task 6 — Keys
Task 7 — Joins
Task 8 — Subqueries
Task 9 — Date and time functions
Task 10 — String functions
Task 11 — Window functions
Task 12 — CASE expressions
Task 1 — CRUD operations
```

The CRUD section is placed at the end so that the earlier analytical
demonstrations can be viewed before the final destructive `DELETE`
operation is executed.

------------------------------------------------------------------------

## Practical Examination Notes

For an SQL practical demonstration:

1.  Show the `ecommerce_management` database.
2.  Show the seven tables.
3.  Explain the primary-key and foreign-key relationships.
4.  Demonstrate representative `SELECT` and filtering queries.
5.  Demonstrate operators and sorting/grouping.
6.  Demonstrate aggregate functions.
7.  Demonstrate joins.
8.  Demonstrate subqueries.
9.  Demonstrate date/time and string functions.
10. Demonstrate window functions.
11. Demonstrate `CASE` expressions.
12. Demonstrate CRUD operations individually.

When demonstrating an individual task, select and execute the relevant
query instead of unnecessarily rerunning the complete script.

------------------------------------------------------------------------

## Project Objective

The objective of this project is to design and implement a practical
relational database for an e-commerce environment while demonstrating a
broad range of MySQL concepts.

The project combines:

-   Relational database design
-   Referential integrity
-   Data manipulation
-   Data retrieval
-   Analytical SQL
-   Joins
-   Subqueries
-   Date and string processing
-   Window functions
-   Conditional expressions

into one realistic e-commerce database system.

------------------------------------------------------------------------
