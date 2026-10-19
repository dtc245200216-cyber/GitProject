CREATE DATABASE IF NOT EXISTS smartfactory_db;
USE smartfactory_db;
CREATE TABLE IF NOT EXISTS SensorLogs (
 log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
 sensor_id INT NOT NULL,
 recorded_at DATETIME NOT NULL,
 temperature DECIMAL(5,2),
 humidity DECIMAL(5,2),
 status VARCHAR(20)
) ENGINE=InnoDB;
-- On an existing legacy database that already has this index, skip CREATE:
CREATE INDEX idx_fat_covering ON SensorLogs(sensor_id, recorded_at, temperature, humidity, status);

-- BEFORE: capture metrics
SHOW TABLE STATUS LIKE 'SensorLogs';
SELECT TABLE_NAME, TABLE_ROWS,
 ROUND(DATA_LENGTH/1024/1024,3) AS data_mb,
 ROUND(INDEX_LENGTH/1024/1024,3) AS index_mb
FROM information_schema.TABLES
WHERE TABLE_SCHEMA='smartfactory_db' AND TABLE_NAME='SensorLogs';
SHOW INDEX FROM SensorLogs;
EXPLAIN SELECT temperature, humidity, status FROM SensorLogs
WHERE sensor_id=105 AND recorded_at >= '2026-06-20';

-- Create lean index before removing the oversized old index
CREATE INDEX idx_lean_search ON SensorLogs(sensor_id, recorded_at);
ALTER TABLE SensorLogs DROP INDEX idx_fat_covering;
ANALYZE TABLE SensorLogs;

-- AFTER: capture same metrics
SHOW TABLE STATUS LIKE 'SensorLogs';
SELECT TABLE_NAME, TABLE_ROWS,
 ROUND(DATA_LENGTH/1024/1024,3) AS data_mb,
 ROUND(INDEX_LENGTH/1024/1024,3) AS index_mb
FROM information_schema.TABLES
WHERE TABLE_SCHEMA='smartfactory_db' AND TABLE_NAME='SensorLogs';
SHOW INDEX FROM SensorLogs;
EXPLAIN SELECT temperature, humidity, status FROM SensorLogs
WHERE sensor_id=105 AND recorded_at >= '2026-06-20';
-- MySQL optimizer may choose ALL for empty/tiny tables.
-- Data/index length may be estimates; OS file size might not shrink immediately.
