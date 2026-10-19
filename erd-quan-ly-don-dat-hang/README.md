# Thực hành: ERD quản lý đơn đặt hàng

Sơ đồ ERD được thiết kế theo yêu cầu CodeGym, sau khi gộp Đơn vị đặt hàng và Đơn vị khách hàng thành thực thể **DON_VI_KHACH**.

## Sơ đồ ERD

```mermaid
erDiagram
  DON_VI_KHACH ||--o{ NGUOI_DAT : "co"
  DON_VI_KHACH ||--o{ NGUOI_NHAN : "co"
  DON_VI_KHACH ||--o{ DON_DAT_HANG : "dat"
  NGUOI_DAT ||--o{ DON_DAT_HANG : "lap"
  DON_DAT_HANG ||--|{ CT_DON_DAT : "gom"
  HANG ||--o{ CT_DON_DAT : "duoc_dat"
  DON_DAT_HANG ||--o{ PHIEU_GIAO : "duoc_giao"
  DON_VI_KHACH ||--o{ PHIEU_GIAO : "nhan"
  NOI_GIAO ||--o{ PHIEU_GIAO : "dia_diem"
  NGUOI_NHAN ||--o{ PHIEU_GIAO : "nhan_hang"
  NGUOI_GIAO ||--o{ PHIEU_GIAO : "giao_hang"
  PHIEU_GIAO ||--|{ CT_PHIEU_GIAO : "gom"
  HANG ||--o{ CT_PHIEU_GIAO : "duoc_giao"
  DON_VI_KHACH {
    int MaDV PK
    varchar TenDV
    varchar DiaChi
    varchar DienThoai
  }
  NGUOI_DAT {
    int MaND PK
    varchar HoTenND
    int MaDV FK
  }
  NGUOI_NHAN {
    int MaNN PK
    varchar HoTenNN
    int MaDV FK
  }
  NGUOI_GIAO {
    int MaNG PK
    varchar HoTenNG
  }
  NOI_GIAO {
    int MaDiaDiemGiao PK
    varchar TenNoiGiao
  }
  HANG {
    int MaHang PK
    varchar TenHang
    varchar DonViTinh
    varchar MoTaHang
  }
  DON_DAT_HANG {
    int SoDH PK
    date NgayDat
    int MaDV FK
    int MaND FK
  }
  CT_DON_DAT {
    int SoDH PK,FK
    int MaHang PK,FK
    int SoLuong
  }
  PHIEU_GIAO {
    int SoPG PK
    date NgayGiao
    int SoDH FK
    int MaDV FK
    int MaDiaDiemGiao FK
    int MaNN FK
    int MaNG FK
  }
  CT_PHIEU_GIAO {
    int SoPG PK,FK
    int MaHang PK,FK
    int SoLuong
    decimal DonGia
    decimal ThanhTien
  }
```

## Các bước thực hiện
1. Liệt kê thông tin của Đơn đặt hàng và Phiếu giao hàng.
2. Xác định các thực thể: Đơn vị khách, Người đặt, Người nhận, Người giao, Nơi giao, Hàng, Đơn đặt hàng, Phiếu giao hàng.
3. Xác định khóa chính (PK), khóa ngoại (FK) và các quan hệ 1–N.
4. Tách quan hệ nhiều–nhiều giữa đơn hàng/phiếu giao và hàng hóa thành **CT_DON_DAT** và **CT_PHIEU_GIAO**.
5. Gộp hai thực thể đơn vị thành **DON_VI_KHACH** để giảm dữ liệu trùng lặp.
6. Hoàn thiện ERD và kiểm tra các liên kết.

## Kết quả
Sơ đồ thể hiện 10 thực thể và các mối quan hệ quản lý đặt hàng và giao hàng. Trường `ThanhTien` là giá trị có thể tính bằng `SoLuong × DonGia`.

## Ghi chú
Đây là một cách mô hình hóa chi tiết từ yêu cầu, không nhất thiết trùng cách bố trí trong hình minh họa của giáo trình.
