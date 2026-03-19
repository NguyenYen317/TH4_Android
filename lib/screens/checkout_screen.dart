import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:th4_e_commerce_app/providers/cart_provider.dart';
import 'package:th4_e_commerce_app/models/cart_item.dart';
import 'package:th4_e_commerce_app/providers/order_provider.dart';
import 'package:th4_e_commerce_app/models/order.dart';
import 'package:th4_e_commerce_app/utils/format_price.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _addressController = TextEditingController();
  String _paymentMethod = 'COD';

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final selectedItems = cart.items.where((item) => item.selected).toList();
    final total = selectedItems.fold<double>(
      0,
      (sum, item) => sum + item.subTotal,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán'),
        backgroundColor: const Color(0xFF0076AA),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Địa chỉ nhận hàng',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nhập địa chỉ nhận hàng',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Phương thức thanh toán',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Radio<String>(
                  value: 'COD',
                  groupValue: _paymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _paymentMethod = value!;
                    });
                  },
                ),
                const Text('COD'),
                const SizedBox(width: 20),
                Radio<String>(
                  value: 'Momo',
                  groupValue: _paymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _paymentMethod = value!;
                    });
                  },
                ),
                const Text('Momo'),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Sản phẩm đã chọn',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: selectedItems.length,
                itemBuilder: (context, index) {
                  final CartItem item = selectedItems[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Image.network(
                      item.product.image,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      item.product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                    subtitle: Text(
                      'SL: ${item.quantity} | Size: ${item.size} | Màu: ${item.color}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Text(
                      formatPrice(item.subTotal * 25000),
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tổng thanh toán:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  formatPrice(total * 25000),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedItems.isEmpty
                    ? null
                    : () async {
                        if (_addressController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Vui lòng nhập địa chỉ nhận hàng!'),
                            ),
                          );
                          return;
                        }
                        // Tạo đơn hàng mới
                        final order = Order(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          items: List<CartItem>.from(selectedItems),
                          address: _addressController.text.trim(),
                          paymentMethod: _paymentMethod,
                          total: total,
                          status: OrderStatus.pending,
                          createdAt: DateTime.now(),
                        );
                        await orderProvider.addOrder(order);
                        // Xóa các sản phẩm đã đặt khỏi giỏ
                        for (final item in selectedItems) {
                          cart.removeProduct(item.key);
                        }
                        // Hiện dialog thành công
                        if (!mounted) return;
                        await showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Đặt hàng thành công!'),
                            content: const Text(
                              'Cảm ơn bạn đã mua hàng. Đơn hàng đã được ghi nhận.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                        if (mounted) {
                          Navigator.of(
                            context,
                          ).popUntil((route) => route.isFirst);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0096D6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Đặt hàng', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
