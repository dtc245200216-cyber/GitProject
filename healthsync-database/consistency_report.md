# HealthSync – Phân tích sự không nhất quán giữa nghiệp vụ và CSDL

**1. Lỗ hổng trạng thái.** Quy trình đặt lịch yêu cầu năm trạng thái: PENDING, CONFIRMED, CHECKED_IN, COMPLETED và CANCELLED. Tuy nhiên, bảng Appointments cũ chỉ có `is_active` kiểu BOOLEAN nên không thể xác định lịch đã được xác nhận cọc, bệnh nhân đã đến hay đã khám xong. Điều này khiến việc kiểm soát trình tự xử lý và báo cáo trở nên thiếu chính xác. Giải pháp là thay bằng `status ENUM` có giá trị mặc định PENDING.

**2. Thiếu dữ liệu tài chính khi hủy.** Hệ thống bắt buộc thu tiền cọc, ghi nhận lý do hủy và tính phí phạt khi bệnh nhân hủy sau khi xác nhận. Cấu trúc cũ không có `deposit_amount`, `penalty_fee` và `cancel_reason`, nên không thể đối soát khoản cọc và số tiền cần hoàn. Các khoản tiền được lưu bằng `DECIMAL(12,2)` và kiểm tra phí phạt không âm, không vượt quá tiền cọc.

**3. Thiếu liên kết đơn thuốc.** Bác sĩ phải có khả năng tạo đơn thuốc sau khi hoàn tất khám, nhưng CSDL không có bảng Prescriptions. Thiết kế bổ sung bảng đơn thuốc có khóa ngoại tới lịch hẹn, quy định tối đa một đơn thuốc cho mỗi lịch hẹn trong bản mẫu. Trigger kiểm tra trạng thái COMPLETED trước khi thêm đơn thuốc.

Những thay đổi này giúp ERD lưu trữ được các kết quả của Activity Diagram. Việc kiểm soát chuyển trạng thái hợp lệ còn cần triển khai thêm ở tầng ứng dụng hoặc bằng trigger chuyên biệt.
