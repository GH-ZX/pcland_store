import 'package:flutter/material.dart';

class Order {
  final String id;
  final String productName;
  final int quantity;
  final double price;
  final DateTime orderDate;
  String status; // حالة الطلب (قيد المعالجة، تم الشحن، تم التسليم)

  Order({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.orderDate,
    this.status = 'Processing', // القيمة الافتراضية هي "قيد المعالجة"
  });
}

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];

  // الحصول على جميع الطلبات
  List<Order> get orders => [..._orders];

  // الحصول على الطلبات بناءً على حالتها
  List<Order> getOrdersByStatus(String status) {
    return _orders.where((order) => order.status == status).toList();
  }

  // إضافة طلب جديد
  void addOrder(Order order) {
    _orders.add(order);
    notifyListeners();
  }

  // تحديث حالة الطلب
  void updateOrderStatus(String orderId, String newStatus) {
    final order = _orders.firstWhere((order) => order.id == orderId);
    if (order != null) {
      order.status = newStatus; // تحديث حالة الطلب
      notifyListeners();
    }
  }

  // حذف طلب
  void removeOrder(String orderId) {
    _orders.removeWhere((order) => order.id == orderId);
    notifyListeners();
  }

  // مسح جميع الطلبات
  void clearOrders() {
    _orders.clear();
    notifyListeners();
  }

  // التحقق مما إذا كان هناك طلبات
  bool hasOrders() {
    return _orders.isNotEmpty;
  }
}
