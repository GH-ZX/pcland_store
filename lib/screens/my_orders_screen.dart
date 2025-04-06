import 'package:flutter/material.dart';
import 'package:pcland_store/providers/order_provider.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final orders = orderProvider.orders;

    return Scaffold(
      appBar: AppBar(title: Text('My Orders')),
      body:
          orders.isEmpty
              ? Center(child: Text('No orders yet.'))
              : ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // اسم المنتج
                          Text(
                            order.productName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // الكمية والسعر
                          Row(
                            children: [
                              Text('Quantity: ${order.quantity}'),
                              const SizedBox(width: 16),
                              Text('\$${order.price.toStringAsFixed(2)}'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // تاريخ الطلب
                          Text(
                            'Ordered on: ${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          // حالة الطلب
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: 12,
                                color: _getStatusColor(order.status),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                order.status,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _getStatusColor(order.status),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // أزرار الإجراءات
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  // تتبع الطلب
                                  _showTrackingDialog(context, order);
                                },
                                icon: Icon(Icons.track_changes),
                                label: Text('Track'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  // إلغاء الطلب
                                  _cancelOrder(context, order.id);
                                },
                                icon: Icon(Icons.cancel),
                                label: Text('Cancel'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }

  // دالة لتحديد لون حالة الطلب
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Processing':
        return Colors.orange;
      case 'Shipped':
        return Colors.blue;
      case 'Delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // عرض نافذة تتبع الطلب
  void _showTrackingDialog(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Track Order'),
            content: Text(
              'Your order is currently ${order.status.toLowerCase()}.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          ),
    );
  }

  // إلغاء الطلب
  void _cancelOrder(BuildContext context, String orderId) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    orderProvider.removeOrder(orderId);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Order canceled successfully.')));
  }
}
