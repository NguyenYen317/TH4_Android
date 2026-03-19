import 'package:th4_e_commerce_app/models/cart_item.dart';
import 'package:th4_e_commerce_app/models/product.dart';

enum OrderStatus {
  pending, // Chờ xác nhận
  shipping, // Đang giao
  delivered, // Đã giao
  cancelled, // Đã hủy
}

class Order {
  final String id;
  final List<CartItem> items;
  final String address;
  final String paymentMethod;
  final double total;
  OrderStatus status;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.items,
    required this.address,
    required this.paymentMethod,
    required this.total,
    this.status = OrderStatus.pending,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'items': items
        .map(
          (e) => {
            'productId': e.product.id,
            'title': e.product.title,
            'price': e.product.price,
            'image': e.product.image,
            'quantity': e.quantity,
            'size': e.size,
            'color': e.color,
          },
        )
        .toList(),
    'address': address,
    'paymentMethod': paymentMethod,
    'total': total,
    'status': status.name,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      items: (json['items'] as List<dynamic>)
          .map(
            (e) => CartItem(
              product: Product(
                id: e['productId'] is int
                    ? e['productId'] as int
                    : int.tryParse(e['productId'].toString()) ?? 0,
                title: e['title'] as String? ?? '',
                price: (e['price'] as num?)?.toDouble() ?? 0,
                description: '',
                category: '',
                image: e['image'] as String? ?? '',
                images: const [],
                rating: 0,
                ratingCount: 0,
              ),
              quantity: e['quantity'] as int? ?? 1,
              size: e['size'] as String? ?? 'M',
              color: e['color'] as String? ?? 'Xanh',
            ),
          )
          .toList(),
      address: json['address'] as String,
      paymentMethod: json['paymentMethod'] as String,
      total: (json['total'] as num).toDouble(),
      status: OrderStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
