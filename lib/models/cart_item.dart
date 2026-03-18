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

  double get subTotal => product.price * quantity;
}
