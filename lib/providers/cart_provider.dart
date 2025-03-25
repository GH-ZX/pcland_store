import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartItem {
  final String id;
  final String productId;
  final String name;
  final double price;
  final String imageUrl;
  int quantity;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      productId: json['product_id'],
      name: json['name'],
      price: json['price'].toDouble(),
      imageUrl: json['image_url'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'name': name,
      'price': price,
      'image_url': imageUrl,
      'quantity': quantity,
    };
  }

  CartItem copyWith({
    String? id,
    String? productId,
    String? name,
    double? price,
    String? imageUrl,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];
  final String _cartKey = 'cart_items';

  List<CartItem> get items => [..._items];
  
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  
  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  CartProvider() {
    _loadCartFromPrefs();
  }

  Future<void> _loadCartFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cartData = prefs.getString(_cartKey);
    
    if (cartData != null) {
      List<dynamic> decodedData = json.decode(cartData);
      _items = decodedData.map((item) => CartItem.fromJson(item)).toList();
    }
    
    notifyListeners();
  }

  Future<void> _saveCartToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData = json.encode(_items.map((item) => item.toJson()).toList());
    await prefs.setString(_cartKey, encodedData);
  }

  int getItemIndex(String productId) {
    return _items.indexWhere((item) => item.productId == productId);
  }

  Future<void> addItem({
    required String productId,
    required String name,
    required double price,
    required String imageUrl,
  }) async {
    int existingIndex = getItemIndex(productId);
    
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += 1;
    } else {
      _items.add(
        CartItem(
          id: DateTime.now().toString(),
          productId: productId,
          name: name,
          price: price,
          imageUrl: imageUrl,
        ),
      );
    }
    
    await _saveCartToPrefs();
    notifyListeners();
  }

  Future<void> removeItem(String productId) async {
    _items.removeWhere((item) => item.productId == productId);
    await _saveCartToPrefs();
    notifyListeners();
  }

  Future<void> decreaseQuantity(String productId) async {
    int index = getItemIndex(productId);
    
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity -= 1;
      } else {
        _items.removeAt(index);
      }
      
      await _saveCartToPrefs();
      notifyListeners();
    }
  }

  Future<void> increaseQuantity(String productId) async {
    int index = getItemIndex(productId);
    
    if (index >= 0) {
      _items[index].quantity += 1;
      await _saveCartToPrefs();
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    _items = [];
    await _saveCartToPrefs();
    notifyListeners();
  }
}
