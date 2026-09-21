# Sunrise Supermarket Database

## Student Information

**Name:** Mugisha Kalisa Orion
**Student ID:** 27426

## DBMS Used

**MySQL**

---

## 1. Project Summary

This project involves designing and querying a relational database for Sunrise Supermarket.

The database was created to manage customers, products, orders, and order items. Sample data was inserted into the database, including 5 customers, 8 products across multiple categories, 15 orders, and 30 order items.

SQL queries were then used to analyze the data using different database techniques, including:

* INNER JOIN
* LEFT JOIN
* Common Table Expressions (CTEs)
* RANK() window function
* ROW_NUMBER() window function
* Running totals

The analysis provides information about customer purchases, customer spending, order history, and supermarket revenue over time.

---

## 2. How to Run

### Requirements

The project requires:

* MySQL Server
* MySQL Workbench

### Steps

1. Open MySQL Workbench.
2. Connect to the MySQL server.
3. Create the database:

```sql
CREATE DATABASE sunrise_supermarket;
```

4. Select the database:

```sql
USE sunrise_supermarket;
```

5. Create the four tables:

   * `customers`
   * `products`
   * `orders`
   * `order_items`

6. Insert the sample data into the tables.

7. Run the SQL queries contained in `sunrise_supermarket_queries.sql`.

8. View the results in MySQL Workbench.

The SQL file contains the database queries used for the assignment.

---

# 3. Business Scenario

Sunrise Supermarket needs a database system to organize and manage information about its customers, products, orders, and sales.

The supermarket needs to know which customers are placing orders, which products are being purchased, how much customers are spending, and how revenue changes over time.

The database provides a structured way to store this information and perform analysis on the supermarket's sales.

For example, management can use the database to identify customers who spend above average, rank customers according to their spending, examine customer order history, and monitor accumulated revenue.

This information can support better understanding of customer purchasing behavior and overall sales performance.

---

# 4. Database Structure

The database contains four main tables.

### Customers

The `customers` table stores customer information.

| Column        | Description                 |
| ------------- | --------------------------- |
| customer_id   | Unique ID for each customer |
| customer_name | Customer's name             |
| email         | Customer's email            |
| city          | Customer's city             |

### Products

The `products` table stores information about products sold by the supermarket.

| Column       | Description                |
| ------------ | -------------------------- |
| product_id   | Unique ID for each product |
| product_name | Name of the product        |
| category     | Product category           |
| price        | Product price              |

### Orders

The `orders` table stores customer orders.

| Column      | Description                   |
| ----------- | ----------------------------- |
| order_id    | Unique ID for each order      |
| customer_id | Customer who placed the order |
| order_date  | Date the order was placed     |

### Order Items

The `order_items` table stores the individual products contained in each order.

| Column        | Description                    |
| ------------- | ------------------------------ |
| order_item_id | Unique ID for each order item  |
| order_id      | Order associated with the item |
| product_id    | Product purchased              |
| quantity      | Quantity purchased             |

### Relationships

The tables are related through primary keys and foreign keys.

* `customers.customer_id` → `orders.customer_id`
* `orders.order_id` → `order_items.order_id`
* `products.product_id` → `order_items.product_id`

Therefore:

**Customers → Orders → Order Items ← Products**

One customer can place multiple orders, one order can contain multiple order items, and one product can appear in multiple order items.

---

# 5. JOIN Queries

## Query 1 — INNER JOIN Orders and Customers

```sql
SELECT
    o.order_id,
    c.customer_name,
    c.city,
    o.order_date
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id
ORDER BY o.order_date;
```

### Explanation

This query uses an `INNER JOIN` to connect the `orders` table with the `customers` table.

The tables are connected using `customer_id`.

The query displays:

* Order ID
* Customer name
* Customer city
* Order date

An `INNER JOIN` only returns records where a matching customer exists for an order.

### Business Purpose

This allows Sunrise Supermarket to see which customer placed each order and when the order was made.

---

## Query 2 — INNER JOIN Order Items and Products

```sql
SELECT
    oi.order_item_id,
    p.product_name,
    p.category,
    p.price,
    oi.quantity
FROM order_items oi
INNER JOIN products p
    ON oi.product_id = p.product_id
ORDER BY oi.order_item_id;
```

### Explanation

This query connects the `order_items` table to the `products` table using `product_id`.

It displays:

* Order item ID
* Product name
* Product category
* Product price
* Quantity purchased

The `INNER JOIN` ensures that the order item is matched with its corresponding product.

### Business Purpose

This helps the supermarket understand which products were purchased and the quantities purchased.

---

## Query 3 — LEFT JOIN Customers and Orders

```sql
SELECT
    c.customer_id,
    c.customer_name,
    c.city,
    o.order_id,
    o.order_date
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
ORDER BY c.customer_id, o.order_date;
```

### Explanation

This query uses a `LEFT JOIN`.

A `LEFT JOIN` returns every customer from the `customers` table, even if that customer has no order.

If a customer has not placed an order, the order columns will contain `NULL`.

### Business Purpose

This allows Sunrise Supermarket to identify both customers who have purchased products and customers who have registered but have not yet placed an order.

---

# 6. CTE Query

## Query 4 — Customers Spending Above Average

```sql
WITH customer_totals AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * p.price) AS total_spend
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        c.customer_id,
        c.customer_name
)
SELECT
    customer_id,
    customer_name,
    total_spend
FROM customer_totals
WHERE total_spend > (
    SELECT AVG(total_spend)
    FROM customer_totals
)
ORDER BY total_spend DESC;
```

### Explanation

This query uses a **Common Table Expression (CTE)** called `customer_totals`.

The CTE calculates the total amount spent by each customer.

The calculation is:

**Quantity × Product Price**

The query then calculates the average spending across all customers.

Finally, it returns only customers whose total spending is greater than the average.

### Business Purpose

This helps Sunrise Supermarket identify customers who spend more than the average customer.

The supermarket can use this information to understand its higher-spending customers and their purchasing behavior.

---

# 7. Window Function Queries

## Query 5 — Rank Customers by Total Spending

```sql
WITH customer_totals AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * p.price) AS total_spend
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    JOIN order_items oi
        ON o.order_id = oi.order_id
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        c.customer_id,
        c.customer_name
)
SELECT
    customer_id,
    customer_name,
    total_spend,
    RANK() OVER (
        ORDER BY total_spend DESC
    ) AS spending_rank
FROM customer_totals
ORDER BY spending_rank;
```

### Explanation

This query uses the `RANK()` window function to rank customers based on their total spending.

The `ORDER BY total_spend DESC` means customers with higher spending receive higher positions in the ranking.

The customer with the highest total spending receives rank 1.

### Business Purpose

This allows the supermarket to compare customers based on their total spending.

---

## Query 6 — Number Each Customer's Orders

```sql
SELECT
    o.order_id,
    c.customer_name,
    o.order_date,
    ROW_NUMBER() OVER (
        PARTITION BY o.customer_id
        ORDER BY o.order_date
    ) AS order_number
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
ORDER BY c.customer_name, o.order_date;
```

### Explanation

This query uses the `ROW_NUMBER()` window function.

`PARTITION BY o.customer_id` separates the orders by customer.

The orders are then sorted by `order_date`.

Each customer's first order receives number 1, their second order receives number 2, and so on.

### Business Purpose

This gives Sunrise Supermarket an ordered history of each customer's purchases.

It can help the supermarket understand how frequently customers return and place additional orders.

---

## Query 7 — Running Total Revenue

```sql
SELECT
    o.order_date,
    SUM(oi.quantity * p.price) AS daily_revenue,
    SUM(
        SUM(oi.quantity * p.price)
    ) OVER (
        ORDER BY o.order_date
    ) AS running_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY o.order_date
ORDER BY o.order_date;
```

### Explanation

This query calculates two values:

1. `daily_revenue` — the revenue generated on each order date.
2. `running_revenue` — the total revenue accumulated up to each date.

The running total is calculated using a window function ordered by the order date.

### Business Purpose

This allows Sunrise Supermarket to monitor how its total revenue grows over time.

---

# 8. Results

The queries were executed using MySQL Workbench.

## Query 1 Result

The first query displays every order together with the customer's name, city, and order date.

**Result:** The query successfully connects orders to their corresponding customers.

---

## Query 2 Result

The second query displays products purchased in each order item together with their category, price, and quantity.

**Result:** The query successfully connects order items with product information.

---

## Query 3 Result

The third query displays all customers and their orders.

**Result:** Because a `LEFT JOIN` was used, customers without orders are also included.


---

## Query 4 Result

The fourth query displays customers whose total spending is above the average customer spending.

**Result:** The query successfully identifies customers who spend more than the calculated average.


---

## Query 5 Result

The fifth query ranks customers according to their total spending.

**Result:** Customers are assigned a spending rank, beginning with the customer with the highest total spending.


---

## Query 6 Result

The sixth query numbers each customer's orders chronologically.

**Result:** Each customer's first order is numbered 1, followed by their subsequent orders.


---

## Query 7 Result

The seventh query displays daily revenue and the running total revenue.

**Result:** The running revenue increases as additional sales are included over time.


---

# 9. Business Interpretation

The database analysis provides Sunrise Supermarket with several useful insights.

The JOIN queries provide a complete view of the supermarket's transactions by connecting customers, orders, products, and quantities.

The above-average spending query identifies customers whose spending is higher than the average. This can help the supermarket understand its higher-spending customer segment.

The customer ranking query provides a comparison of customer spending levels.

The order-numbering query provides a chronological view of each customer's orders and helps show repeat purchasing behavior.

The running revenue query shows how revenue accumulates over time, allowing the supermarket to monitor its sales performance.

Overall, the database transforms individual sales records into information that can help Sunrise Supermarket understand customers, products, orders, and revenue.

---

# 10. Challenges and Resolutions

## Challenge 1 — Database Setup

The database was initially being developed using Oracle, but the project was later moved to MySQL.

### Resolution

MySQL was selected because the assignment allows different DBMS platforms, including MySQL. The database tables and data were recreated using MySQL Workbench.

---

## Challenge 2 — Foreign Key Errors

Foreign key errors can occur when inserting records into a table before the related records exist in the referenced table.

### Resolution

The data was inserted in the correct dependency order:

1. Customers and products
2. Orders
3. Order items

This ensured that foreign key relationships could be satisfied.

---

## Challenge 3 — Understanding JOINs

Understanding how the four tables should be connected was initially challenging.

### Resolution

The primary keys and foreign keys were used to identify the relationships between the tables.

For example:

* `customer_id` connects customers and orders.
* `order_id` connects orders and order items.
* `product_id` connects products and order items.

---

## Challenge 4 — Understanding CTEs

The CTE used in Query 4 required understanding how a temporary result could be created and then used by another query.

### Resolution

The CTE was used to first calculate each customer's total spending. The resulting totals were then used to calculate the average and identify customers spending above that average.

---

## Challenge 5 — Understanding Window Functions

Understanding `RANK()`, `ROW_NUMBER()`, and running totals was another challenge.

### Resolution

Each window function was applied to a specific business problem:

* `RANK()` was used to rank customers by spending.
* `ROW_NUMBER()` was used to number each customer's orders.
* A windowed `SUM()` was used to calculate the running revenue total.
