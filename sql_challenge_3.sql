USE SQL_Challenges;
CREATE TABLE countries (
country_id INT PRIMARY KEY,
country_name VARCHAR(50),
head_office VARCHAR(50)
);
--------------------
INSERT INTO countries (country_id, country_name, head_office)
VALUES (1, 'UK', 'London'),
(2, 'USA', 'New York'),
(3, 'China', 'Beijing');
--------------------
CREATE TABLE customer (
customer_id INT PRIMARY KEY,
first_shop DATE,
age INT,
rewards VARCHAR(50),
can_email VARCHAR(50)
);
--------------------
INSERT INTO customer (customer_id, first_shop, age, rewards, can_email)
VALUES (1, '2022-03-20', 23, 'yes', 'no'),
(2, '2022-03-25', 26, 'no', 'no'),
(3, '2022-04-06', 32, 'no', 'no'),
(4, '2022-04-13', 25, 'yes', 'yes'),
(5, '2022-04-22', 49, 'yes', 'yes'),
(6, '2022-06-18', 28, 'yes', 'no'),
(7, '2022-06-30', 36, 'no', 'no'),
(8, '2022-07-04', 37, 'yes', 'yes');
--------------------
CREATE TABLE orders (
order_id INT PRIMARY KEY,
customer_id INT,
date_shop DATE,
sales_channel VARCHAR(50),
country_id INT,
FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
FOREIGN KEY (country_id) REFERENCES country(country_id)
);
--------------------
INSERT INTO orders (order_id, customer_id, date_shop, sales_channel, country_id)
VALUES (1, 1, '2023-01-16', 'retail', 1),
(2, 4, '2023-01-20', 'retail', 1),
(3, 2, '2023-01-25', 'retail', 2),
(4, 3, '2023-01-25', 'online', 1),
(5, 1, '2023-01-28', 'retail', 3),
(6, 5, '2023-02-02', 'online', 1),
(7, 6, '2023-02-05', 'retail', 1),
(8, 3, '2023-02-11', 'online', 3);
--------------------
CREATE TABLE products (
product_id INT PRIMARY KEY,
category VARCHAR(50),
price NUMERIC(5,2)
);
--------------------
INSERT INTO products (product_id, category, price)
VALUES (1, 'food', 5.99),
(2, 'sports', 12.49),
(3, 'vitamins', 6.99),
(4, 'food', 0.89),
(5, 'vitamins', 15.99);
--------------------
CREATE TABLE baskets (
order_id INT,
product_id INT,
FOREIGN KEY (order_id) REFERENCES orders(order_id),
FOREIGN KEY (product_id) REFERENCES products(product_id)
);
--------------------
INSERT INTO baskets (order_id, product_id)
VALUES (1, 1),
(1, 2),
(1, 5),
(2, 4),
(3, 3),
(4, 2),
(4, 1),
(5, 3),
(5, 5),
(6, 4),
(6, 3),
(6, 1),
(7, 2),
(7, 1),
(8, 3),
(8, 3);
-------------------------------------------------------------------------------------------------------------------
#1. What are the names of all the countries in the country table?
SELECT country_name 
FROM countries;
--------------------------------------------------------------------------------------------------------------------
#2. What is the total number of customers in the customers table?
SELECT COUNT(*) AS total_customers
FROM customer;
--------------------------------------------------------------------------------------------------------------------
#3. What is the average age of customers who can receive marketing emails (can_email is set to 'yes')?
SELECT CAST(AVG(age) AS INTEGER) AS average_age
FROM customer
WHERE can_email = 'yes';
--------------------------------------------------------------------------------------------------------------------
#4. How many orders were made by customers aged 30 or older?
SELECT COUNT(*) AS total_orders
FROM orders o
JOIN customer c ON o.customer_id = c.customer_id
WHERE c.age >= 30;
--------------------------------------------------------------------------------------------------------------------
#5. What is the total revenue generated by each product category?
SELECT p.category,
       SUM(p.price) AS total_revenue
FROM products p
JOIN baskets b ON p.product_id = b.product_id
GROUP BY p.category;
--------------------------------------------------------------------------------------------------------------------
#6. What is the average price of products in the 'food' category?
SELECT AVG(price) AS avg_food_price
FROM products 
WHERE category = 'food';
--------------------------------------------------------------------------------------------------------------------
#7. How many orders were made in each sales channel (sales_channel column) in the orders table?
SELECT sales_channel,
       COUNT(*) AS order_count
FROM orders
GROUP BY sales_channel;
--------------------------------------------------------------------------------------------------------------------
#8. What is the date of the latest order made by a customer who can receive marketing emails?
SELECT MAX(date_shop) AS latest_order_date
FROM orders o
JOIN customer c ON o.customer_id = c.customer_id
WHERE c.can_email = 'yes';
--------------------------------------------------------------------------------------------------------------------
#9. What is the name of the country with the highest number of orders?
SELECT c.country_name
FROM countries c
JOIN orders o ON c.country_id = o.country_id
GROUP BY c.country_name
ORDER BY COUNT(*) DESC
LIMIT 1;
--------------------------------------------------------------------------------------------------------------------
#10. What is the average age of customers who made orders in the 'vitamins' product category?
SELECT CAST(AVG(c.age) AS INTEGER) AS average_age
FROM customer c
JOIN orders o ON c.customer_id = o.customer_id
JOIN baskets b ON o.order_id = b.order_id
JOIN products p ON b.product_id = p.product_id
WHERE p.category = 'vitamins';

