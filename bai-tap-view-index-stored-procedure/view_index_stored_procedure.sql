-- CODEGYM: VIEW, INDEX, STORED PROCEDURE (MySQL 8.0+)
-- Chay tren CSDL thuc hanh demo; chi chay phan tao bang/dieu lieu mot lan.
CREATE DATABASE IF NOT EXISTS demo;
USE demo;

CREATE TABLE IF NOT EXISTS Products (
  Id INT AUTO_INCREMENT PRIMARY KEY,
  productCode VARCHAR(30) NOT NULL,
  productName VARCHAR(100) NOT NULL,
  productPrice DECIMAL(12,2) NOT NULL,
  productAmount INT NOT NULL DEFAULT 0,
  productDescription TEXT,
  productStatus VARCHAR(30) NOT NULL,
  CHECK(productPrice >= 0),
  CHECK(productAmount >= 0)
) ENGINE=InnoDB;

INSERT INTO Products(productCode,productName,productPrice,productAmount,productDescription,productStatus)
VALUES
 ('P001','Laptop Dell',15000000,12,'Laptop van phong','AVAILABLE'),
 ('P002','Chuot Logitech',350000,30,'Chuot khong day','AVAILABLE'),
 ('P003','Ban phim co',1200000,18,'Ban phim gaming','AVAILABLE'),
 ('P004','Man hinh Samsung',3500000,9,'Man hinh 24 inch','AVAILABLE'),
 ('P005','Tai nghe Sony',950000,0,'Tai nghe bluetooth','OUT_OF_STOCK');

-- 1. EXPLAIN truoc khi tao index (bang nho co the van dung ALL)
EXPLAIN SELECT * FROM Products WHERE productCode='P003';
EXPLAIN SELECT * FROM Products WHERE productName='Laptop Dell' AND productPrice=15000000;

-- 2. Tao hai index theo yeu cau
CREATE UNIQUE INDEX idx_product_code ON Products(productCode);
CREATE INDEX idx_product_name_price ON Products(productName,productPrice);

-- 3. EXPLAIN sau khi tao index
EXPLAIN SELECT * FROM Products WHERE productCode='P003';
EXPLAIN SELECT * FROM Products WHERE productName='Laptop Dell' AND productPrice=15000000;
SHOW INDEX FROM Products;

-- 4. Tao, truy van, sua va xoa VIEW
CREATE OR REPLACE VIEW product_view AS
SELECT productCode,productName,productPrice,productStatus FROM Products;
SELECT * FROM product_view;

CREATE OR REPLACE VIEW product_view AS
SELECT productCode,productName,productPrice,productStatus
FROM Products WHERE productStatus='AVAILABLE';
SELECT * FROM product_view;
DROP VIEW IF EXISTS product_view;

-- 5. Stored procedures: xem, them, sua, xoa
DROP PROCEDURE IF EXISTS sp_get_all_products;
DROP PROCEDURE IF EXISTS sp_add_product;
DROP PROCEDURE IF EXISTS sp_update_product;
DROP PROCEDURE IF EXISTS sp_delete_product;

DELIMITER $$
CREATE PROCEDURE sp_get_all_products()
BEGIN
  SELECT * FROM Products ORDER BY Id;
END$$

CREATE PROCEDURE sp_add_product(
 IN p_code VARCHAR(30), IN p_name VARCHAR(100),
 IN p_price DECIMAL(12,2), IN p_amount INT,
 IN p_description TEXT, IN p_status VARCHAR(30)
)
BEGIN
  INSERT INTO Products(productCode,productName,productPrice,productAmount,productDescription,productStatus)
  VALUES(p_code,p_name,p_price,p_amount,p_description,p_status);
END$$

CREATE PROCEDURE sp_update_product(
 IN p_id INT, IN p_code VARCHAR(30), IN p_name VARCHAR(100),
 IN p_price DECIMAL(12,2), IN p_amount INT,
 IN p_description TEXT, IN p_status VARCHAR(30)
)
BEGIN
  UPDATE Products
  SET productCode=p_code,productName=p_name,productPrice=p_price,
      productAmount=p_amount,productDescription=p_description,productStatus=p_status
  WHERE Id=p_id;
END$$

CREATE PROCEDURE sp_delete_product(IN p_id INT)
BEGIN
  DELETE FROM Products WHERE Id=p_id;
END$$
DELIMITER ;

-- 6. Goi thu kiem tra CRUD
CALL sp_get_all_products();
CALL sp_add_product('P006','USB Kingston',180000,15,'USB 64GB','AVAILABLE');
SET @new_product_id = LAST_INSERT_ID();
CALL sp_update_product(@new_product_id,'P006','USB Kingston 64GB',190000,20,'USB 64GB USB 3.2','AVAILABLE');
SELECT * FROM Products WHERE Id=@new_product_id;
CALL sp_delete_product(@new_product_id);
SELECT * FROM Products WHERE Id=@new_product_id;
CALL sp_get_all_products();
