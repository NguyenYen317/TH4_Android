import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:th4_e_commerce_app/models/product.dart';
import 'package:th4_e_commerce_app/providers/cart_provider.dart';
import 'package:th4_e_commerce_app/screens/cart_screen.dart';
import 'package:th4_e_commerce_app/services/product_service.dart';
import 'package:th4_e_commerce_app/utils/constants.dart';
import 'package:th4_e_commerce_app/widgets/banner_slider.dart';
import 'package:th4_e_commerce_app/widgets/category_grid.dart';
import 'package:th4_e_commerce_app/widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _productService = ProductService();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<String> _categories = [];

  String _selectedCategory = '';
  String _keyword = '';
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _error;

  String get _effectiveCategory {
    return _selectedCategory.isEmpty ? 'all' : _selectedCategory;
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _isLoadingMore = false;
      _currentPage = 1;
      _hasMore = true;
      _error = null;
    });

    try {
      final categories = await _productService.fetchCategories();
      final firstPage = await _productService.fetchProductsPage(
        page: _currentPage,
        category: _effectiveCategory,
      );

      setState(() {
        _allProducts = firstPage;
        _categories = categories;
        _hasMore = firstPage.length == AppConstants.homePageSize;
      });

      _applyFilters();
    } catch (_) {
      setState(() {
        _error = 'Không tải được dữ liệu. Vui lòng thử lại.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshData() async {
    await _loadInitialData();
  }

  void _applyFilters() {
    final byCategory = _selectedCategory.isEmpty || _selectedCategory == 'all'
        ? _allProducts
        : _allProducts.where((p) => p.category == _selectedCategory).toList();

    _filteredProducts = byCategory.where((product) {
      if (_keyword.trim().isEmpty) {
        return true;
      }
      return product.title.toLowerCase().contains(_keyword.toLowerCase());
    }).toList();

    setState(() {});
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 180) {
      _loadMoreProducts();
    }
  }

  Future<void> _loadMoreProducts() async {
    if (_isLoadingMore || !_hasMore || _isLoading) {
      return;
    }

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final nextPage = _currentPage + 1;
      final newProducts = await _productService.fetchProductsPage(
        page: nextPage,
        category: _effectiveCategory,
      );

      if (!mounted) {
        return;
      }

      _currentPage = nextPage;
      _allProducts = [..._allProducts, ...newProducts];
      _hasMore = newProducts.length == AppConstants.homePageSize;
      _applyFilters();
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = 'Không tải thêm được dữ liệu.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  void _onSearchChanged(String value) {
    _keyword = value;
    _applyFilters();
  }

  void _onCategoryChanged(String value) {
    setState(() {
      _selectedCategory = value;
    });
    _loadInitialData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _productService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0076AA),
        toolbarHeight: 62,
        centerTitle: true,
        title: const Text(
          AppConstants.homeAppBarTitle,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Tìm sản phẩm...',
                        prefixIcon: const Icon(Icons.search, size: 18),
                        suffixIcon: _searchController.text.isEmpty
                            ? null
                            : IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  _onSearchChanged('');
                                  FocusScope.of(context).unfocus();
                                },
                                icon: const Icon(Icons.close, size: 18),
                              ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.only(top: 8),
                        isDense: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Consumer<CartProvider>(
                  builder: (context, cart, _) {
                    return badges.Badge(
                      showBadge: cart.totalItems > 0,
                      badgeContent: Text(
                        '${cart.totalItems}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                      badgeStyle: const badges.BadgeStyle(
                        badgeColor: Color(0xFFFFD54F),
                        padding: EdgeInsets.all(5),
                      ),
                      position: badges.BadgePosition.topEnd(top: 4, end: 2),
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const CartScreen(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? _ErrorState(message: _error!, onRetry: _loadInitialData)
          : RefreshIndicator(
              color: const Color(0xFF0096D6),
              onRefresh: _refreshData,
              child: CustomScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: Column(
                        children: [
                          const BannerSlider(),
                          const SizedBox(height: 14),
                          _QuickActionRow(labels: AppConstants.quickActions),
                          const SizedBox(height: 14),
                          _SectionBox(
                            title: 'Danh mục',
                            child: CategoryGrid(
                              categories: _categories,
                              selectedCategory: _selectedCategory,
                              onCategorySelected: _onCategoryChanged,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const _SuggestionHeader(),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 18),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final product = _filteredProducts[index];
                        return ProductCard(
                          product: product,
                          onTap: () {
                            context.read<CartProvider>().addProduct(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Đã thêm ${product.title} vào giỏ hàng',
                                ),
                                duration: const Duration(milliseconds: 850),
                              ),
                            );
                          },
                          onAddToCart: () {
                            context.read<CartProvider>().addProduct(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Đã thêm ${product.title} vào giỏ hàng',
                                ),
                                duration: const Duration(milliseconds: 850),
                              ),
                            );
                          },
                        );
                      }, childCount: _filteredProducts.length),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: () {
                          final width = MediaQuery.of(context).size.width;
                          if (width < 500) return 2;
                          if (width < 900) return 3;
                          return 4;
                        }(),
                        childAspectRatio: 0.61,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: _isLoadingMore
                          ? const Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : !_hasMore
                          ? const Padding(
                              padding: EdgeInsets.only(bottom: 24),
                              child: Center(
                                child: Text(
                                  'Bạn đã xem hết sản phẩm!',
                                  style: TextStyle(color: Color(0xFF7D7D7D)),
                                ),
                              ),
                            )
                          : const SizedBox(height: 20),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _QuickActionRow extends StatelessWidget {
  const _QuickActionRow({required this.labels});

  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: labels.map((label) {
          return Expanded(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFFE0F7FF),
                  child: Icon(
                    Icons.tag_rounded,
                    color: Color(0xFF0096D6),
                    size: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF3B3B3B),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SectionBox extends StatelessWidget {
  const _SectionBox({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Text(
              title.toUpperCase(),
              style: const TextStyle(
                color: Color(0xFF6C6C6C),
                fontWeight: FontWeight.w500,
                fontSize: 19,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _SuggestionHeader extends StatelessWidget {
  const _SuggestionHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: const Border(
          bottom: BorderSide(color: Color(0xFF0096D6), width: 2.5),
        ),
      ),
      alignment: Alignment.center,
      child: const Text(
        'GỢI Ý HÔM NAY',
        style: TextStyle(
          color: Color(0xFF0096D6),
          letterSpacing: 0.4,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, style: const TextStyle(fontSize: 15)),
          const SizedBox(height: 12),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF0096D6),
            ),
            onPressed: onRetry,
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }
}
