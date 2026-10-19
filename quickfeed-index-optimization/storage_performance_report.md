# QuickFeed – Storage & Performance Report
## Ma trận quyết định
| Index | Quyết định | Lý do |
|---|---|---|
| idx_user_id | Giữ | Truy vấn bài theo người dùng |
| idx_created_at | Giữ | Lọc và sắp xếp thời gian |
| idx_content | Xóa | Tiền tố TEXT dài, tốn disk; cân nhắc FULLTEXT cho tìm kiếm từ khóa |
| idx_post_type | Xóa | 3 loại, ít phân biệt khi lọc đơn lẻ |
| idx_is_visible | Xóa | 2 loại, phần lớn hàng giống nhau |

## Báo cáo
Với InnoDB, INSERT một bài không chỉ ghi hàng dữ liệu trong clustered index (PRIMARY KEY) mà còn cập nhật 5 secondary B-Tree indexes. Điều này tăng I/O, redo log, số trang index và có thể phát sinh page split. Loại bỏ ba index dư thừa giảm ba cấu trúc chỉ mục cần duy trì mỗi lần thêm bài, nhưng không đồng nghĩa INSERT nhanh gấp ba lần.

Index tối ưu cho đọc có chọn lọc, song làm ghi chậm và tốn RAM/disk. Với 99% bài hiển thị, index đơn trên is_visible ít hữu dụng; optimizer có thể chọn table scan. Với bảng archive ít ghi, nhiều index không còn gây áp lực ghi lớn nhưng vẫn chiếm dung lượng.

**Số liệu trước/sau:** Chưa đo trên server MySQL thực tế. Script in `DATA_LENGTH`, `INDEX_LENGTH` theo MB trước/sau qua `information_schema.TABLES`. Cần chạy và chụp kết quả có dữ liệu để báo cáo. Thống kê InnoDB có thể là ước lượng; dung lượng vật lý không nhất thiết giảm tức thì.
