# Thực hành: Thêm dữ liệu vào cơ sở dữ liệu quản lý sinh viên

Bài thực hành sử dụng **`INSERT INTO`** để thêm dữ liệu mẫu theo đề CodeGym.

## Chuẩn bị

Trước tiên chạy script tạo cơ sở dữ liệu và bốn bảng của bài trước:
[`tao-csdl-quan-ly-sinh-vien/quan_ly_sinh_vien.sql`](../tao-csdl-quan-ly-sinh-vien/quan_ly_sinh_vien.sql).

Sau đó mở [`them_du_lieu_quan_ly_sinh_vien.sql`](them_du_lieu_quan_ly_sinh_vien.sql) bằng MySQL Workbench và chạy toàn bộ.

## Kết quả mong đợi

| Bảng | Số bản ghi |
|---|---:|
| Class | 3 |
| Student | 3 |
| Subject | 4 |
| Mark | 3 |

- Ngày bắt đầu lớp B3 được tạo từ `CURRENT_DATE()`.
- Học viên Hoa không có số điện thoại, lưu `NULL`.
- Giá trị điểm `12` được giữ nguyên theo đề bài. Schema trước đó cho phép điểm từ 0 đến 100.
- Dùng mã ID tường minh để giữ chính xác các bản ghi như đề.
- Nếu đã chạy và nhập các bản ghi này trước đó, chạy lại sẽ bị trùng khóa chính. Không cần chạy lại.
