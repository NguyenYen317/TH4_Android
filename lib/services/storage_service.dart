import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:th4_e_commerce_app/models/order.dart';

class StorageService {
  static const String ordersKey = 'orders';

  static Future<void> saveOrders(List<Order> orders) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = orders.map((e) => e.toJson()).toList();
    await prefs.setString(ordersKey, jsonEncode(jsonList));
  }

  static Future<List<Order>> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(ordersKey);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => Order.fromJson(e)).toList();
  }
}
