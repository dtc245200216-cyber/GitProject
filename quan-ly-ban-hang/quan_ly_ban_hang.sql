-- CodeGym: Xay dung CSDL QuanLyBanHang
-- Chay tren MySQL Workbench (MySQL 8.0+)
CREATE DATABASE IF NOT EXISTS QuanLyBanHang
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE QuanLyBanHang;

-- Khach hang co the chua tung mua hang.
CREATE TABLE IF NOT EXISTS Customer (
  cID INT NOT NULL AUTO_INCREMENT,
  cName VARCHAR(100) NOT NULL,
  cAge TINYINT UNSIGNED,
  PRIMARY KEY (cID)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Product (
  pID INT NOT NULL AUTO_INCREMENT,
  pName VARCHAR(100) NOT NULL,
  pPrice DECIMAL(15,2) NOT NULL,
  PRIMARY KEY (pID),
  CONSTRAINT chk_product_price CHECK (pPrice >= 0)
) ENGINE=InnoDB;

-- Su dung Orders (khong dung Order) de tranh trung tu khoa ORDER.
CREATE TABLE IF NOT EXISTS Orders (
  oID INT NOT NULL AUTO_INCREMENT,
  cID INT NOT NULL,
  oDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  oTotalPrice DECIMAL(15,2) NOT NULL DEFAULT 0,
  PRIMARY KEY (oID),
  CONSTRAINT fk_orders_customer FOREIGN KEY (cID) REFERENCES Customer(cID)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_order_total CHECK (oTotalPrice >= 0)
) ENGINE=InnoDB;

-- Bang trung gian cho quan he nhieu-nhieu giua hoa don va san pham.
CREATE TABLE IF NOT EXISTS OrderDetail (
  oID INT NOT NULL,
  pID INT NOT NULL,
  odQTY INT NOT NULL,
  PRIMARY KEY (oID,pID),
  CONSTRAINT fk_orderdetail_orders FOREIGN KEY (oID) REFERENCES Orders(oID)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_orderdetail_product FOREIGN KEY (pID) REFERENCES Product(pID)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_order_quantity CHECK (odQTY >= 1)
) ENGINE=InnoDB;

-- Kiem tra cau truc
SHOW TABLES;
SHOW CREATE TABLE Customer;
SHOW CREATE TABLE Product;
SHOW CREATE TABLE Orders;
SHOW CREATE TABLE OrderDetail;
