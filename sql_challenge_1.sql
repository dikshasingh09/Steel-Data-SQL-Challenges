USE SQL_Challenges;
CREATE TABLE cars (
car_id INT PRIMARY KEY,
make VARCHAR(50),
type VARCHAR(50),
style VARCHAR(50),
cost_$ INT
);
--------------------
INSERT INTO cars (car_id, make, type, style, cost_$)
VALUES (1, 'Honda', 'Civic', 'Sedan', 30000),
(2, 'Toyota', 'Corolla', 'Hatchback', 25000),
(3, 'Ford', 'Explorer', 'SUV', 40000),
(4, 'Chevrolet', 'Camaro', 'Coupe', 36000),
(5, 'BMW', 'X5', 'SUV', 55000),
(6, 'Audi', 'A4', 'Sedan', 48000),
(7, 'Mercedes', 'C-Class', 'Coupe', 60000),
(8, 'Nissan', 'Altima', 'Sedan', 26000);
--------------------
CREATE TABLE salespersons (
salesman_id INT PRIMARY KEY,
name VARCHAR(50),
age INT,
city VARCHAR(50)
);
--------------------
INSERT INTO salespersons (salesman_id, name, age, city)
VALUES (1, 'John Smith', 28, 'New York'),
(2, 'Emily Wong', 35, 'San Fran'),
(3, 'Tom Lee', 42, 'Seattle'),
(4, 'Lucy Chen', 31, 'LA');
--------------------
CREATE TABLE sales2 (
sale_id INT PRIMARY KEY,
car_id INT,
salesman_id INT,
purchase_date DATE,
FOREIGN KEY (car_id) REFERENCES cars(car_id),
FOREIGN KEY (salesman_id) REFERENCES salespersons(salesman_id)
);
--------------------
INSERT INTO sales2 (sale_id, car_id, salesman_id, purchase_date)
VALUES (1, 1, 1, '2021-01-01'),
(2, 3, 3, '2021-02-03'),
(3, 2, 2, '2021-02-10'),
(4, 5, 4, '2021-03-01'),
(5, 8, 1, '2021-04-02'),
(6, 2, 1, '2021-05-05'),
(7, 4, 2, '2021-06-07'),
(8, 5, 3, '2021-07-09'),
(9, 2, 4, '2022-01-01'),
(10, 1, 3, '2022-02-03'),
(11, 8, 2, '2022-02-10'),
(12, 7, 2, '2022-03-01'),
(13, 5, 3, '2022-04-02'),
(14, 3, 1, '2022-05-05'),
(15, 5, 4, '2022-06-07'),
(16, 1, 2, '2022-07-09'),
(17, 2, 3, '2023-01-01'),
(18, 6, 3, '2023-02-03'),
(19, 7, 1, '2023-02-10'),
(20, 4, 4, '2023-03-01');

-------------------------------------------------------------------------------------------------------------------------
-- 1. What are the details of all cars purchased in the year 2022?
SELECT * FROM cars AS c
INNER JOIN sales AS s
ON c.car_id = s.car_id
WHERE EXTRACT(YEAR FROM purchase_date) = 2022
GROUP BY c.car_id;

-------------------------------------------------------------------------------------------------------------------------
-- 2. What is the total number of cars sold by each salesperson?
SELECT s.salesman_id, sp.name, COUNT(s.sale_id) AS no_of_cars
FROM sales AS s
INNER JOIN salespersons AS sp
ON s.salesman_id = sp.salesman_id
GROUP BY s.salesman_id, sp.name
ORDER BY no_of_cars DESC;

-------------------------------------------------------------------------------------------------------------------------
-- 3. What is the total revenue generated by each salesperson?
SELECT s.salesman_id, sp.name, SUM(c.cost_$) AS total_revenue
FROM cars AS c
INNER JOIN sales AS s
ON c.car_id = s.car_id
INNER JOIN salespersons AS sp
ON s.salesman_id = sp.salesman_id
GROUP BY s.salesman_id, sp.name
ORDER BY total_revenue DESC;

-------------------------------------------------------------------------------------------------------------------------
-- 4. What are the details of the cars sold by each salesperson?
SELECT c.*, sp.*
FROM cars AS c
INNER JOIN sales AS s
ON c.car_id = s.car_id
INNER JOIN salespersons AS sp
ON sp.salesman_id = s.salesman_id;

-------------------------------------------------------------------------------------------------------------------------
-- 5. What is the total revenue generated by each car style?
SELECT style, SUM(cost_$) AS total_revenue
FROM cars
GROUP BY style 
ORDER BY total_revenue DESC;

-------------------------------------------------------------------------------------------------------------------------
-- 6. What are the details of the cars sold in the year 2021 by salesperson 'Emily Wong'?
SELECT c.*, s.salesman_id, sp.name
FROM cars AS c
INNER JOIN sales AS s
ON c.car_id = s.car_id
INNER JOIN salespersons AS sp
ON sp.salesman_id = s.salesman_id
WHERE EXTRACT(YEAR FROM s.purchase_date) = 2021 AND sp.name='Emily Wong'
GROUP BY s.salesman_id;

-------------------------------------------------------------------------------------------------------------------------
-- 7. What is the total revenue generated by the sales of hatchback cars?
SELECT c.style, SUM(c.cost_$) AS total_revenue
FROM cars AS c
INNER JOIN sales AS s
ON c.car_id = s.car_id
WHERE c.style = 'Hatchback';

-------------------------------------------------------------------------------------------------------------------------
-- 8. What is the total revenue generated by the sales of SUV cars in the year 2022?
SELECT c.style, SUM(DISTINCT c.cost_$) AS total_revenue
FROM cars AS c
RIGHT JOIN sales AS s
ON c.car_id = s.car_id
WHERE c.style = 'SUV' AND EXTRACT(YEAR FROM s.purchase_date) = 2022;

-------------------------------------------------------------------------------------------------------------------------
-- 9. What is the name and city of the salesperson who sold the most number of cars in the year 2023?
SELECT sp.name, sp.city, COUNT(DISTINCT s.sale_id) AS sold_no_of_cars
FROM cars c 
INNER JOIN sales AS s
ON c.car_id = s.car_id
INNER JOIN salespersons AS sp
ON s.salesman_id = sp.salesman_id
WHERE EXTRACT(YEAR FROM purchase_date) = 2023
GROUP BY sp.name 
ORDER BY sold_no_of_cars DESC LIMIT 1;

-------------------------------------------------------------------------------------------------------------------------
-- 10. What is the name and age of the salesperson who generated the highest revenue in the year 2022?
SELECT sp.name, sp.age, SUM(c.cost_$) AS total_revenue
FROM cars c 
INNER JOIN sales AS s
ON c.car_id = s.car_id
INNER JOIN salespersons AS sp
ON s.salesman_id = sp.salesman_id
WHERE EXTRACT(YEAR FROM purchase_date) = 2022
GROUP BY s.salesman_id
ORDER BY total_revenue DESC LIMIT 1;