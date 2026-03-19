import 'package:th4_e_commerce_app/models/product.dart';

class CartItem {
  final Product product;
  int quantity;
  bool selected;
  final String size;
  final String color;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.selected = true,
    this.size = 'M',
    this.color = 'Xanh',
  });

  String get key => '${product.id}-$size-$color';

  double get subTotal => product.price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'selected': selected,
      'size': size,
      'color': color,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
      selected: json['selected'] ?? true,
      size: json['size'] ?? 'M',
      color: json['color'] ?? 'Xanh',
    );
  }
}
