# Nhật ký AI hỗ trợ – FlashMart

**Minh bạch:** Người học gửi toàn bộ đề trong phiên này; AI chuẩn bị bản mẫu. Đây là bản tổng hợp lý thuyết do AI hỗ trợ, không phải nhật ký hỏi đáp nguyên văn từng câu. Người học cần tự thử câu lệnh và bổ sung phần hỏi đáp thực tế.

## JOIN mặc định
`JOIN` không kèm tiền tố là `INNER JOIN`: chỉ trả về các dòng khớp ở hai bảng. Charlie và Keyboard bị bỏ qua trong hai báo cáo cũ.

## COUNT và LEFT JOIN
`LEFT JOIN` tạo một dòng bên phải `NULL` khi không khớp. `COUNT(*)` đếm dòng đó, còn `COUNT(o.order_id)` không đếm `NULL`, do đó kết quả bằng 0.

## Anti-Join so với NOT IN
`LEFT JOIN ... WHERE o.order_id IS NULL` tìm các hàng không có bản ghi liên quan. `NOT IN` có nguy cơ sai lệch khi truy vấn con có `NULL`. Có thể dùng `NOT EXISTS`. So sánh hiệu năng bằng `EXPLAIN ANALYZE`.

## Nested-Loop Join
MySQL có thể duyệt từng hàng đầu vào rồi tìm các hàng khớp ở phía còn lại. Index trên `Orders.customer_id` và `Orders.product_id` thường có lợi; optimizer chọn kế hoạch tùy dữ liệu và phiên bản.

## RIGHT JOIN
`Customers RIGHT JOIN Orders` giữ toàn bộ Orders nhưng không giữ Charlie.

## Cross Join
Tích Descartes ghép mọi hàng của hai bảng, có thể bùng nổ số dòng khi quên điều kiện nối.

## FULL OUTER JOIN
MySQL không có cú pháp trực tiếp; có thể phối hợp LEFT JOIN và phần không khớp của RIGHT JOIN bằng UNION ALL.

## Bước kiểm thử
Chạy script trên MySQL Workbench, chụp 2 Result Grid với Alice 2, Bob 1, Charlie 0 và 103 Keyboard. Chưa có ảnh chạy thực tế.
