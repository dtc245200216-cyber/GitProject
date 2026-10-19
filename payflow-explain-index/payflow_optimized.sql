CREATE DATABASE IF NOT EXISTS payflow_db;
USE payflow_db;

CREATE TABLE IF NOT EXISTS Transactions (
 transaction_id INT AUTO_INCREMENT PRIMARY KEY,
 user_id INT,
 amount DECIMAL(15,2),
 transaction_type VARCHAR(20),
 created_at DATETIME
) ENGINE=InnoDB;

-- EXPLAIN truy van cu, truoc khi tao index:
EXPLAIN SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type = 'DEPOSIT'
AND YEAR(created_at) = 2026 AND MONTH(created_at) = 6;

-- Chay mot lan:
CREATE INDEX idx_type_date ON Transactions(transaction_type, created_at);

-- EXPLAIN truy van toi uu SARGable:
EXPLAIN SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type = 'DEPOSIT'
AND created_at >= '2026-06-01 00:00:00'
AND created_at < '2026-07-01 00:00:00';

SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type = 'DEPOSIT'
AND created_at >= '2026-06-01 00:00:00'
AND created_at < '2026-07-01 00:00:00';

SHOW INDEX FROM Transactions;

-- MySQL 8.0.18+:
-- EXPLAIN ANALYZE SELECT SUM(amount) FROM Transactions
-- WHERE transaction_type = 'DEPOSIT'
-- AND created_at >= '2026-06-01' AND created_at < '2026-07-01';

-- Luu y: optimizer khong cam ket se chon range voi bang it du lieu.
