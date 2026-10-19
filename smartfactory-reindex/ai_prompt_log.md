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
