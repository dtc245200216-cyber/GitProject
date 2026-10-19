# Nhật ký hỗ trợ AI – QuickFeed
**Nguồn:** Tổng hợp giải đáp kỹ thuật từ tương tác AI khi cung cấp đề bài; không phải nhật ký từng câu hỏi tự gửi trước đó.

**Hỏi: Cardinality là gì?** Số giá trị phân biệt của cột/index. Boolean có 2 giá trị; nếu 99% là 1 thì lọc giá trị 1 bằng chỉ mục ít hiệu quả. Tuy nhiên index cardinality thấp không phải luôn vô dụng, có thể giúp tìm nhóm hiếm.

**Hỏi: Index TEXT dài ảnh hưởng gì?** B-Tree trên `content(255)` lưu tiền tố văn bản và khóa chính trong từng secondary entry, tốn pages và tăng chi phí ghi. Tìm từ khóa tự do nên cân nhắc FULLTEXT.

**Hỏi: InnoDB quản lý Data Pages và Index Pages thế nào?** Các trang được cấp phát trong tablespace. Clustered index chứa dữ liệu hàng; secondary index chứa khóa phụ và khóa chính. `DATA_LENGTH` / `INDEX_LENGTH` là thống kê dung lượng có thể ước lượng.

**Hỏi: Mỗi INSERT vào bảng 5 index diễn ra gì?** Ghi hàng clustered index cùng 5 secondary indexes, redo logs và các thao tác B-Tree; có thể chia trang. Bỏ 3 index giảm chi phí bảo trì 3 cây nhưng không bảo đảm thời gian cải thiện theo tỷ lệ tuyến tính.

**Hỏi: Nếu Posts là bảng archive?** Ít ghi nên nhiều index ít gây nghẽn INSERT; vẫn tốn disk và tài nguyên backup, chỉ giữ index cho truy vấn thực tế.

**Để bảo vệ trước giảng viên:** giải thích read/write trade-off, cardinality, lý do giữ idx_user_id / idx_created_at, và đo MB trước/sau từ EXPLAIN/SHOW TABLE STATUS/information_schema.

**Kết quả đo:** Chưa thực thi MySQL trên máy người học; không đưa số liệu tự tạo.
