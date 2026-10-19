-- CodeGym: Thuc hanh View trong MySQL
-- Yeu cau: da import CSDL mau classicmodels (co bang customers).
USE classicmodels;

-- Buoc 1: Tao view gom customerNumber, customerName va phone.
CREATE OR REPLACE VIEW customer_views AS
SELECT customerNumber, customerName, phone
FROM customers;

-- Buoc 2: Truy van view vua tao.
SELECT * FROM customer_views;

-- Buoc 3: Cap nhat dinh nghia view: them ten nguoi lien he
-- va chi lay cac khach hang o Nantes.
CREATE OR REPLACE VIEW customer_views AS
SELECT customerNumber, customerName, contactFirstName, contactLastName, phone
FROM customers
WHERE city = 'Nantes';

-- Buoc 4: Kiem tra ket qua sau khi cap nhat view.
SELECT * FROM customer_views;

-- Buoc 5: Xoa view khi khong can su dung nua.
DROP VIEW IF EXISTS customer_views;

-- Kiem tra view da duoc xoa (ket qua rong).
SHOW FULL TABLES FROM classicmodels
WHERE Table_type = 'VIEW' AND Tables_in_classicmodels = 'customer_views';
