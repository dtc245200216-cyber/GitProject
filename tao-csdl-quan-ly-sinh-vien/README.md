# [Thực hành] Tạo CSDL quản lý sinh viên

## Mục tiêu
Tạo cơ sở dữ liệu **QuanLySinhVien** bằng MySQL Workbench với 4 bảng **Class, Student, Subject, Mark**, đúng kiểu dữ liệu, khóa chính, khóa ngoại, CHECK, DEFAULT và UNIQUE của đề.

## File thực hành
[`quan_ly_sinh_vien.sql`](quan_ly_sinh_vien.sql)

## Thiết kế
| Bảng | Khóa chính | Khóa ngoại và các ràng buộc |
|---|---|---|
| Class | ClassID (AUTO_INCREMENT) | ClassName, StartDate NOT NULL |
| Student | StudentID (AUTO_INCREMENT) | ClassID NOT NULL → Class(ClassID); StudentName NOT NULL |
| Subject | SubID (AUTO_INCREMENT) | SubName NOT NULL; Credit mặc định 1 và >= 1; Status mặc định 1 |
| Mark | MarkID (AUTO_INCREMENT) | SubID → Subject(SubID); StudentID → Student(StudentID); UNIQUE(SubID, StudentID); Mark 0–100, mặc định 0; ExamTimes mặc định 1 |

## Các bước thực hiện
1. Mở MySQL Workbench và kết nối máy chủ MySQL.
2. Mở file `quan_ly_sinh_vien.sql` trong SQL Editor.
3. Chạy toàn bộ script để tạo database và 4 bảng theo thứ tự Class → Student → Subject → Mark.
4. Refresh **SCHEMAS** rồi mở **QuanLySinhVien → Tables**.
5. Quan sát kết quả `SHOW CREATE TABLE` để kiểm tra khóa chính, khóa ngoại và ràng buộc.

## Sơ đồ quan hệ
```mermaid
erDiagram
    Class ||--o{ Student : "co"
    Student ||--o{ Mark : "co"
    Subject ||--o{ Mark : "duoc_cham"
```

## Lưu ý
- Script dùng `CREATE TABLE IF NOT EXISTS` để tránh lỗi khi bảng đã có; câu lệnh này **không tự sửa** cấu trúc bảng cũ. Nếu đã tồn tại bảng sai cấu trúc, kiểm tra trước khi thực hành lại.
- MySQL 8.0.16 trở lên mới thực thi ràng buộc CHECK.
- Ràng buộc `UNIQUE (SubID, StudentID)` theo mẫu của đề khiến một sinh viên chỉ có một bản ghi điểm cho mỗi môn, dù có trường ExamTimes.
- Chưa có ảnh chứng minh thực thi trên máy. Nếu cần minh chứng, hãy chụp màn hình SCHEMAS và kết quả SHOW CREATE TABLE từ MySQL Workbench.
