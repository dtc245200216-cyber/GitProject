# Báo cáo SmartFactory – đánh đổi tốc độ và dung lượng
Covering Index `(sensor_id, recorded_at, temperature, humidity, status)` có thể trả dữ liệu Dashboard trực tiếp từ chỉ mục, giảm đọc bảng gốc. Tuy nhiên với hàng chục nghìn bản ghi cảm biến mỗi giây, index rộng khiến mỗi INSERT phải ghi và bảo trì entry B-Tree lớn hơn, tăng I/O, redo log và có nguy cơ page split. Ba cột temperature, humidity, status chỉ dùng để hiển thị, không cần thiết cho việc định vị bản ghi trong truy vấn này.

Lean Index `(sensor_id, recorded_at)` vẫn hỗ trợ điều kiện bằng và khoảng thời gian, nhưng truy vấn phải lookup bảng gốc để lấy ba cột còn lại. Chúng ta chấp nhận thêm lượt đọc để giảm chi phí ghi và lưu trữ. Với bảng Countries chỉ đọc, Covering Index vẫn có thể đáng dùng. Đổi status từ VARCHAR(20) sang TINYINT thường giảm Data Length; Index Length chỉ giảm trực tiếp nếu status được đánh index.

**Đo trước / sau:** Script cung cấp SHOW TABLE STATUS, information_schema.TABLES, SHOW INDEX và EXPLAIN. Chưa chạy trên dữ liệu thực tế, vì vậy không có số MB hay phần trăm giảm dung lượng được xác nhận. Những khẳng định nhanh gấp 5 lần/giảm 70% chỉ là giả định cần benchmark.
