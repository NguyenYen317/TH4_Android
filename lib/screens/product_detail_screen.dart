import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:th4_e_commerce_app/models/product.dart';
import 'package:th4_e_commerce_app/utils/format_price.dart';
import 'package:th4_e_commerce_app/widgets/add_to_cart_sheet.dart';
import 'package:th4_e_commerce_app/providers/cart_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentIndex = 0;
  bool _isDescriptionExpanded = false;

  void _openOptionsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddToCartSheet(product: widget.product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final baseImage = product.image;
    final demoImages = [
      'https://picsum.photos/seed/${product.id}-1/600/600',
      'https://picsum.photos/seed/${product.id}-2/600/600',
      'https://picsum.photos/seed/${product.id}-3/600/600',
    ];
    final images = product.images.length > 1
        ? product.images
        : (baseImage.isEmpty ? demoImages : [baseImage, baseImage, baseImage]);
    final imageAlignments = [Alignment.center, Alignment.topLeft, Alignment.bottomRight];
    final imageScales = [1.0, 1.25, 1.25];
    final oldPrice = product.price * 1.35;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0076AA),
        elevation: 0,
        title: Text(
          product.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Hero(
              tag: 'product-${product.id}',
              child: PageView.builder(
                itemCount: images.length,
                onPageChanged: (i) => setState(() => _currentIndex = i),
                itemBuilder: (context, index) {
                  final alignment =
                      imageAlignments[index % imageAlignments.length];
                  final scale = imageScales[index % imageScales.length];
                  return ClipRect(
                    child: Align(
                      alignment: alignment,
                      child: Transform.scale(
                        scale: scale,
                        child: Image.network(
                          images[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.image_not_supported_outlined),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if (images.length != 1)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                  (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: _currentIndex == index ? 18 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _currentIndex == index
                            ? const Color(0xFF0096D6)
                            : Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    );
                  },
                ),
              ),
            ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      formatPrice(product.price * 25000),
                      style: const TextStyle(
                        fontSize: 22,
                        color: Color(0xFFE53935),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      formatPrice(oldPrice * 25000),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF9A9A9A),
                        decoration: TextDecoration.lineThrough,
                        decorationColor: Color(0xFF9A9A9A),
                        decorationThickness: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Ph\u00e2n lo\u1ea1i',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: _openOptionsSheet,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE6E6E6)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Ch\u1ecdn K\u00edch c\u1ee1, M\u00e0u s\u1eafc',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Text(
                          'Ch\u1ecdn',
                          style: TextStyle(color: Color(0xFF7A7A7A)),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.chevron_right,
                          color: Color(0xFF7A7A7A),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'M\u00f4 t\u1ea3 chi ti\u1ebft',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Text(
                  product.description,
                  maxLines: _isDescriptionExpanded ? null : 5,
                  overflow: _isDescriptionExpanded
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF444444),
                    height: 1.4,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _isDescriptionExpanded = !_isDescriptionExpanded;
                      });
                    },
                    child: Text(
                      _isDescriptionExpanded ? 'Thu g\u1ecdn' : 'Xem th\u00eam',
                      style: const TextStyle(color: Color(0xFF0096D6)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Chat v\u1edbi shop (demo)'),
                            duration: Duration(milliseconds: 900),
                          ),
                        );
                      },
                      icon: const Icon(Icons.chat_bubble_outline),
                      color: const Color(0xFF0096D6),
                    ),
                    Consumer<CartProvider>(
                      builder: (context, cart, _) {return badges.Badge(
                          showBadge: cart.totalItems != 0,
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
                          position: badges.BadgePosition.topEnd(
                            top: 4,
                            end: 4,
                          ),
                          child: IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('B\u1ea1n \u0111\u00e3 m\u1edf gi\u1ecf h\u00e0ng (demo)'),
                                  duration: Duration(milliseconds: 900),
                                ),
                              );
                            },
                            icon: const Icon(Icons.shopping_cart_outlined),
                            color: const Color(0xFF0096D6),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF0096D6)),
                          foregroundColor: const Color(0xFF0096D6),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: _openOptionsSheet,
                        child: const Text(
                          'Th\u00eam v\u00e0o gi\u1ecf h\u00e0ng',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0096D6),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: _openOptionsSheet,
                        child: const Text(
                          'Mua ngay',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

