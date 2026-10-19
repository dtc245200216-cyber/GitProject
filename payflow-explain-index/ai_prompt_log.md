# Nhật ký AI hỗ trợ – PayFlow

**Minh bạch:** Đây là tổng hợp câu hỏi kỹ thuật gợi ý và giải thích do AI thực hiện khi người học gửi đề bài, không phải bản ghi các lượt hỏi riêng lẻ đã diễn ra.

**Hỏi:** Vì sao hàm YEAR(created_at) có thể khiến index không hiệu quả?

**Đáp:** Vì điều kiện bọc hàm trên cột thường không chuyển được thành phạm vi khóa B-Tree trên cột gốc (non-SARGable). Có ngoại lệ functional index.

**Hỏi:** Vì sao chọn thứ tự (transaction_type, created_at)?

**Đáp:** Vì lọc bằng ở transaction_type trước, rồi lọc khoảng thời gian trên created_at; phù hợp leftmost prefix.

**Hỏi:** Index Seek và Index Scan khác nhau thế nào?

**Đáp:** Seek định vị một phần khóa để đọc; scan đọc nhiều/đa số entry trong index. MySQL dùng các chỉ số EXPLAIN để mô tả cách truy cập.

**Hỏi:** Vì sao type không bắt buộc là range?

**Đáp:** Optimizer dựa trên thống kê. Với bảng nhỏ, ít dữ liệu hoặc lọc ra đa số dòng, ALL đôi khi rẻ hơn range.

**Hỏi:** 'Using index condition' khác 'Using index'?

**Đáp:** Index Condition Pushdown kiểm tra điều kiện trong index trước khi lấy hàng. 'Using index' thường là covering index, không cần đọc hàng gốc. Index hai cột trong bài không chứa amount, nên không đảm bảo covering.

**Hỏi:** Nhiều index ảnh hưởng gì đến ghi dữ liệu?

**Đáp:** Tăng chi phí duy trì index, I/O và lưu trữ khi INSERT/UPDATE/DELETE.

**Việc cần tự kiểm thử:** Chạy EXPLAIN trên MySQL thật trước và sau tối ưu; chụp Result Grid và ghi các chỉ số type, possible_keys, key, rows, Extra.
