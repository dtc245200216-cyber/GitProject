# Thực hành: Tạo bảng trong CSDL QuanLyDiemThi

## Mục tiêu
Dùng MySQL Workbench và SQL để tạo cơ sở dữ liệu `QuanLyDiemThi` với **4 bảng** và các ràng buộc khóa.

| Bảng | Khóa chính | Khóa ngoại |
| --- | --- | --- |
| HocSinh | MaHS | Không |
| GiaoVien | MaGV | Không |
| MonHoc | MaMH | MaGV → GiaoVien(MaGV) |
| BangDiem | (MaHS, MaMH) | MaHS → HocSinh(MaHS), MaMH → MonHoc(MaMH) |

## Cách thực hiện
1. Mở **MySQL Workbench** và kết nối MySQL Server.
2. Mở **New SQL Tab**, dán hoặc mở file [`quan_ly_diem_thi.sql`](quan_ly_diem_thi.sql).
3. Chạy toàn bộ lệnh bằng nút **Execute**.
4. Trong **SCHEMAS**, nhấn Refresh rồi mở `QuanLyDiemThi` → **Tables** để thấy 4 bảng.
5. Kiểm tra khóa bằng câu lệnh `SHOW CREATE TABLE BangDiem;` và `SHOW CREATE TABLE MonHoc;`.

## Ghi chú kỹ thuật
Đề bài có chỗ ghi `MonHoc.MaMH VARCHAR(50)` nhưng ví dụ lại dùng `VARCHAR(20)`. File SQL thống nhất **VARCHAR(50)** cho `MonHoc.MaMH` và `BangDiem.MaMH` để khóa ngoại tương thích.

Bảng `GiaoVien` được tạo trước `MonHoc` để liên kết khóa ngoại ngay khi tạo; kết quả tương đương với bước `ALTER TABLE MonHoc ADD CONSTRAINT ...` trong hướng dẫn.

## Minh chứng thực hành cần tự bổ sung
- Ảnh giao diện Workbench hiển thị 4 bảng trong `QuanLyDiemThi`.
- Ảnh chạy lệnh `SHOW CREATE TABLE BangDiem;` và `SHOW CREATE TABLE MonHoc;`.

**Lưu ý:** Repository cung cấp mã SQL và quy trình; chưa xác nhận câu lệnh đã chạy trên MySQL Workbench của người học.
