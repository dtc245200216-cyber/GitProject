-- Bài thực hành: Truy vấn dữ liệu CSDL Quản lý sinh viên
USE QuanLySinhVien;

-- 1. Danh sách tất cả học viên
SELECT *
FROM Student;

-- 2. Danh sách học viên đang theo học
-- Cột Status trong bài trước có kiểu BIT, so sánh với 1.
SELECT *
FROM Student
WHERE Status = 1;

-- 3. Môn học có số tín chỉ (Credit) nhỏ hơn 10
SELECT *
FROM Subject
WHERE Credit < 10;

-- 4. Danh sách học viên thuộc lớp A1
SELECT S.StudentID, S.StudentName, C.ClassName
FROM Student AS S
INNER JOIN Class AS C ON S.ClassID = C.ClassID
WHERE C.ClassName = 'A1';

-- 5. Điểm môn CF của các học viên
SELECT S.StudentID, S.StudentName, Sub.SubName, M.Mark
FROM Student AS S
INNER JOIN Mark AS M ON S.StudentID = M.StudentID
INNER JOIN Subject AS Sub ON M.SubID = Sub.SubID
WHERE Sub.SubName = 'CF';
