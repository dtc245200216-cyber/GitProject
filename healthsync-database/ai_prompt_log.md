# AI Prompt Log – HealthSync

## Mục đích
Ghi lại vai trò hỗ trợ của AI khi phân tích bài toán; đây là bản tóm tắt các trao đổi thực tế trong phiên này, không phải nhật ký tự nhập prompt giả định.

### Trao đổi 1 – Đối chiếu yêu cầu với thiết kế cũ
**Đầu vào:** Đề bài HealthSync gồm các bước khám, trạng thái, tiền cọc, phí phạt và đơn thuốc.
**AI hỗ trợ:** Xác định việc `is_active BOOLEAN` không đủ biểu diễn quy trình nhiều trạng thái; gợi ý `ENUM` và trường theo dõi tiền cọc, hủy.

### Trao đổi 2 – Kiểu dữ liệu tiền
**Nội dung thảo luận:** Chọn kiểu dữ liệu cho `deposit_amount` và `penalty_fee`.
**Kết luận kỹ thuật:** Dùng `DECIMAL(12,2)` thay vì `FLOAT`/`DOUBLE` vì phép tính tài chính cần biểu diễn thập phân chính xác hơn.

### Trao đổi 3 – Toàn vẹn tham chiếu và đơn thuốc
**Nội dung thảo luận:** Quan hệ Appointments – Prescriptions; rủi ro kê đơn khi lịch chưa hoàn tất.
**Kết luận:** Dùng khóa ngoại `appointment_id`, `UNIQUE` để giới hạn 1–1 theo yêu cầu bản mẫu, `ON DELETE RESTRICT`; tạo trigger `BEFORE INSERT` từ chối kê đơn khi lịch không ở trạng thái `COMPLETED`.

### Tự kiểm tra cần thực hiện
- Chạy script trong MySQL Workbench 8.0.16+.
- Kiểm tra kết quả SELECT của hai kịch bản và trigger chặn thao tác sai.
- Chụp màn hình kết quả thực thi nếu giảng viên yêu cầu.

**Giới hạn:** Chưa có dữ liệu chạy thật hoặc ảnh minh chứng trong nhật ký này; file SQL là bản mẫu tham khảo cần được học viên rà soát và kiểm thử.
