# Thực hành: Truy vấn dữ liệu với CSDL Quản lý sinh viên

Bài gồm 5 truy vấn SQL theo yêu cầu CodeGym:
1. Tất cả học viên.
2. Học viên đang theo học (`Status = 1`).
3. Môn học có `Credit < 10`.
4. Học viên lớp A1 (JOIN bảng `Student` và `Class`).
5. Điểm môn CF (JOIN `Student`, `Mark`, `Subject`).

## Cách chạy
1. Chạy [script tạo bảng](../tao-csdl-quan-ly-sinh-vien/quan_ly_sinh_vien.sql) của bài trước.
2. Chạy [script thêm dữ liệu](../them-du-lieu-quan-ly-sinh-vien/them_du_lieu_quan_ly_sinh_vien.sql) một lần.
3. Mở [truy_van_quan_ly_sinh_vien.sql](truy_van_quan_ly_sinh_vien.sql) trong MySQL Workbench và Execute.

Với dữ liệu mẫu: tất cả học viên gồm Hung, Hoa, Manh; đang học Hung, Hoa; môn Credit < 10 là CF, C, HDJ; lớp A1 gồm Hung, Hoa; điểm CF của Hung là 8, Hoa là 10.

**Lưu ý:** Đây là kết quả suy ra từ các lệnh INSERT, chưa kiểm thử trực tiếp trên MySQL Server.
