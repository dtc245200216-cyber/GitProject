# Thực hành Trigger trong MySQL

Bài thực hành CodeGym: tạo một cơ sở dữ liệu `company`, bảng `employees`, và trigger `update_department` để tự động xác định phòng ban khi thêm nhân viên dựa trên mức lương.

## Quy tắc trigger

| Lương | Phòng ban |
|---|---|
| Từ 5000 trở lên | Management |
| Từ 3000 đến dưới 5000 | Sales |
| Dưới 3000 | Support |

## Thực hiện

1. Mở MySQL Workbench.
2. Mở [`trigger_mysql.sql`](trigger_mysql.sql) và chạy một lần.
3. Quan sát câu truy vấn cuối để kiểm tra `department` đã tự động chuyển từ `A` sang phòng ban phù hợp.

Dự kiến John Doe → Sales, Jane Smith → Support, David Johnson → Management.

**Lưu ý:** Nếu đã chèn dữ liệu mẫu trước đó, chạy lại phần INSERT sẽ tạo thêm nhân viên vì bảng dùng `AUTO_INCREMENT`. Chưa kiểm chứng kết quả bằng MySQL Server thực tế.
