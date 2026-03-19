import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:th4_e_commerce_app/providers/order_provider.dart';
import 'package:th4_e_commerce_app/models/order.dart';
import 'package:th4_e_commerce_app/utils/format_price.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: const Text('Đơn mua', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: const Color(0xFF0076AA),
          foregroundColor: Colors.white,
          elevation: 0,
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
            tabs: [
              Tab(text: 'Chờ xác nhận'),
              Tab(text: 'Đang giao'),
              Tab(text: 'Đã giao'),
              Tab(text: 'Đã hủy'),
            ],
          ),
        ),
        body: Consumer<OrderProvider>(
          builder: (context, orderProvider, _) {
            final orders = orderProvider.orders;
            
            return TabBarView(
              children: [
                _OrderList(
                  orders: orders.where((o) => o.status == OrderStatus.pending).toList(),
                  emptyMessage: 'Chưa có đơn hàng nào đang chờ xác nhận',
                ),
                _OrderList(
                  orders: orders.where((o) => o.status == OrderStatus.shipping).toList(),
                  emptyMessage: 'Chưa có đơn hàng nào đang được giao',
                ),
                _OrderList(
                  orders: orders.where((o) => o.status == OrderStatus.delivered).toList(),
                  emptyMessage: 'Bạn chưa có đơn hàng nào đã giao thành công',
                ),
                _OrderList(
                  orders: orders.where((o) => o.status == OrderStatus.cancelled).toList(),
                  emptyMessage: 'Danh sách đơn đã hủy trống',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  final List<Order> orders;
  final String emptyMessage;

  const _OrderList({required this.orders, required this.emptyMessage});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final firstItem = order.items.isNotEmpty ? order.items.first : null;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (firstItem != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          firstItem.product.image,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (context, _, __) => Container(
                            width: 70,
                            height: 70,
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.image_not_supported),
                          ),
                        ),
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            firstItem?.product.title ?? 'Đơn hàng #${order.id}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Phân loại: ${firstItem?.color ?? ""}, ${firstItem?.size ?? ""}',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('x${firstItem?.quantity ?? 0}', style: const TextStyle(fontSize: 13)),
                              Text(
                                formatPrice((firstItem?.product.price ?? 0) * 25000),
                                style: const TextStyle(color: Color(0xFF0096D6), fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (order.items.length > 1)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Divider(height: 1, color: Colors.grey.shade200),
                ),
              if (order.items.length > 1)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Xem thêm ${order.items.length - 1} sản phẩm',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${order.items.length} sản phẩm',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                        ),
                        Row(
                          children: [
                            const Text('Thành tiền: ', style: TextStyle(fontSize: 13)),
                            Text(
                              formatPrice(order.total * 25000),
                              style: const TextStyle(
                                color: Color(0xFFE53935),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _statusBadge(order.status),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _statusBadge(OrderStatus status) {
    String text = '';
    Color color = Colors.grey;

    switch (status) {
      case OrderStatus.pending:
        text = 'Chờ xác nhận';
        color = Colors.orange;
        break;
      case OrderStatus.shipping:
        text = 'Đang giao';
        color = Colors.blue;
        break;
      case OrderStatus.delivered:
        text = 'Đã giao';
        color = Colors.green;
        break;
      case OrderStatus.cancelled:
        text = 'Đã hủy';
        color = Colors.red;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}
