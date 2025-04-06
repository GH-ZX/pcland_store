import 'package:flutter/material.dart';


class Order {
  final String id;
  final String productName;
  final int quantity;
  final double price;
  final DateTime orderDate;
  final String imageUrl; // إضافة حقل الصورة
  String status; // حالة الطلب (قيد المعالجة، تم الشحن، تم التسليم)

  Order({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.orderDate,
    required this.imageUrl, // إضافة الصورة كحقل مطلوب
    this.status = 'Processing', // القيمة الافتراضية هي "قيد المعالجة"
  });
}

class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];

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
    order.status = newStatus; // تحديث حالة الطلب
    notifyListeners();
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
