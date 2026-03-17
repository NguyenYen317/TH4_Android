import 'package:th4_e_commerce_app/models/product.dart';
import 'package:th4_e_commerce_app/services/api_service.dart';
import 'package:th4_e_commerce_app/utils/constants.dart';

class ProductService {
  ProductService({ApiService? apiService})
    : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  Future<List<Product>> fetchProductsPage({
    required int page,
    int pageSize = AppConstants.homePageSize,
    String category = 'all',
  }) async {
    final endpoint = category == 'all'
        ? '/products'
        : '/products/category/$category';
    final data = await _apiService.getList(endpoint);
    final allProducts = data
        .whereType<Map<String, dynamic>>()
        .map(Product.fromJson)
        .toList();

    final start = (page - 1) * pageSize;
    if (start >= allProducts.length) {
      return [];
    }

    final end = (start + pageSize) > allProducts.length
        ? allProducts.length
        : (start + pageSize);
    return allProducts.sublist(start, end);
  }

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
