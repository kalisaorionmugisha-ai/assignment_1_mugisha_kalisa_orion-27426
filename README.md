# Sunrise Supermarket Database

## Student Information

**Name:** Your Name  
**Student ID:** Your Student ID  

## DBMS Used

**MySQL**

## Project Summary

This project develops a database for Sunrise Supermarket to manage customers, products, orders, and order items.

The database was designed to store sales information and allow the supermarket to analyze customer spending, order history, product information, and revenue over time.


## Business Scenario

Sunrise Supermarket needs a database system to manage information about its customers, products, orders, and order items.

The database allows the supermarket to keep customer records, store product information, record customer orders, and track the products purchased in each order.

The database can also be used to analyze customer spending, identify customers who spend above average, rank customers based on their total spending, track the order history of each customer, and monitor revenue over time.

This information can help Sunrise Supermarket understand customer purchasing behavior and monitor its sales performance.

## Database Structure

The database contains four main tables:

### 1. Customers

The `customers` table stores information about supermarket customers.

It contains:

- `customer_id` – unique identifier for each customer
- `customer_name` – customer's name
- `email` – customer's email address
- `city` – customer's city

### 2. Products

The `products` table stores information about the products sold by the supermarket.

It contains:

- `product_id` – unique identifier for each product
- `product_name` – name of the product
- `category` – product category
- `price` – price of the product

### 3. Orders

The `orders` table stores information about customer orders.

It contains:

- `order_id` – unique identifier for each order
- `customer_id` – identifies the customer who placed the order
- `order_date` – date the order was placed

The `customer_id` connects the `orders` table to the `customers` table.

### 4. Order Items

The `order_items` table stores the individual products included in each order.

It contains:

- `order_item_id` – unique identifier for each order item
- `order_id` – identifies the order
- `product_id` – identifies the product
- `quantity` – number of units purchased

The `order_id` connects `order_items` to `orders`, while `product_id` connects `order_items` to `products`.

### Table Relationships

The relationships between the tables are:

- One customer can have many orders.
- One order can contain many order items.
- One product can appear in many order items.

The relationships can be summarized as:

`Customers → Orders → Order Items ← Products`

## JOIN Queries

### Query 1 — INNER JOIN Orders and Customers

This query combines the `orders` and `customers` tables using an `INNER JOIN`.

It displays:

- Order ID
- Customer name
- Customer city
- Order date

The JOIN is performed using `customer_id`.

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
