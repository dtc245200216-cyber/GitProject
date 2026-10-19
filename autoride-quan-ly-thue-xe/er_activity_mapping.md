# AutoRide – ERD / Activity Diagram Mapping

Quy trình thực tế yêu cầu khách đặt xe phải cọc, sau đó nhận xe, trả xe và được kiểm tra tình trạng trước khi hoàn tất hợp đồng. Thiết kế cũ thiếu ít nhất ba điểm quan trọng: trạng thái lưu tự do bằng VARCHAR, không có thông tin tài chính, và không có bảng biên bản kiểm tra xe.

**Damage fee là dữ liệu bắt buộc** vì kết quả kiểm tra xe có thể phát sinh chi phí sửa chữa. Nếu chỉ lưu ghi chú hư hỏng mà không ghi số tiền phạt, kế toán không xác định được khoản cần trừ, dẫn đến trả dư tiền cọc và báo cáo lợi nhuận sai. Sử dụng DECIMAL tránh sai số số thực khi tính tiền.

Bảng Inspections được tách riêng khỏi Rentals để lưu người kiểm tra, thời điểm và nhiều lần kiểm tra nếu cần. Khóa ngoại với ON DELETE RESTRICT giữ biên bản không bị mất khi xóa hợp đồng. Trạng thái ENUM giới hạn BOOKED, ACTIVE, COMPLETED, CANCELLED; trigger có thể chặn kiểm tra khi hợp đồng chưa ACTIVE.

Tiền hoàn = security_deposit - late_fee - damage_fee. Cần bổ sung chính sách xử lý khi tổng phí vượt tiền cọc.
