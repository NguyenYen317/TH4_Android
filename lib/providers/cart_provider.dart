import 'package:flutter/material.dart';
import 'package:th4_e_commerce_app/models/cart_item.dart';
import 'package:th4_e_commerce_app/models/product.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = <String, CartItem>{};

  List<CartItem> get items => _items.values.toList();

  int get totalItems =>
      _items.values.fold<int>(0, (sum, item) => sum + item.quantity);

  double get totalSelectedPrice {
    return _items.values
        .where((element) => element.selected)
        .fold(0.0, (p, item) => p + item.subTotal);
  }

  bool get allSelected =>
      _items.isNotEmpty && _items.values.every((element) => element.selected);

  bool get hasAnySelected => _items.values.any((element) => element.selected);

  String _generateKey(int productId, String size, String color) {
    return '$productId-$size-$color';
  }

  void addProduct(Product product, {int quantity = 1, String size = 'M', String color = 'Xanh'}) {
    final key = _generateKey(product.id, size, color);
    final existing = _items[key];
    if (existing != null) {
      existing.quantity += quantity;
    } else {
      _items[key] = CartItem(
        product: product,
        quantity: quantity,
        size: size,
        color: color,
      );
    }
    notifyListeners();
  }

  void removeProduct(String key) {
    _items.remove(key);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void toggleSelection(String key) {
    final item = _items[key];
    if (item == null) return;
    item.selected = !item.selected;
    notifyListeners();
  }

  void setSelection(String key, bool selected) {
    final item = _items[key];
    if (item == null) return;
    item.selected = selected;
    notifyListeners();
  }

  void setAllSelected(bool selected) {
    for (var item in _items.values) {
      item.selected = selected;
    }
    notifyListeners();
  }

  void incrementQuantity(String key) {
    final item = _items[key];
    if (item == null) return;
    item.quantity += 1;
    notifyListeners();
  }

  void decrementQuantity(String key) {
    final item = _items[key];
    if (item == null) return;
    if (item.quantity > 1) {
      item.quantity -= 1;
      notifyListeners();
    }
  }
}
