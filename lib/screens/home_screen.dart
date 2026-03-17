import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../services/product_service.dart';
import '../widgets/banner_slider.dart';
import '../widgets/category_grid.dart';
import '../widgets/product_card.dart';

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
  List<Product> _displayedProducts = [];
  List<String> _categories = [];
  String? _selectedCategory;
  String _searchQuery = '';

  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  static const int _pageSize = 10;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        _productService.getAllProducts(),
        _productService.getCategories(),
      ]);
      _allProducts = results[0] as List<Product>;
      _categories = results[1] as List<String>;
      _currentPage = 0;
      _applyFilters(reset: true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tải dữ liệu: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _applyFilters({bool reset = false}) {
    if (reset) {
      _currentPage = 0;
      _displayedProducts = [];
      _hasMore = true;
    }

    List<Product> filtered = _allProducts;

    if (_selectedCategory != null) {
      filtered =
          filtered.where((p) => p.category == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      filtered =
          filtered.where((p) => p.title.toLowerCase().contains(q)).toList();
    }

    final start = _currentPage * _pageSize;
    if (start >= filtered.length) {
      setState(() => _hasMore = false);
      return;
    }

    final end = (start + _pageSize).clamp(0, filtered.length);
    final newItems = filtered.sublist(start, end);

    setState(() {
      if (reset) {
        _displayedProducts = newItems;
      } else {
        _displayedProducts = [..._displayedProducts, ...newItems];
      }
      _hasMore = end < filtered.length;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _hasMore) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;
    setState(() => _isLoadingMore = true);
    await Future.delayed(const Duration(milliseconds: 300));
    _currentPage++;
    _applyFilters();
    if (mounted) setState(() => _isLoadingMore = false);
  }

  Future<void> _onRefresh() async {
    await _loadInitialData();
  }

  void _onSearchChanged(String query) {
    setState(() => _searchQuery = query);
    _applyFilters(reset: true);
  }

  void _onCategorySelected(String? category) {
    setState(() => _selectedCategory = category);
    _applyFilters(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mini E-Commerce',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, _) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: badges.Badge(
                  badgeContent: Text(
                    '${cart.itemCount}',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  showBadge: cart.itemCount > 0,
                  child: IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {},
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        // Search bar
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            controller: _searchController,
                            onChanged: _onSearchChanged,
                            decoration: InputDecoration(
                              hintText: 'Tìm kiếm sản phẩm...',
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _searchController.clear();
                                        _onSearchChanged('');
                                      },
                                    )
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Banner slider
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: BannerSlider(),
                        ),
                        const SizedBox(height: 16),
                        // Categories
                        if (_categories.isNotEmpty) ...[
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Danh mục',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 8),
                          CategoryGrid(
                            categories: _categories,
                            selectedCategory: _selectedCategory,
                            onCategorySelected: _onCategorySelected,
                          ),
                          const SizedBox(height: 16),
                        ],
                        // Products header
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sản phẩm',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${_displayedProducts.length} sản phẩm',
                                style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                  // Product grid
                  _displayedProducts.isEmpty
                      ? const SliverFillRemaining(
                          child: Center(
                            child: Text(
                              'Không tìm thấy sản phẩm',
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 16),
                            ),
                          ),
                        )
                      : SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverGrid(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return ProductCard(
                                  product: _displayedProducts[index],
                                  onTap: () {},
                                  onAddToCart: () {
                                    context
                                        .read<CartProvider>()
                                        .addProduct(
                                            _displayedProducts[index]);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                            'Đã thêm vào giỏ hàng'),
                                        duration:
                                            const Duration(seconds: 1),
                                        behavior:
                                            SnackBarBehavior.floating,
                                      ),
                                    );
                                  },
                                );
                              },
                              childCount: _displayedProducts.length,
                            ),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.65,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                          ),
                        ),
                  // Loading more indicator
                  if (_isLoadingMore)
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child:
                            Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  if (!_hasMore && _displayedProducts.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: Text(
                            'Đã hiển thị tất cả sản phẩm',
                            style: TextStyle(
                                color: Colors.grey.shade500, fontSize: 13),
                          ),
                        ),
                      ),
                    ),
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                ],
              ),
      ),
    );
  }
}
