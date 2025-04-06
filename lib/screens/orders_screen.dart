import 'package:flutter/material.dart';
import 'package:pcland_store/providers/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:pcland_store/services/app_localizations.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final orders = orderProvider.orders;
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.translate('my_orders'))),
      body:
          orders.isEmpty
              ? Center(child: Text(localizations.translate('no_orders')))
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
                          // إضافة صف يحتوي على الصورة واسم المنتج
                          Row(
                            children: [
                              // صورة المنتج
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: AssetImage(order.imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // تفاصيل المنتج
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      order.productName,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Text(
                                          '${localizations.translate('quantity_label')}: ${order.quantity}',
                                        ),
                                        const SizedBox(width: 16),
                                        Text(
                                          '${order.price.toStringAsFixed(2)} ${localizations.translate('currency')}',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // باقي المحتوى كما هو
                          Text(
                            '${localizations.translate('ordered_on')}: ${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}',
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
                                label: Text(localizations.translate('track')),
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
                                label: Text(
                                  localizations.translate('cancel_order'),
                                ),
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
    final localizations = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(localizations.translate('track_order')),
            content: Text(
              localizations
                  .translate('track_order_status')
                  .replaceAll(
                    '{status}',
                    localizations.translate(order.status.toLowerCase()),
                  ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(localizations.translate('close')),
              ),
            ],
          ),
    );
  }

  // إلغاء الطلب
  void _cancelOrder(BuildContext context, String orderId) {
    final localizations = AppLocalizations.of(context);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(localizations.translate('cancel_order')),
            content: Text(
              localizations.translate('cancel_order_confirmation'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(localizations.translate('back')),
              ),
              TextButton(
                onPressed: () {
                  orderProvider.removeOrder(orderId);
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(localizations.translate('order_canceled')),
                    ),
                  );
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text(
                  localizations.translate('confirm'),
                ), 
              ),
            ],
          ),
    );
  }
}
