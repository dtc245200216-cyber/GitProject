# Nhật ký AI hỗ trợ thiết kế AutoRide

**Lưu ý minh bạch:** Đây là nhật ký của tương tác hiện tại. Người học đã cung cấp toàn bộ đề bài; AI tạo mã và bản phân tích tham khảo. Vì vậy không nên trình bày các file này như sản phẩm hoàn toàn tự viết.

## 1. Phân tích khoảng trống
**Đầu vào:** Yêu cầu của bài thực hành AutoRide và legacy schema.
**Kết quả AI hỗ trợ:** Nêu 3 khoảng trống chính: status VARCHAR chưa kiểm soát, thiếu tiền cọc/phí, thiếu Inspections.

## 2. Kiểu tiền tệ
**Vấn đề:** FLOAT/DOUBLE hay DECIMAL cho security_deposit, late_fee, damage_fee?
**Kết luận:** DECIMAL(15,2) lưu giá trị thập phân chính xác theo 2 chữ số, thích hợp tính tiền và đối soát; FLOAT có sai số nhị phân.

## 3. Quan hệ kiểm tra xe
**Vấn đề:** Inspections nên quan hệ 1–1 hay 1–N với Rentals?
**Kết luận:** Chọn 1–N cho phép kiểm tra trước/trong/sau khi bàn giao; FK ON DELETE RESTRICT giữ dữ liệu kiểm tra. Nếu nghiệp vụ chỉ cho phép một biên bản, thêm UNIQUE(rental_id).

## 4. Tính hoàn tiền và NULL
**Vấn đề:** Làm sao tránh kết quả NULL trong phép trừ?
**Kết luận:** Đặt các cột tài chính NOT NULL DEFAULT 0; với schema cũ chứa NULL có thể dùng COALESCE.

## 5. Kiểm tra ràng buộc
**Vấn đề:** Ngăn tạo biên bản khi hợp đồng BOOKED?
**Kết luận:** Trigger BEFORE INSERT kiểm tra ACTIVE/COMPLETED; trả SIGNAL SQLSTATE '45000' khi không hợp lệ.

## Tự xác minh
Cần chạy script trong Workbench, chụp màn hình SELECT ra số tiền hoàn 8.000.000 VNĐ, và thử trigger. Chưa có kết quả chạy thực tế được cung cấp.
