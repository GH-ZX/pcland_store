class Order {
  final String id;
  final String productName;
  final int quantity;
  final double price;
  final DateTime orderDate;
  final String status; // جديد: حالة الطلب

  Order({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.orderDate,
    this.status = 'Processing', // القيمة الافتراضية هي "قيد المعالجة"
  });
}
