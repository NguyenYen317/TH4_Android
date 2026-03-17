import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class StorageService {
  static const String _cartKey = 'cart_items';

  Future<void> saveCart(List<CartItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final data = items
        .map((item) => {
              'productId': item.product.id,
              'title': item.product.title,
              'price': item.product.price,
              'image': item.product.image,
              'category': item.product.category,
              'description': item.product.description,
              'rating': item.product.rating,
              'ratingCount': item.product.ratingCount,
              'quantity': item.quantity,
            })
        .toList();
    await prefs.setString(_cartKey, json.encode(data));
  }

  Future<List<CartItem>> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_cartKey);
    if (raw == null) return [];
    final List<dynamic> data = json.decode(raw) as List<dynamic>;
    return data.map((e) {
      final map = e as Map<String, dynamic>;
      final product = Product(
        id: map['productId'] as int,
        title: map['title'] as String,
        price: (map['price'] as num).toDouble(),
        description: map['description'] as String,
        category: map['category'] as String,
        image: map['image'] as String,
        rating: (map['rating'] as num).toDouble(),
        ratingCount: map['ratingCount'] as int,
      );
      return CartItem(product: product, quantity: map['quantity'] as int);
    }).toList();
  }

  Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
  }
}
