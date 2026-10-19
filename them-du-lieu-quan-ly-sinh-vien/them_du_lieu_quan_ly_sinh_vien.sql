-- Bai thuc hanh: Them du lieu vao CSDL QuanLySinhVien
-- Yeu cau: da chay file tao bang cua bai truoc.
USE QuanLySinhVien;

-- 1. Lop hoc
INSERT INTO Class (ClassID, ClassName, StartDate, Status)
VALUES
    (1, 'A1', '2008-12-20', 1),
    (2, 'A2', '2008-12-22', 1),
    (3, 'B3', CURRENT_DATE(), 0);

-- 2. Sinh vien (Phone cua Hoa duoc de NULL)
INSERT INTO Student (StudentID, StudentName, Address, Phone, Status, ClassID)
VALUES
    (1, 'Hung', 'Ha noi', '0912113113', 1, 1),
    (2, 'Hoa', 'Hai phong', NULL, 1, 1),
    (3, 'Manh', 'HCM', '0123123123', 0, 2);

-- 3. Mon hoc
INSERT INTO Subject (SubID, SubName, Credit, Status)
VALUES
    (1, 'CF', 5, 1),
    (2, 'C', 6, 1),
    (3, 'HDJ', 5, 1),
    (4, 'RDBMS', 10, 1);

-- 4. Diem thi
INSERT INTO Mark (MarkID, SubID, StudentID, Mark, ExamTimes)
VALUES
    (1, 1, 1, 8, 1),
    (2, 1, 2, 10, 2),
    (3, 2, 1, 12, 1);

-- 5. Xem ket qua
SELECT * FROM Class ORDER BY ClassID;
SELECT * FROM Student ORDER BY StudentID;
SELECT * FROM Subject ORDER BY SubID;
SELECT * FROM Mark ORDER BY MarkID;
