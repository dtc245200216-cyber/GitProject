# Bài tập View, Index, Stored Procedure

CSDL: `demo`. Bảng: `Products` gồm Id, productCode, productName, productPrice, productAmount, productDescription, productStatus.

## Đã thực hiện
- Thêm 5 sản phẩm mẫu.
- Tạo **Unique Index** `idx_product_code` và **Composite Index** `idx_product_name_price`.
- Chạy **EXPLAIN** trước và sau khi thêm index, kiểm tra `possible_keys`, `key`, `type`, `rows`.
- Tạo, truy vấn, thay đổi định nghĩa và xóa `product_view`.
- Tạo 4 thủ tục: `sp_get_all_products`, `sp_add_product`, `sp_update_product`, `sp_delete_product`.
- Gọi thử thêm/sửa/xóa sản phẩm P006.

## EXPLAIN trước và sau
Trước khi tạo index: thường `type=ALL` và `key=NULL`. Sau index, truy vấn lọc productCode có thể dùng `idx_product_code`; truy vấn lọc theo productName và productPrice có thể dùng `idx_product_name_price`. **Không khẳng định kết quả EXPLAIN thực tế:** với bảng chỉ có 5 dòng, optimizer vẫn có thể chọn full scan. Chạy trên MySQL Workbench và chụp hai Result Grid để đối chiếu.

## Lưu ý
Chạy SQL trong MySQL Workbench. Với dữ liệu mẫu, **chỉ chạy lần đầu** phần INSERT và CREATE INDEX; chạy lại có thể lỗi trùng `productCode`/tên index. View được xóa ở cuối theo đúng bài tập; muốn xem lại thì thực hiện riêng khối CREATE VIEW. Script chưa được chạy trên máy người học.
