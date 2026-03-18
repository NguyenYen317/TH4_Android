import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:th4_e_commerce_app/providers/cart_provider.dart';
import 'package:th4_e_commerce_app/models/cart_item.dart';
import 'package:th4_e_commerce_app/utils/format_price.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng'),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          final items = cart.items;
          if (items.isEmpty) {
            return const Center(
              child: Text('Giỏ hàng trống'),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final CartItem item = items[index];
                    return Dismissible(
                      key: ValueKey(item.product.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) {
                        cart.removeProduct(item.product.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${item.product.title} đã được xóa'),
                            duration: const Duration(milliseconds: 800),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: item.selected,
                                onChanged: (value) {
                                  if (value != null) {
                                    cart.setSelection(item.product.id, value);
                                  }
                                },
                              ),
                              SizedBox(
                                width: 70,
                                height: 70,
                                child: Image.network(
                                  item.product.image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stack) {
                                    return const Icon(Icons.image_not_supported);
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text('Kích thước: ${item.size} - Màu: ${item.color}'),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Đơn giá: ${formatPrice(item.product.price * 25000)}',
                                      style: const TextStyle(color: Colors.green),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove_circle_outline),
                                          onPressed: () async {
                                            if (item.quantity <= 1) {
                                              final confirm = await showDialog<bool>(
                                                context: context,
                                                builder: (dialogContext) {
                                                  return AlertDialog(
                                                    title: const Text('Xác nhận'),
                                                    content: const Text('Bạn có muốn xóa sản phẩm này?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () => Navigator.of(dialogContext).pop(false),
                                                        child: const Text('Không'),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () => Navigator.of(dialogContext).pop(true),
                                                        child: const Text('Có'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );

                                              if (confirm == true) {
                                                cart.removeProduct(item.product.id);
                                              }
                                              return;
                                            }
                                            cart.decrementQuantity(item.product.id);
                                          },
                                        ),
                                        Text('${item.quantity}'),
                                        IconButton(
                                          icon: const Icon(Icons.add_circle_outline),
                                          onPressed: () {
                                            cart.incrementQuantity(item.product.id);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey.shade300)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: cart.allSelected,
                          onChanged: (value) {
                            if (value != null) {
                              cart.setAllSelected(value);
                            }
                          },
                        ),
                        const Text('Chọn tất cả'),
                        const Spacer(),
                        Text(
                          'Tổng: ${formatPrice(cart.totalSelectedPrice * 25000)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(42),
                      ),
                      onPressed: cart.hasAnySelected ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Đã thanh toán (giả lập).')),
                        );
                      } : null,
                      child: const Text('Thanh toán'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
