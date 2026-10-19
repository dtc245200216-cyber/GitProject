-- Bai tap: Truy van du lieu voi CSDL QuanLySinhVien
USE QuanLySinhVien;

-- 1. Sinh vien co ten bat dau bang ky tu 'h' (khong phan biet hoa/thuong)
SELECT *
FROM Student
WHERE LOWER(StudentName) LIKE 'h%';

-- 2. Lop hoc bat dau trong thang 12 (bat ky nam nao)
SELECT *
FROM Class
WHERE MONTH(StartDate) = 12;

-- 3. Mon hoc co Credit tu 3 den 5 (bao gom 3 va 5)
SELECT *
FROM Subject
WHERE Credit BETWEEN 3 AND 5;

-- 4. Chuyen sinh vien Hung sang lop co ClassID = 2
UPDATE Student
SET ClassID = 2
WHERE StudentName = 'Hung';

-- Kiem tra du lieu sau khi cap nhat
SELECT StudentID, StudentName, ClassID
FROM Student
WHERE StudentName = 'Hung';

-- 5. Ten sinh vien, ten mon va diem thi
-- Sap xep diem giam dan, trung diem thi sap ten tang dan
SELECT s.StudentName, sub.SubName, m.Mark
FROM Student AS s
JOIN Mark AS m ON s.StudentID = m.StudentID
JOIN Subject AS sub ON m.SubID = sub.SubID
ORDER BY m.Mark DESC, s.StudentName ASC;
