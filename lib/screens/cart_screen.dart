import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:th4_e_commerce_app/providers/cart_provider.dart';
import 'package:th4_e_commerce_app/models/cart_item.dart';
import 'package:th4_e_commerce_app/utils/format_price.dart';
import 'package:th4_e_commerce_app/screens/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng'),
        backgroundColor: const Color(0xFF0076AA),
        foregroundColor: Colors.white,
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          final items = cart.items;
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Giỏ hàng của bạn đang trống',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0096D6),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Tiếp tục mua sắm'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final CartItem item = items[index];
                    final String itemKey = item.key;
                    return Dismissible(
                      key: ValueKey(itemKey),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) {
                        cart.removeProduct(itemKey);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${item.product.title} đã được xóa'),
                            duration: const Duration(milliseconds: 800),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 0.5,
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
                                activeColor: const Color(0xFF0096D6),
                                onChanged: (value) {
                                  if (value != null) {
                                    cart.setSelection(itemKey, value);
                                  }
                                },
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: Image.network(
                                    item.product.image,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stack) {
                                      return const Icon(
                                        Icons.image_not_supported,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
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
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'Phân loại: ${item.color}, ${item.size}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          formatPrice(
                                            item.product.price * 25000,
                                          ),
                                          style: const TextStyle(
                                            color: Color(0xFFE53935),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey.shade300,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  if (item.quantity <= 1) {
                                                    final confirm = await showDialog<bool>(
                                                      context: context,
                                                      builder: (dialogContext) {
                                                        return AlertDialog(
                                                          title: const Text(
                                                            'Xác nhận',
                                                          ),
                                                          content: const Text(
                                                            'Bạn có muốn xóa sản phẩm này khỏi giỏ hàng?',
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.of(
                                                                    dialogContext,
                                                                  ).pop(false),
                                                              child: const Text(
                                                                'Không',
                                                              ),
                                                            ),
                                                            ElevatedButton(
                                                              onPressed: () =>
                                                                  Navigator.of(
                                                                    dialogContext,
                                                                  ).pop(true),
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor:
                                                                    Colors.red,
                                                                foregroundColor:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                              child: const Text(
                                                                'Xóa',
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );

                                                    if (confirm == true) {
                                                      cart.removeProduct(
                                                        itemKey,
                                                      );
                                                    }
                                                    return;
                                                  }
                                                  cart.decrementQuantity(
                                                    itemKey,
                                                  );
                                                },
                                                child: const Icon(
                                                  Icons.remove,
                                                  size: 18,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                '${item.quantity}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              InkWell(
                                                onTap: () {
                                                  cart.incrementQuantity(
                                                    itemKey,
                                                  );
                                                },
                                                child: const Icon(
                                                  Icons.add,
                                                  size: 18,
                                                ),
                                              ),
                                            ],
                                          ),
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                  border: Border(top: BorderSide(color: Colors.grey.shade200)),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                            value: cart.allSelected,
                            activeColor: const Color(0xFF0096D6),
                            onChanged: (value) {
                              if (value != null) {
                                cart.setAllSelected(value);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('Chọn tất cả'),
                        const Spacer(),
                        const Text(
                          'Tổng thanh toán: ',
                          style: TextStyle(fontSize: 13),
                        ),
                        Text(
                          formatPrice(cart.totalSelectedPrice * 25000),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE53935),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0096D6),
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: cart.hasAnySelected
                          ? () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const CheckoutScreen(),
                                ),
                              );
                            }
                          : null,
                      child: Text(
                        'THANH TOÁN (${cart.items.where((e) => e.selected).length})',
                      ),
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
