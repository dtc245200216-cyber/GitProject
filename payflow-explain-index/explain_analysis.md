# Phân tích EXPLAIN trước và sau tối ưu

Truy vấn cũ dùng `YEAR()` và `MONTH()` trên `created_at`, khiến điều kiện ngày không dùng hiệu quả B-Tree Index thông thường. Nếu chưa có index phù hợp, MySQL thường hiển thị `type = ALL`, `key = NULL`, `rows` gần bằng số dòng bảng.

Giải pháp tạo index kết hợp `(transaction_type, created_at)`, thay điều kiện hàm bằng khoảng thời gian từ `2026-06-01` đến trước `2026-07-01`. So sánh bằng trên cột thứ nhất và range trên cột thứ hai giúp MySQL tận dụng index.

Trên dữ liệu lớn đủ chọn lọc, kỳ vọng `type = range`, `possible_keys` và `key` xuất hiện `idx_type_date`, `rows` giảm đáng kể.

**Chưa có số liệu đo thực tế.** Optimizer có thể chọn `ALL` cho bảng nhỏ/rỗng hoặc khi điều kiện khớp phần lớn bảng. Phải chạy và chụp hai bản EXPLAIN trên dữ liệu thật để chứng minh cải thiện.
