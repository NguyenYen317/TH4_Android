import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:th4_e_commerce_app/providers/order_provider.dart';
import 'package:th4_e_commerce_app/models/order.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Đơn mua'),
          backgroundColor: const Color(0xFF0076AA),
          foregroundColor: Colors.white,
          bottom: const TabBar(
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
                  orders: orders
                      .where((o) => o.status == OrderStatus.pending)
                      .toList(),
                ),
                _OrderList(
                  orders: orders
                      .where((o) => o.status == OrderStatus.shipping)
                      .toList(),
                ),
                _OrderList(
                  orders: orders
                      .where((o) => o.status == OrderStatus.delivered)
                      .toList(),
                ),
                _OrderList(
                  orders: orders
                      .where((o) => o.status == OrderStatus.cancelled)
                      .toList(),
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
  const _OrderList({required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const Center(child: Text('Không có đơn hàng nào.'));
    }
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: ListTile(
            title: Text('Mã đơn: ${order.id}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tổng tiền: ${order.total.toStringAsFixed(0)}đ',
                  style: const TextStyle(color: Colors.red),
                ),
                Text('Địa chỉ: ${order.address}'),
                Text('PT thanh toán: ${order.paymentMethod}'),
                Text(
                  'Ngày đặt: ${order.createdAt.toString().substring(0, 16)}',
                ),
                Text('Số sản phẩm: ${order.items.length}'),
              ],
            ),
            trailing: _statusText(order.status),
            onTap: () {
              // Có thể mở chi tiết đơn hàng nếu muốn
            },
          ),
        );
      },
    );
  }

  Widget _statusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return const Text(
          'Chờ xác nhận',
          style: TextStyle(color: Colors.orange),
        );
      case OrderStatus.shipping:
        return const Text('Đang giao', style: TextStyle(color: Colors.blue));
      case OrderStatus.delivered:
        return const Text('Đã giao', style: TextStyle(color: Colors.green));
      case OrderStatus.cancelled:
        return const Text('Đã hủy', style: TextStyle(color: Colors.red));
    }
  }
}
