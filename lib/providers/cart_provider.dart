import 'package:flutter/material.dart';
import 'package:th4_e_commerce_app/models/cart_item.dart';
import 'package:th4_e_commerce_app/models/product.dart';

class CartProvider extends ChangeNotifier {
  final Map<int, CartItem> _items = <int, CartItem>{};

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

  bool containsProduct(int productId) => _items.containsKey(productId);

  void addProduct(Product product, {int quantity = 1}) {
    final existing = _items[product.id];
    if (existing != null) {
      existing.quantity += quantity;
    } else {
      _items[product.id] = CartItem(product: product, quantity: quantity);
    }
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

  void toggleSelection(int productId) {
    final item = _items[productId];
    if (item == null) return;
    item.selected = !item.selected;
    notifyListeners();
  }

  void setSelection(int productId, bool selected) {
    final item = _items[productId];
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

  void incrementQuantity(int productId) {
    final item = _items[productId];
    if (item == null) return;
    item.quantity += 1;
    notifyListeners();
  }

  void decrementQuantity(int productId) {
    final item = _items[productId];
    if (item == null) return;
    if (item.quantity > 1) {
      item.quantity -= 1;
      notifyListeners();
    }
  }
}
