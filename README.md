# TH4: MINI E-COMMERCE APP (Flutter)

Ứng dụng bán hàng mini được xây dựng bằng **Flutter** nhằm mô phỏng quy trình mua sắm cơ bản của các sàn thương mại điện tử như Shopee, Lazada.

Dự án được thực hiện trong khuôn khổ **Bài Thực Hành 4 - Lập trình Mobile**.

---

# Thông tin dự án

**Tên dự án:** Mini E-Commerce App  

**Mục tiêu:**
- Xây dựng ứng dụng bán hàng cơ bản
- Hiển thị danh sách sản phẩm từ API
- Xem chi tiết sản phẩm
- Thêm sản phẩm vào giỏ hàng
- Thanh toán và quản lý đơn hàng

**Nguồn dữ liệu:** FakeStore API  
https://fakestoreapi.com/

---

# Tính năng chính

## 1. Trang chủ (Home Screen)

- Hiển thị danh sách sản phẩm dạng GridView
- Thanh tìm kiếm sản phẩm
- Banner quảng cáo dạng Carousel Slider
- Danh mục sản phẩm
- Infinite Scrolling (tải thêm sản phẩm khi cuộn)
- Pull to Refresh để làm mới dữ liệu
- Icon giỏ hàng có Badge hiển thị số lượng sản phẩm

---

## 2. Trang chi tiết sản phẩm (Product Detail)

- Hero Animation khi chuyển từ danh sách sang chi tiết
- Slider hiển thị nhiều ảnh sản phẩm
- Hiển thị giá bán và giá gốc
- Mô tả sản phẩm
- BottomSheet chọn:
  - Size
  - Màu sắc
  - Số lượng
- Nút:
  - Thêm vào giỏ hàng
  - Mua ngay

---

## 3. Giỏ hàng (Cart)

- Hiển thị danh sách sản phẩm trong giỏ
- Checkbox chọn sản phẩm
- Checkbox chọn tất cả
- Tăng/giảm số lượng sản phẩm
- Vuốt sang trái để xóa sản phẩm
- Tính tổng tiền theo các sản phẩm được chọn
- Cập nhật tổng tiền realtime

---

## 4. Thanh toán (Checkout)

- Nhập địa chỉ nhận hàng
- Chọn phương thức thanh toán:
  - COD
  - Momo
- Xác nhận đặt hàng
- Hiển thị thông báo đặt hàng thành công

---

## 5. Lịch sử đơn hàng (Order History)

- Hiển thị danh sách các đơn hàng đã đặt
- Tab phân loại:
  - Chờ xác nhận
  - Đang giao
  - Đã giao
  - Đã hủy

---

# Công nghệ sử dụng

- Flutter
- Dart

Các thư viện chính: 
provider
http
carousel_slider
badges
shared_preferences

# Cấu trúc thư mục
lib
│
├── main.dart
│
├── models
│ ├── product.dart
│ ├── cart_item.dart
│ └── order.dart
│
├── screens
│ ├── home_screen.dart
│ ├── product_detail_screen.dart
│ ├── cart_screen.dart
│ ├── checkout_screen.dart
│ └── order_history_screen.dart
│
├── widgets
│ ├── product_card.dart
│ ├── banner_slider.dart
│ ├── category_grid.dart
│ ├── cart_item_widget.dart
│ └── add_to_cart_sheet.dart
│
├── providers
│ ├── cart_provider.dart
│ └── order_provider.dart
│
├── services
│ ├── product_service.dart
│ └── storage_service.dart
│
└── utils
├── constants.dart
└── format_price.dart

---

# State Management

Ứng dụng sử dụng **Provider** để quản lý trạng thái.

Provider được dùng cho:

- Quản lý giỏ hàng
- Cập nhật badge số lượng sản phẩm
- Tính tổng tiền
- Quản lý đơn hàng

---

# Lưu trữ dữ liệu

Giỏ hàng có thể được lưu bằng: SharedPreferences
Điều này giúp:
- Dữ liệu giỏ hàng không bị mất khi tắt ứng dụng
- Người dùng mở lại app vẫn giữ nguyên giỏ hàng

# Demo
Video demo ứng dụng:

---

# Thông tin nhánh (Branch)

## Quy ước đặt tên nhánh

Dự án sử dụng quy ước đặt tên nhánh theo định dạng:

```
copilot/<tên-thành-viên>-<tính-năng>
```

Ví dụ: `copilot/ngoc-anh-home-screen`

---

## Nhánh `copilot/ngoc-anh-home-screen`

| Thông tin | Chi tiết |
|---|---|
| **Tên nhánh** | `copilot/ngoc-anh-home-screen` |
| **Thành viên phụ trách** | Ngọc Anh |
| **Tính năng** | Trang chủ (Home Screen) |
| **Hỗ trợ bởi** | GitHub Copilot (tiền tố `copilot/`) |

### Mục đích

Nhánh này được tạo ra để **triển khai tính năng Trang chủ** của ứng dụng Mini E-Commerce, bao gồm toàn bộ giao diện và logic của màn hình chính.

### Nội dung đã thực hiện trong nhánh này

**Màn hình chính (`home_screen.dart`):**
- ✅ Hiển thị danh sách sản phẩm dạng **GridView** 2 cột
- ✅ **Thanh tìm kiếm** với lọc theo thời gian thực và nút xóa
- ✅ **Banner quảng cáo** dạng Carousel Slider tự động cuộn
- ✅ **Danh mục sản phẩm** dạng ChoiceChip cuộn ngang
- ✅ **Infinite Scrolling** – tải thêm sản phẩm khi cuộn đến cuối
- ✅ **Pull to Refresh** – làm mới dữ liệu bằng cách kéo xuống
- ✅ **Icon giỏ hàng** với Badge hiển thị số lượng sản phẩm

**Các lớp hỗ trợ được triển khai:**
- `models/product.dart` – Model sản phẩm từ FakeStore API
- `models/cart_item.dart` – Model mục trong giỏ hàng
- `services/api_service.dart` – Gọi API FakeStore
- `services/product_service.dart` – Lớp trung gian dịch vụ sản phẩm
- `services/storage_service.dart` – Lưu giỏ hàng với SharedPreferences
- `providers/cart_provider.dart` – Quản lý trạng thái giỏ hàng (Provider)
- `widgets/product_card.dart` – Widget thẻ sản phẩm
- `widgets/banner_slider.dart` – Widget carousel banner
- `widgets/category_grid.dart` – Widget danh mục

### Câu hỏi thường gặp

**Q: Nếu đổi tên nhánh trên GitHub thì commit cũ có bị mất không?**  
A: **Không.** Các commit được lưu bằng mã SHA duy nhất, không phụ thuộc vào tên nhánh.  
Khi đổi tên nhánh, toàn bộ lịch sử commit vẫn được giữ nguyên — chỉ có tên "nhãn" trỏ tới commit đó thay đổi.  
Nếu bạn đã clone về máy với tên cũ, chỉ cần chạy:
```bash
git fetch origin
git branch -m <tên-cũ> <tên-mới>
git branch -u origin/<tên-mới>
```

---

# Tác giả
Nhóm: G10_C3
Môn học: Lập trình Mobile
