import 'package:th4_e_commerce_app/models/product.dart';
import 'package:th4_e_commerce_app/services/api_service.dart';

class ProductService {
  ProductService({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  Future<List<Product>> fetchAllProducts() async {
    final data = await _apiService.getList('/products');
    return data
        .whereType<Map<String, dynamic>>()
        .map(Product.fromJson)
        .toList();
  }

  Future<List<String>> fetchCategories() async {
    final data = await _apiService.getList('/products/categories');
    final categories = data.map((item) => item.toString()).toList();
    return ['all', ...categories];
  }

  void dispose() {
    _apiService.dispose();
  }
}
