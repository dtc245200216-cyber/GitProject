# Thực hành: View trong MySQL

Bài tập CodeGym sử dụng CSDL mẫu `classicmodels` và bảng `customers`.

## Nội dung thực hiện
1. `CREATE OR REPLACE VIEW customer_views`: lấy `customerNumber`, `customerName`, `phone`.
2. `SELECT * FROM customer_views`: xem dữ liệu trong view.
3. `CREATE OR REPLACE VIEW`: bổ sung `contactFirstName`, `contactLastName` và điều kiện `city = 'Nantes'`.
4. `SELECT` lại để kiểm tra dữ liệu sau cập nhật.
5. `DROP VIEW IF EXISTS customer_views`: xóa view.

## Cách chạy
- Import sẵn `classicmodels` vào MySQL.
- Mở [`view_mysql.sql`](view_mysql.sql) trong MySQL Workbench.
- Chạy từng nhóm lệnh để xem kết quả trước/sau khi thay đổi; chạy toàn bộ cũng được nhưng view sẽ bị xóa ở cuối.

**Lưu ý:** `CREATE OR REPLACE VIEW` thay đổi định nghĩa view, không chỉnh sửa trực tiếp dữ liệu bảng `customers`. Script chưa được chạy kiểm thử trên máy người học.
