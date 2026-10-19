# Thực hành Stored Procedure – classicmodels

Bài thực hành CodeGym: tạo, gọi và sửa (bằng DROP rồi CREATE lại) stored procedure `findAllCustomers()`.

## Yêu cầu
Import sẵn cơ sở dữ liệu mẫu **classicmodels** có bảng `customers`; không dùng `payflow_db`.

## Các bước thực hiện
1. Mở MySQL Workbench và kết nối cơ sở dữ liệu.
2. Mở [stored_procedure.sql](stored_procedure.sql), chọn Execute All.
3. Kiểm tra Result Grid thứ nhất trả về các khách hàng trong `customers`.
4. Kiểm tra Result Grid sau khi tạo lại thủ tục: chỉ các khách hàng có `customerNumber = 175` (nếu dữ liệu mẫu có mã này).
5. Chạy `SHOW CREATE PROCEDURE findAllCustomers;` để xem định nghĩa cuối cùng.

## Kiến thức
- `CREATE PROCEDURE` lưu thủ tục trong MySQL.
- `CALL` thực hiện thủ tục.
- `DELIMITER //` cho phép dùng dấu chấm phẩy trong `BEGIN ... END` khi chạy từ client.
- Muốn thay đổi phần thân thủ tục, dùng `DROP PROCEDURE IF EXISTS` rồi `CREATE PROCEDURE` mới.

**Lưu ý:** Cần có cơ sở dữ liệu mẫu classicmodels trên máy; chưa có kết quả chạy Workbench thực tế. Không có lệnh xóa bảng hay xóa dữ liệu khách hàng.
