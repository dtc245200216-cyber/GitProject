# QuickFeed – Bài nộp tổng hợp cho AI chấm

## SQL
```sql
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

```

## Báo cáo
# QuickFeed – Storage & Performance Report
## Ma trận quyết định
| Index | Quyết định | Lý do |
|---|---|---|
| idx_user_id | Giữ | Truy vấn bài theo người dùng |
| idx_created_at | Giữ | Lọc và sắp xếp thời gian |
| idx_content | Xóa | Tiền tố TEXT dài, tốn disk; cân nhắc FULLTEXT cho tìm kiếm từ khóa |
| idx_post_type | Xóa | 3 loại, ít phân biệt khi lọc đơn lẻ |
| idx_is_visible | Xóa | 2 loại, phần lớn hàng giống nhau |

## Báo cáo
Với InnoDB, INSERT một bài không chỉ ghi hàng dữ liệu trong clustered index (PRIMARY KEY) mà còn cập nhật 5 secondary B-Tree indexes. Điều này tăng I/O, redo log, số trang index và có thể phát sinh page split. Loại bỏ ba index dư thừa giảm ba cấu trúc chỉ mục cần duy trì mỗi lần thêm bài, nhưng không đồng nghĩa INSERT nhanh gấp ba lần.

Index tối ưu cho đọc có chọn lọc, song làm ghi chậm và tốn RAM/disk. Với 99% bài hiển thị, index đơn trên is_visible ít hữu dụng; optimizer có thể chọn table scan. Với bảng archive ít ghi, nhiều index không còn gây áp lực ghi lớn nhưng vẫn chiếm dung lượng.

**Số liệu trước/sau:** Chưa đo trên server MySQL thực tế. Script in `DATA_LENGTH`, `INDEX_LENGTH` theo MB trước/sau qua `information_schema.TABLES`. Cần chạy và chụp kết quả có dữ liệu để báo cáo. Thống kê InnoDB có thể là ước lượng; dung lượng vật lý không nhất thiết giảm tức thì.


## Nhật ký AI và vấn đáp
# Nhật ký hỗ trợ AI – QuickFeed
**Nguồn:** Tổng hợp giải đáp kỹ thuật từ tương tác AI khi cung cấp đề bài; không phải nhật ký từng câu hỏi tự gửi trước đó.

**Hỏi: Cardinality là gì?** Số giá trị phân biệt của cột/index. Boolean có 2 giá trị; nếu 99% là 1 thì lọc giá trị 1 bằng chỉ mục ít hiệu quả. Tuy nhiên index cardinality thấp không phải luôn vô dụng, có thể giúp tìm nhóm hiếm.

**Hỏi: Index TEXT dài ảnh hưởng gì?** B-Tree trên `content(255)` lưu tiền tố văn bản và khóa chính trong từng secondary entry, tốn pages và tăng chi phí ghi. Tìm từ khóa tự do nên cân nhắc FULLTEXT.

**Hỏi: InnoDB quản lý Data Pages và Index Pages thế nào?** Các trang được cấp phát trong tablespace. Clustered index chứa dữ liệu hàng; secondary index chứa khóa phụ và khóa chính. `DATA_LENGTH` / `INDEX_LENGTH` là thống kê dung lượng có thể ước lượng.

**Hỏi: Mỗi INSERT vào bảng 5 index diễn ra gì?** Ghi hàng clustered index cùng 5 secondary indexes, redo logs và các thao tác B-Tree; có thể chia trang. Bỏ 3 index giảm chi phí bảo trì 3 cây nhưng không bảo đảm thời gian cải thiện theo tỷ lệ tuyến tính.

**Hỏi: Nếu Posts là bảng archive?** Ít ghi nên nhiều index ít gây nghẽn INSERT; vẫn tốn disk và tài nguyên backup, chỉ giữ index cho truy vấn thực tế.

**Để bảo vệ trước giảng viên:** giải thích read/write trade-off, cardinality, lý do giữ idx_user_id / idx_created_at, và đo MB trước/sau từ EXPLAIN/SHOW TABLE STATUS/information_schema.

**Kết quả đo:** Chưa thực thi MySQL trên máy người học; không đưa số liệu tự tạo.
