import 'package:flutter/material.dart';
import 'package:th4_e_commerce_app/models/order.dart';
import 'package:th4_e_commerce_app/services/storage_service.dart';

class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders);

  OrderProvider() {
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final loaded = await StorageService.loadOrders();
    _orders.clear();
    _orders.addAll(loaded);
    notifyListeners();
  }

  Future<void> addOrder(Order order) async {
    _orders.insert(0, order);
    await StorageService.saveOrders(_orders);
    notifyListeners();
  }

  // Có thể bổ sung các hàm update/cancel nếu cần
}
