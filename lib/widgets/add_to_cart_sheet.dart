import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:th4_e_commerce_app/models/product.dart';
import 'package:th4_e_commerce_app/providers/cart_provider.dart';
import 'package:th4_e_commerce_app/utils/format_price.dart';

class AddToCartSheet extends StatefulWidget {
  const AddToCartSheet({super.key, required this.product});

  final Product product;

  @override
  State<AddToCartSheet> createState() => _AddToCartSheetState();
}

class _AddToCartSheetState extends State<AddToCartSheet> {
  String _selectedSize = 'M';
  int _quantity = 1;
  int _selectedColorIndex = 0;

  final List<Map<String, dynamic>> _availableColors = [
    {'name': 'Xanh', 'color': Colors.blue},
    {'name': 'Đỏ', 'color': Colors.red},
    {'name': 'Đen', 'color': Colors.black},
  ];

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: Image.network(product.image, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      formatPrice(product.price * 25000),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFE53935),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('Kích cỡ', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['S', 'M', 'L', 'XL'].map((s) {
              final selected = s == _selectedSize;
              return ChoiceChip(
                label: Text(s),
                selected: selected,
                onSelected: (_) => setState(() => _selectedSize = s),
                selectedColor: const Color(0xFF0096D6).withOpacity(0.2),
                labelStyle: TextStyle(
                  color: selected ? const Color(0xFF0096D6) : Colors.black,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          const Text('Màu sắc', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            children: List.generate(_availableColors.length, (i) {
              return GestureDetector(
                onTap: () => setState(() => _selectedColorIndex = i),
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: _selectedColorIndex == i
                        ? Border.all(width: 2, color: const Color(0xFF0096D6))
                        : Border.all(width: 2, color: Colors.transparent),
                  ),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: _availableColors[i]['color'],
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Số lượng',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _quantity > 1
                          ? () => setState(() => _quantity--)
                          : null,
                      icon: const Icon(Icons.remove),
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      padding: EdgeInsets.zero,
                    ),
                    Container(
                      width: 40,
                      alignment: Alignment.center,
                      child: Text('$_quantity', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                    IconButton(
                      onPressed: () => setState(() => _quantity++),
                      icon: const Icon(Icons.add),
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0096D6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    final colorName = _availableColors[_selectedColorIndex]['name'];
                    context.read<CartProvider>().addProduct(
                      product,
                      quantity: _quantity,
                      size: _selectedSize,
                      color: colorName,
                    );
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Đã thêm $_quantity ${product.title} ($colorName, $_selectedSize) vào giỏ hàng'),
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: const Text('XÁC NHẬN', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
