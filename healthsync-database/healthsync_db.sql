-- HealthSync: bài thực hành đối chiếu nghiệp vụ và CSDL
-- Chạy trên MySQL 8.0.16+ trong database thực hành. Script dùng để học tập,
-- chứa dữ liệu mô phỏng, không dùng cho bệnh án thực tế.
CREATE DATABASE IF NOT EXISTS healthsync_db CHARACTER SET utf8mb4;
USE healthsync_db;

-- 1. Cấu trúc legacy (tạo từ đầu để có thể thực hành ALTER)
CREATE TABLE Patients (
  patient_id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  phone VARCHAR(15) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE Doctors (
  doctor_id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  specialty VARCHAR(50)
) ENGINE=InnoDB;

CREATE TABLE Appointments (
  appointment_id INT AUTO_INCREMENT PRIMARY KEY,
  patient_id INT,
  doctor_id INT,
  appointment_date DATETIME NOT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
  FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
) ENGINE=InnoDB;

-- 2. Nâng cấp schema bằng ALTER TABLE
ALTER TABLE Appointments
  ADD COLUMN status ENUM('PENDING','CONFIRMED','CHECKED_IN','COMPLETED','CANCELLED')
    NOT NULL DEFAULT 'PENDING',
  ADD COLUMN deposit_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
  ADD COLUMN penalty_fee DECIMAL(12,2) NOT NULL DEFAULT 0,
  ADD COLUMN cancel_reason VARCHAR(255) NULL,
  ADD CONSTRAINT chk_deposit_nonnegative CHECK (deposit_amount >= 0),
  ADD CONSTRAINT chk_penalty_valid CHECK (penalty_fee >= 0 AND penalty_fee <= deposit_amount);
ALTER TABLE Appointments DROP COLUMN is_active;

-- Mỗi lịch hẹn tối đa một đơn thuốc (UNIQUE appointment_id)
CREATE TABLE Prescriptions (
  prescription_id INT AUTO_INCREMENT PRIMARY KEY,
  appointment_id INT NOT NULL UNIQUE,
  medication_details TEXT NOT NULL,
  issued_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_prescription_appointment
    FOREIGN KEY (appointment_id) REFERENCES Appointments(appointment_id)
    ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 3. Trigger: không cho kê đơn khi lịch hẹn chưa COMPLETED
DELIMITER //
CREATE TRIGGER trg_prescriptions_completed
BEFORE INSERT ON Prescriptions FOR EACH ROW
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM Appointments
    WHERE appointment_id = NEW.appointment_id AND status = 'COMPLETED'
  ) THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Only COMPLETED appointments can have prescriptions';
  END IF;
END//
DELIMITER ;

-- 4. Mô phỏng dữ liệu (hai lịch hẹn mới)
INSERT INTO Patients(full_name,phone)
VALUES ('Benh nhan A','0900000001'),('Benh nhan B','0900000002');
INSERT INTO Doctors(full_name,specialty)
VALUES ('Bac si Minh','Noi tong quat');

SET @patient_a = (SELECT patient_id FROM Patients WHERE phone='0900000001' ORDER BY patient_id DESC LIMIT 1);
SET @patient_b = (SELECT patient_id FROM Patients WHERE phone='0900000002' ORDER BY patient_id DESC LIMIT 1);
SET @doctor = (SELECT doctor_id FROM Doctors ORDER BY doctor_id DESC LIMIT 1);

-- Kịch bản 1: chờ -> xác nhận cọc -> đến khám -> hoàn tất -> kê đơn
INSERT INTO Appointments(patient_id,doctor_id,appointment_date,status,deposit_amount)
VALUES (@patient_a,@doctor,'2026-11-01 09:00:00','PENDING',500000.00);
SET @success_id = LAST_INSERT_ID();
UPDATE Appointments SET status='CONFIRMED' WHERE appointment_id=@success_id;
UPDATE Appointments SET status='CHECKED_IN' WHERE appointment_id=@success_id;
UPDATE Appointments SET status='COMPLETED' WHERE appointment_id=@success_id;
INSERT INTO Prescriptions(appointment_id,medication_details)
VALUES (@success_id,'Don thuoc minh hoa: can bac si xac nhan thong tin thuc te');

-- Kịch bản 2: đã xác nhận, hủy và phạt 150.000đ
INSERT INTO Appointments(patient_id,doctor_id,appointment_date,status,deposit_amount)
VALUES (@patient_b,@doctor,'2026-11-02 10:00:00','CONFIRMED',300000.00);
SET @cancelled_id = LAST_INSERT_ID();
UPDATE Appointments
SET status='CANCELLED', cancel_reason='Bận việc đột xuất', penalty_fee=150000.00
WHERE appointment_id=@cancelled_id;

-- 5. Đối soát trạng thái, tiền cọc, tiền phạt, tiền hoàn và đơn thuốc
SELECT a.appointment_id, p.full_name AS patient_name, a.status,
       a.deposit_amount, a.penalty_fee,
       (a.deposit_amount - a.penalty_fee) AS deposit_after_penalty,
       a.cancel_reason, pr.prescription_id, pr.medication_details
FROM Appointments a
JOIN Patients p ON p.patient_id=a.patient_id
LEFT JOIN Prescriptions pr ON pr.appointment_id=a.appointment_id
WHERE a.appointment_id IN (@success_id,@cancelled_id)
ORDER BY a.appointment_id;

-- Chỉ các ca COMPLETED có đơn thuốc
SELECT p.full_name, a.appointment_id, pr.medication_details, pr.issued_date
FROM Appointments a
JOIN Patients p ON p.patient_id=a.patient_id
JOIN Prescriptions pr ON pr.appointment_id=a.appointment_id
WHERE a.status='COMPLETED';

-- Gợi ý kiểm thử trigger (KHÔNG chạy nếu không muốn thấy lỗi dự kiến):
-- INSERT INTO Prescriptions(appointment_id,medication_details)
-- VALUES (@cancelled_id,'Phai bi tu choi vi lich hen CANCELLED');
