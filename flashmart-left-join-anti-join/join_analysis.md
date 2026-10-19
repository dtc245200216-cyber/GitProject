# Phân tích lựa chọn JOIN

`INNER JOIN` chỉ lấy bản ghi khớp ở hai bảng nên bỏ sót Charlie. Báo cáo Marketing phải đặt `Customers` bên trái của `LEFT JOIN` để giữ toàn bộ khách hàng, kể cả khi chưa có đơn hàng. Phải sử dụng `COUNT(o.order_id)` vì hàm này không đếm giá trị `NULL`: Charlie có **0 đơn**. Ngược lại, `COUNT(*)` đếm cả dòng được `LEFT JOIN` tạo ra cho Charlie nên cho kết quả sai là **1**.

Với báo cáo sản phẩm chưa bán, `Products LEFT JOIN Orders` giữ cả sản phẩm không có đơn hàng. Điều kiện `WHERE o.order_id IS NULL` chỉ lấy những sản phẩm không khớp, tức **Keyboard**. Nếu dùng `INNER JOIN`, dòng không khớp đã bị loại trước khi lọc nên không thể tìm ra sản phẩm ế.
