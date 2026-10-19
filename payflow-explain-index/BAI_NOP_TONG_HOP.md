# BÀI THỰC HÀNH PAYFLOW – EXPLAIN VÀ INDEX

> Bài nộp tổng hợp để hệ thống chấm có thể đọc một URL. Ba file gốc vẫn được lưu riêng ở cùng thư mục.

## 1. Mã SQL: payflow_optimized.sql

```sql
CREATE DATABASE IF NOT EXISTS payflow_db;
USE payflow_db;
CREATE TABLE IF NOT EXISTS Transactions (
 transaction_id INT AUTO_INCREMENT PRIMARY KEY,
 user_id INT,
 amount DECIMAL(15,2),
 transaction_type VARCHAR(20),
 created_at DATETIME
) ENGINE=InnoDB;

-- Truy vấn cũ:
EXPLAIN SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type = 'DEPOSIT'
AND YEAR(created_at)=2026 AND MONTH(created_at)=6;

-- Tạo index (thực hiện một lần):
CREATE INDEX idx_type_date ON Transactions(transaction_type, created_at);

-- Truy vấn đã tối ưu:
EXPLAIN SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type='DEPOSIT'
AND created_at >= '2026-06-01 00:00:00'
AND created_at < '2026-07-01 00:00:00';

SELECT SUM(amount) AS total_deposit
FROM Transactions
WHERE transaction_type='DEPOSIT'
AND created_at >= '2026-06-01 00:00:00'
AND created_at < '2026-07-01 00:00:00';
SHOW INDEX FROM Transactions;
```

## 2. Nội dung explain_analysis.md (dưới 200 từ)

Truy vấn cũ gọi YEAR() và MONTH() trên created_at, làm điều kiện lọc không thể khai thác hiệu quả index B-Tree thông thường. Trước khi tạo index, EXPLAIN thường trả type=ALL, key=NULL, rows xấp xỉ tổng số dòng. Sau khi tạo index (transaction_type, created_at), truy vấn mới lọc bằng transaction_type và dùng khoảng ngày [2026-06-01, 2026-07-01), nên MySQL có thể chọn type=range, key=idx_type_date và quét ít dòng hơn.

Các giá trị type, rows, Extra thực tế còn phụ thuộc dung lượng, phân bố dữ liệu và thống kê của optimizer. Chưa có kết quả EXPLAIN được đo trên hệ thống thật; không thể khẳng định số dòng hay thời gian tiết kiệm cụ thể.

## 3. Nội dung ai_prompt_log.md – Nhật ký học tập có hỗ trợ AI

*Ghi chú: Đây là phần tổng hợp giải đáp AI trong cuộc trò chuyện hiện tại, không phải bằng chứng các câu hỏi đã được người học tự đặt trước đó.*

**Câu hỏi:** YEAR(created_at) ảnh hưởng index thế nào?

**Giải đáp:** Hàm bọc trực tiếp trên cột thường làm điều kiện non-SARGable; MySQL khó dùng chỉ mục thường để tìm phạm vi. Có thể viết lại bằng điều kiện thời gian >= đầu tháng và < đầu tháng sau.

**Câu hỏi:** Vì sao thứ tự composite index là (transaction_type, created_at)?

**Giải đáp:** transaction_type có điều kiện bằng; created_at có điều kiện khoảng. Thứ tự đó phù hợp tiền tố trái của B-Tree.

**Câu hỏi:** Index Seek khác Index Scan như thế nào?

**Giải đáp:** Seek định vị một vùng khóa phù hợp, scan quét dọc nhiều entry hoặc toàn bộ index. Phải xét thực tế theo EXPLAIN.

**Câu hỏi:** Using index condition khác Using index như thế nào?

**Giải đáp:** Using index condition là Index Condition Pushdown, dùng điều kiện trên index để giảm đọc hàng; Using index thường thể hiện covering index.

**Câu hỏi:** Tại sao không chắc type sau tối ưu luôn là range?

**Giải đáp:** Optimizer có thể chọn ALL nếu bảng ít dòng hoặc phần lớn bản ghi thỏa điều kiện; index không bảo đảm hiệu năng tốt nhất trong mọi trường hợp.

## 4. Bảo vệ giải pháp – trả lời câu hỏi vấn đáp

**Câu 1: WHERE có thực sự được thực thi trước SELECT?**

Về thứ tự xử lý logic, FROM/JOIN tạo tập dữ liệu, WHERE lọc dòng, GROUP BY gom nhóm, HAVING lọc nhóm, SELECT tạo giá trị đầu ra, ORDER BY sắp xếp và LIMIT giới hạn. Bộ tối ưu có thể đổi thứ tự thực thi vật lý để giảm chi phí. WHERE thường lọc trước khi tính toán đầu ra SELECT để giảm dữ liệu cần xử lý.

**Câu 2: Full Table Scan là gì, bao giờ nó nhanh hơn Index Scan?**

Full Table Scan đọc các dòng của bảng để kiểm tra điều kiện. Với bảng rất nhỏ, hoặc truy vấn phải lấy hầu hết dòng (ví dụ 90%), đọc tuần tự toàn bảng có thể ít tốn kém hơn hàng loạt lần truy cập index rồi đọc row.

**Câu 3: Tại sao không tạo càng nhiều index càng tốt?**

Mỗi index chiếm dung lượng và phát sinh công việc duy trì khi INSERT/UPDATE/DELETE. Với hệ thống giao dịch cao, quá nhiều index làm tăng ghi, I/O, sử dụng bộ nhớ và độ trễ; cần chọn index theo truy vấn thực tế.

## 5. Các file bài làm riêng

- [payflow_optimized.sql](payflow_optimized.sql)
- [explain_analysis.md](explain_analysis.md)
- [ai_prompt_log.md](ai_prompt_log.md)

**Kiểm chứng:** Hãy chạy EXPLAIN trước/sau bằng MySQL Workbench và bổ sung ảnh kết quả. Đây không phải số đo hiệu năng thực tế.
