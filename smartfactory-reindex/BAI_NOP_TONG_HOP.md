# SmartFactory – bài nộp tổng hợp
## SQL
```sql
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

```
## Báo cáo
# Báo cáo SmartFactory – đánh đổi tốc độ và dung lượng
Covering Index `(sensor_id, recorded_at, temperature, humidity, status)` có thể trả dữ liệu Dashboard trực tiếp từ chỉ mục, giảm đọc bảng gốc. Tuy nhiên với hàng chục nghìn bản ghi cảm biến mỗi giây, index rộng khiến mỗi INSERT phải ghi và bảo trì entry B-Tree lớn hơn, tăng I/O, redo log và có nguy cơ page split. Ba cột temperature, humidity, status chỉ dùng để hiển thị, không cần thiết cho việc định vị bản ghi trong truy vấn này.

Lean Index `(sensor_id, recorded_at)` vẫn hỗ trợ điều kiện bằng và khoảng thời gian, nhưng truy vấn phải lookup bảng gốc để lấy ba cột còn lại. Chúng ta chấp nhận thêm lượt đọc để giảm chi phí ghi và lưu trữ. Với bảng Countries chỉ đọc, Covering Index vẫn có thể đáng dùng. Đổi status từ VARCHAR(20) sang TINYINT thường giảm Data Length; Index Length chỉ giảm trực tiếp nếu status được đánh index.

**Đo trước / sau:** Script cung cấp SHOW TABLE STATUS, information_schema.TABLES, SHOW INDEX và EXPLAIN. Chưa chạy trên dữ liệu thực tế, vì vậy không có số MB hay phần trăm giảm dung lượng được xác nhận. Những khẳng định nhanh gấp 5 lần/giảm 70% chỉ là giả định cần benchmark.

## Nhật ký AI và giải đáp vấn đáp
# Nhật ký AI – SmartFactory
**Ghi chú:** Đây là phần tổng hợp giải đáp kỹ thuật do AI hỗ trợ từ đề bài, không phải bản chép nguyên văn các câu hỏi riêng do học viên đã gửi.

**Hỏi:** Covering Index là gì?
**Đáp:** Chỉ mục chứa đủ cột cần thiết để SELECT không phải lookup bảng gốc; EXPLAIN có thể báo Using index.

**Hỏi:** Clustered vs Secondary Index InnoDB?
**Đáp:** Lá clustered index chứa bản ghi; lá secondary index chứa khóa phụ và khóa chính dùng tìm lại bản ghi ở clustered index.

**Hỏi:** Write Penalty là gì?
**Đáp:** INSERT thêm hàng ở clustered B-Tree và entry trong secondary B-Tree, phát sinh I/O, redo và có thể page split. Index rộng làm tăng chi phí.

**Hỏi:** Ước lượng byte?
**Đáp:** BIGINT 8 byte, INT 4 byte, DATETIME thường 5 byte, DECIMAL(5,2) khoảng 3 byte mỗi giá trị; VARCHAR(20) dùng độ dài biến thiên, tối đa 80 byte dữ liệu với utf8mb4 cộng byte lưu độ dài. Index còn metadata và khóa chính.

**Hỏi:** Nếu bảng Countries rất ít ghi?
**Đáp:** Covering Index có thể hợp lý; cần cân nhắc query workload và disk thay vì mặc định xóa.

**Hỏi:** status VARCHAR sang TINYINT?
**Đáp:** Có thể tiết kiệm data bytes, và tiết kiệm index bytes nếu status nằm trong index; cần ánh xạ mã trạng thái nhất quán.

**Cần xác minh:** Lấy ảnh EXPLAIN, DATA_LENGTH và INDEX_LENGTH trước/sau trên dữ liệu đủ lớn; không tự tạo số liệu.
