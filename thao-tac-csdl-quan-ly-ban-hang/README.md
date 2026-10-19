# Bài tập: Thao tác với CSDL Quản lý bán hàng

Bài sử dụng cơ sở dữ liệu `QuanLyBanHang` và bốn bảng `Customer`, `Orders`, `Product`, `OrderDetail` từ bài trước.

## Các nội dung hoàn thành
- INSERT 3 khách hàng, 3 hóa đơn, 5 sản phẩm và 7 dòng chi tiết hóa đơn.
- SELECT mã hóa đơn, ngày bán, tổng tiền đang lưu.
- JOIN lấy khách hàng đã mua và các sản phẩm.
- NOT EXISTS lấy khách chưa mua: **Hong Ha**.
- SUM(odQTY * pPrice) để tính số tiền hóa đơn.

## Kết quả tính toán dự kiến
| oID | Ngày bán | Giá hóa đơn |
|---:|---|---:|
| 1 | 2006-03-21 | 60 |
| 2 | 2006-03-23 | 30 |
| 3 | 2006-03-16 | 24 |

## Cách chạy
1. Chạy [script tạo bảng](../quan-ly-ban-hang/quan_ly_ban_hang.sql) một lần.
2. Mở [`thao_tac_quan_ly_ban_hang.sql`](thao_tac_quan_ly_ban_hang.sql) trong MySQL Workbench và chạy.
3. Kiểm tra các Result Grid của bốn câu SELECT.

**Khác biệt với bài tạo bảng:** Bài trước để `Orders.oTotalPrice` NOT NULL DEFAULT 0; dữ liệu mẫu của bài này yêu cầu NULL. File SQL có `ALTER TABLE` để cho phép giá trị NULL. Cột Customer được đặt tên `cName` như schema cũ (thay vì `Name` trong đề); `Orders` thay cho `Order` vì ORDER là từ khóa.

**Ghi chú:** Script INSERT dự kiến chạy lần đầu trên dữ liệu trống; chạy lại sẽ gặp lỗi trùng khóa chính. Các kết quả là tính toán từ dữ liệu mẫu, chưa kiểm thử trực tiếp MySQL Workbench.
