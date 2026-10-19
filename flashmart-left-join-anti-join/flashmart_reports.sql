-- FlashMart LEFT JOIN / Anti-Join
-- Chi su dung voi co so du lieu thuc hanh: xoa bang mau truoc khi tao lai.
CREATE DATABASE IF NOT EXISTS flashmart_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE flashmart_db;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (customer_id INT PRIMARY KEY, name VARCHAR(50) NOT NULL);
CREATE TABLE Products (product_id INT PRIMARY KEY, product_name VARCHAR(50) NOT NULL);
CREATE TABLE Orders (
 order_id INT PRIMARY KEY, customer_id INT NOT NULL, product_id INT NOT NULL,
 FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
 FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
INSERT INTO Customers VALUES (1,'Alice'),(2,'Bob'),(3,'Charlie');
INSERT INTO Products VALUES (101,'Laptop'),(102,'Mouse'),(103,'Keyboard');
INSERT INTO Orders VALUES (1001,1,101),(1002,1,102),(1003,2,101);

-- Marketing: bao gom khach chua tung mua hang.
SELECT c.customer_id,c.name,COUNT(o.order_id) AS total_orders
FROM Customers AS c
LEFT JOIN Orders AS o ON c.customer_id=o.customer_id
GROUP BY c.customer_id,c.name ORDER BY c.customer_id;

-- Kho van: san pham chua tung duoc ban.
SELECT p.product_id,p.product_name
FROM Products AS p
LEFT JOIN Orders AS o ON p.product_id=o.product_id
WHERE o.order_id IS NULL ORDER BY p.product_id;

SELECT COUNT(*) AS total_customers FROM Customers;
SELECT COUNT(*) AS unsold_products
FROM Products p LEFT JOIN Orders o ON p.product_id=o.product_id
WHERE o.order_id IS NULL;
