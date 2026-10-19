-- Bai tap: Thao tac voi CSDL QuanLyBanHang (MySQL 8.0+)
-- Chay sau khi da tao 4 bang o bai truoc, tren CSDL thuc hanh.
USE QuanLyBanHang;

-- Bai truoc khai bao oTotalPrice NOT NULL DEFAULT 0.
-- De luu NULL dung bang du lieu cua de bai, sua cot nay.
ALTER TABLE Orders MODIFY COLUMN oTotalPrice DECIMAL(15,2) NULL DEFAULT NULL;

-- 1. Them du lieu vao 4 bang (chi chay mot lan, de tranh trung khoa)
INSERT INTO Customer (cID, cName, cAge) VALUES
(1, 'Minh Quan', 10),
(2, 'Ngoc Oanh', 20),
(3, 'Hong Ha', 50);

INSERT INTO Orders (oID, cID, oDate, oTotalPrice) VALUES
(1, 1, '2006-03-21', NULL),
(2, 2, '2006-03-23', NULL),
(3, 1, '2006-03-16', NULL);

INSERT INTO Product (pID, pName, pPrice) VALUES
(1, 'May Giat', 3),
(2, 'Tu Lanh', 5),
(3, 'Dieu Hoa', 7),
(4, 'Quat', 1),
(5, 'Bep Dien', 2);

INSERT INTO OrderDetail (oID, pID, odQTY) VALUES
(1, 1, 3),
(1, 3, 7),
(1, 4, 2),
(2, 1, 1),
(3, 1, 8),
(2, 5, 4),
(2, 3, 3);

-- 2. Hien thi oID, oDate va oPrice (oTotalPrice chua duoc tinh)
SELECT oID, oDate, oTotalPrice AS oPrice
FROM Orders
ORDER BY oID;

-- 3. Khach da mua hang va san pham ho da mua
SELECT DISTINCT c.cID, c.cName, p.pID, p.pName
FROM Customer c
JOIN Orders o ON o.cID = c.cID
JOIN OrderDetail od ON od.oID = o.oID
JOIN Product p ON p.pID = od.pID
ORDER BY c.cID, p.pID;

-- 4. Khach khong mua bat ky san pham nao
SELECT c.cID, c.cName
FROM Customer c
WHERE NOT EXISTS (
  SELECT 1
  FROM Orders o
  JOIN OrderDetail od ON od.oID = o.oID
  WHERE o.cID = c.cID
)
ORDER BY c.cID;

-- 5. Ma hoa don, ngay ban, tong gia moi hoa don
-- Dung LEFT JOIN de van hien thi hoa don neu chua co chi tiet.
SELECT o.oID, o.oDate,
       COALESCE(SUM(od.odQTY * p.pPrice), 0) AS oPrice
FROM Orders o
LEFT JOIN OrderDetail od ON od.oID = o.oID
LEFT JOIN Product p ON p.pID = od.pID
GROUP BY o.oID, o.oDate
ORDER BY o.oID;

-- Gia tri du kien: hoa don 1 = 60, hoa don 2 = 30, hoa don 3 = 24.
