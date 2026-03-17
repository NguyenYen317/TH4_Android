import 'package:flutter/material.dart';
import 'package:th4_e_commerce_app/models/product.dart';

class CartProvider extends ChangeNotifier {
  final Map<int, int> _items = <int, int>{};

  int get totalItems =>
      _items.values.fold<int>(0, (sum, quantity) => sum + quantity);

  bool containsProduct(int productId) => _items.containsKey(productId);

  void addProduct(Product product, {int quantity = 1}) {
    final current = _items[product.id] ?? 0;
    _items[product.id] = current + quantity;
    notifyListeners();
  }

  void removeProduct(int productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
