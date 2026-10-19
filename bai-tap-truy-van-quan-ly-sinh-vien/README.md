# Bài tập: Truy vấn dữ liệu với CSDL Quản lý sinh viên

File [`bai_tap_truy_van_sinh_vien.sql`](bai_tap_truy_van_sinh_vien.sql) có đủ 5 yêu cầu: tên bắt đầu bằng h, lớp bắt đầu tháng 12, môn có Credit 3–5, cập nhật lớp của Hung thành 2, và JOIN hiển thị điểm sắp xếp giảm dần theo Mark/tăng dần theo StudentName khi bằng điểm.

**Cách chạy:** Tạo bảng và chèn dữ liệu từ [bài tạo CSDL](../tao-csdl-quan-ly-sinh-vien/quan_ly_sinh_vien.sql) và [bài INSERT](../them-du-lieu-quan-ly-sinh-vien/them_du_lieu_quan_ly_sinh_vien.sql), sau đó chạy file SQL này bằng MySQL Workbench.

**Lưu ý:** Câu 4 thực sự thay đổi dữ liệu. Nếu CSDL có nhiều sinh viên cùng tên Hung, mọi bản ghi trùng tên sẽ được cập nhật theo đúng điều kiện đề đưa ra. Chưa kiểm thử thực thi trên MySQL Server.
