-- AutoRide: script minh hoa cho MySQL 8.0.16+
-- CHI CHAY TREN CSDL THUC HANH. Khong DROP du lieu hien huu.
CREATE DATABASE IF NOT EXISTS autoride_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE autoride_db;

-- 1. Legacy (tao neu chua co)
CREATE TABLE IF NOT EXISTS Cars (
  car_id INT AUTO_INCREMENT PRIMARY KEY,
  model_name VARCHAR(100) NOT NULL,
  license_plate VARCHAR(20) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Rentals (
  rental_id INT AUTO_INCREMENT PRIMARY KEY,
  car_id INT,
  customer_name VARCHAR(100) NOT NULL,
  rent_date DATETIME NOT NULL,
  return_date DATETIME,
  status VARCHAR(50) DEFAULT 'BOOKED',
  CONSTRAINT fk_rentals_car FOREIGN KEY (car_id) REFERENCES Cars(car_id)
) ENGINE=InnoDB;

-- 2. Nang cap bang bang ALTER TABLE
-- Neu trong Rentals da co trang thai khac 4 gia tri duoi day,
-- can lam sach du lieu truoc khi ALTER.
ALTER TABLE Rentals
  MODIFY COLUMN status ENUM('BOOKED','ACTIVE','COMPLETED','CANCELLED')
    NOT NULL DEFAULT 'BOOKED',
  ADD COLUMN security_deposit DECIMAL(15,2) NOT NULL DEFAULT 0,
  ADD COLUMN late_fee DECIMAL(15,2) NOT NULL DEFAULT 0,
  ADD COLUMN damage_fee DECIMAL(15,2) NOT NULL DEFAULT 0,
  ADD CONSTRAINT chk_autoride_amounts
    CHECK (security_deposit >= 0 AND late_fee >= 0 AND damage_fee >= 0);

-- Cho phep nhieu bien ban kiem tra tren mot lan thue (1-N).
CREATE TABLE IF NOT EXISTS Inspections (
  inspection_id INT AUTO_INCREMENT PRIMARY KEY,
  rental_id INT NOT NULL,
  inspection_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  damage_description TEXT,
  inspector_name VARCHAR(100) NOT NULL,
  CONSTRAINT fk_inspections_rental
    FOREIGN KEY (rental_id) REFERENCES Rentals(rental_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 3. Trigger ngan tao bien ban cho hop dong BOOKED/CANCELLED.
DELIMITER $$
CREATE TRIGGER trg_inspection_rental_active
BEFORE INSERT ON Inspections
FOR EACH ROW
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM Rentals
    WHERE rental_id = NEW.rental_id AND status IN ('ACTIVE','COMPLETED')
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Inspection requires ACTIVE or COMPLETED rental';
  END IF;
END$$
DELIMITER ;

-- 4. Tinh huong minh hoa: Nguyen Van A thue xe va vo den pha
INSERT INTO Cars(model_name,license_plate)
VALUES ('Toyota Vios','DEMO-AR-001')
ON DUPLICATE KEY UPDATE model_name=VALUES(model_name);
SET @car_id = (SELECT car_id FROM Cars WHERE license_plate='DEMO-AR-001');

INSERT INTO Rentals(car_id,customer_name,rent_date,return_date,status,security_deposit)
VALUES (@car_id,'Nguyen Van A','2026-10-20 08:00:00','2026-10-22 08:00:00',
  'ACTIVE',10000000.00);
SET @rental_id=LAST_INSERT_ID();

INSERT INTO Inspections(rental_id,inspection_date,damage_description,inspector_name)
VALUES (@rental_id,'2026-10-22 08:15:00','Vỡ đèn pha trái','Nhan vien kiem tra');

UPDATE Rentals
SET status='COMPLETED', late_fee=0, damage_fee=2000000.00
WHERE rental_id=@rental_id;

-- 5. Doi soat. Ky vong tien hoan = 8.000.000 VND.
SELECT r.rental_id, r.customer_name, r.status,
       i.damage_description, r.security_deposit,
       r.late_fee, r.damage_fee,
       (r.security_deposit - r.late_fee - r.damage_fee) AS refund_amount
FROM Rentals r
LEFT JOIN Inspections i ON i.rental_id=r.rental_id
WHERE r.rental_id=@rental_id;

-- Kiem thu them: tre 2 ngay (nhap phi phat tre theo chinh sach cong ty)
-- UPDATE Rentals SET late_fee=500000 WHERE rental_id=@rental_id;
-- SELECT security_deposit-late_fee-damage_fee AS refund_amount
-- FROM Rentals WHERE rental_id=@rental_id;

-- GHI CHU: Mau minh hoa chua han che phi > coc, va khong tu tinh phi tre
-- vi de bai chua co chinh sach don gia phat theo ngay.
-- Script ALTER/TRIGGER chi chay mot lan tren schema moi; khi chay lai
-- can kiem tra cot/trigger da ton tai.
