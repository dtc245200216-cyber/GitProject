# Thực hành: Truyền tham số vào Stored Procedure

Bài CodeGym trên cơ sở dữ liệu **classicmodels**, bảng `customers`.

| Loại tham số | Procedure | Kết quả |
|---|---|---|
| IN | `getCusById(175)` | Khách có `customerNumber = 175` |
| OUT | `GetCustomersCountByCity('Lyon', @total)` | Gán số khách ở Lyon vào `@total` |
| INOUT | `SetCounter(@counter, inc)` | Tăng biến đếm từ 1 lên 8 |

## Cách chạy
1. Import sẵn CSDL mẫu `classicmodels` vào MySQL Server.
2. Mở [`stored_procedure_parameters.sql`](stored_procedure_parameters.sql) trong MySQL Workbench.
3. Chạy toàn bộ script, xem Result Grid của từng lệnh `CALL`/`SELECT`.

Script có `DROP PROCEDURE IF EXISTS` để có thể tạo lại các thủ tục khi luyện tập. Không xóa hay thay đổi dữ liệu bảng `customers`.

**Kết quả `@counter = 8` suy ra từ phép cộng; số khách ở Lyon phụ thuộc dữ liệu mẫu. Chưa chạy kiểm thử trên MySQL Workbench.**
