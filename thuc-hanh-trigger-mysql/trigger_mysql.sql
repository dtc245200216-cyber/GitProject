-- CodeGym - Thuc hanh Trigger trong MySQL
-- Tao database va bang employees
CREATE DATABASE IF NOT EXISTS company;
USE company;

CREATE TABLE IF NOT EXISTS employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    department VARCHAR(50) NOT NULL,
    salary DECIMAL(10,2) NOT NULL
);

-- Xoa trigger cu (neu co) de co the tao lai khi thuc hanh
DROP TRIGGER IF EXISTS update_department;

-- Tu dong gan department dua theo salary truoc khi INSERT
DELIMITER //
CREATE TRIGGER update_department
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary >= 5000 THEN
        SET NEW.department = 'Management';
    ELSEIF NEW.salary >= 3000 THEN
        SET NEW.department = 'Sales';
    ELSE
        SET NEW.department = 'Support';
    END IF;
END //
DELIMITER ;

-- Chen ba nhan vien mau; department ban dau la 'A'
INSERT INTO employees (name, department, salary)
VALUES
    ('John Doe', 'A', 3500),
    ('Jane Smith', 'A', 2000),
    ('David Johnson', 'A', 6000);

-- Kiem tra ket qua trigger
SELECT id, name, department, salary
FROM employees
WHERE name IN ('John Doe', 'Jane Smith', 'David Johnson')
ORDER BY id;

-- Ket qua du kien:
-- John Doe       | Sales      | 3500.00
-- Jane Smith     | Support    | 2000.00
-- David Johnson  | Management | 6000.00
