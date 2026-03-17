import '../services/api_service.dart';
import '../models/product.dart';

class ProductService {
  final ApiService _apiService = ApiService();

  Future<List<Product>> getProducts({int limit = 20, int page = 1}) {
    return _apiService.fetchProducts(limit: limit, page: page);
  }

  Future<List<Product>> getAllProducts() {
    return _apiService.fetchAllProducts();
  }

  Future<List<String>> getCategories() {
    return _apiService.fetchCategories();
  }

  Future<List<Product>> getProductsByCategory(String category) {
    return _apiService.fetchProductsByCategory(category);
  }
}
