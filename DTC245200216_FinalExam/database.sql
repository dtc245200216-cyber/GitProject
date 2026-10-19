CREATE DATABASE IF NOT EXISTS product_management CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE product_management;
CREATE TABLE IF NOT EXISTS products (
id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(150) NOT NULL,
price DECIMAL(12,2) NOT NULL, quantity INT NOT NULL
);
INSERT INTO products(name,price,quantity) VALUES
('Ban phim',850000,12),('Chuot',320000,24),('Man hinh',2950000,6),('Tai nghe',540000,18);