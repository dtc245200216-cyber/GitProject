CREATE DATABASE IF NOT EXISTS quickfeed_db;
USE quickfeed_db;
CREATE TABLE IF NOT EXISTS Posts (
 post_id INT AUTO_INCREMENT PRIMARY KEY,
 user_id INT NOT NULL, content TEXT,
 post_type VARCHAR(10), is_visible BOOLEAN DEFAULT 1,
 created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;
-- Tạo 5 index để mô phỏng trạng thái cũ (chỉ chạy một lần trên CSDL mới)
CREATE INDEX idx_user_id ON Posts(user_id);
CREATE INDEX idx_content ON Posts(content(255));
CREATE INDEX idx_post_type ON Posts(post_type);
CREATE INDEX idx_is_visible ON Posts(is_visible);
CREATE INDEX idx_created_at ON Posts(created_at);
-- ĐO TRƯỚC KHI XÓA
SHOW INDEX FROM Posts;
SHOW TABLE STATUS LIKE 'Posts';
SELECT TABLE_NAME, TABLE_ROWS,
 ROUND(DATA_LENGTH/1024/1024,3) AS data_mb,
 ROUND(INDEX_LENGTH/1024/1024,3) AS index_mb
FROM information_schema.TABLES
WHERE TABLE_SCHEMA='quickfeed_db' AND TABLE_NAME='Posts';
-- Bỏ ba index không cần thiết
ALTER TABLE Posts DROP INDEX idx_content;
ALTER TABLE Posts DROP INDEX idx_post_type;
ALTER TABLE Posts DROP INDEX idx_is_visible;
-- ĐO SAU KHI XÓA
ANALYZE TABLE Posts;
SHOW INDEX FROM Posts;
SHOW TABLE STATUS LIKE 'Posts';
SELECT TABLE_NAME, TABLE_ROWS,
 ROUND(DATA_LENGTH/1024/1024,3) AS data_mb,
 ROUND(INDEX_LENGTH/1024/1024,3) AS index_mb
FROM information_schema.TABLES
WHERE TABLE_SCHEMA='quickfeed_db' AND TABLE_NAME='Posts';
-- Còn PRIMARY, idx_user_id, idx_created_at.
-- Nếu Posts đã tồn tại và có index, bỏ qua phần CREATE ở trên.
