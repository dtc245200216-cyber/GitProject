-- Bai thuc hanh: Stored Procedure - CodeGym
-- Yeu cau: da import database classicmodels vao MySQL.
USE classicmodels;

-- Buoc 1: Tao procedure lay tat ca khach hang
DROP PROCEDURE IF EXISTS findAllCustomers;
DELIMITER //
CREATE PROCEDURE findAllCustomers()
BEGIN
    SELECT * FROM customers;
END //
DELIMITER ;

-- Buoc 2: Goi procedure, xem toan bo khach hang
CALL findAllCustomers();

-- Buoc 3: Xoa procedure cu, tao lai theo yeu cau
DROP PROCEDURE IF EXISTS findAllCustomers;
DELIMITER //
CREATE PROCEDURE findAllCustomers()
BEGIN
    SELECT *
    FROM customers
    WHERE customerNumber = 175;
END //
DELIMITER ;

-- Buoc 4: Goi lai de kiem tra customerNumber = 175
CALL findAllCustomers();

-- Buoc 5: Kiem tra procedure da luu trong database
SHOW PROCEDURE STATUS WHERE Db = 'classicmodels' AND Name = 'findAllCustomers';
SHOW CREATE PROCEDURE findAllCustomers;
