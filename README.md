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

