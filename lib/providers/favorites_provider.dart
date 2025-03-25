import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteItem {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String? description;

  FavoriteItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.description,
  });

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      imageUrl: json['image_url'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image_url': imageUrl,
      'description': description ?? '',
    };
  }
}

class FavoritesProvider with ChangeNotifier {
  List<FavoriteItem> _items = [];
  final String _favoritesKey = 'favorite_items';

  List<FavoriteItem> get items => [..._items];
  
  int get itemCount => _items.length;
  
  bool isFavorite(String productId) {
    return _items.any((item) => item.id == productId);
  }

  FavoritesProvider() {
    _loadFavoritesFromPrefs();
  }

  Future<void> _loadFavoritesFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? favoritesData = prefs.getString(_favoritesKey);
    
    if (favoritesData != null) {
      List<dynamic> decodedData = json.decode(favoritesData);
      _items = decodedData.map((item) => FavoriteItem.fromJson(item)).toList();
    }
    
    notifyListeners();
  }

  Future<void> _saveFavoritesToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData = json.encode(_items.map((item) => item.toJson()).toList());
    await prefs.setString(_favoritesKey, encodedData);
  }

  Future<void> toggleFavorite({
    required String id,
    required String name,
    required double price,
    required String imageUrl,
    String? description,
  }) async {
    final existingIndex = _items.indexWhere((item) => item.id == id);
    
    if (existingIndex >= 0) {
      _items.removeAt(existingIndex);
    } else {
      _items.add(
        FavoriteItem(
          id: id,
          name: name,
          price: price,
          imageUrl: imageUrl,
          description: description ?? '',
        ),
      );
    }
    
    await _saveFavoritesToPrefs();
    notifyListeners();
  }

  Future<void> removeItem(String productId) async {
    _items.removeWhere((item) => item.id == productId);
    await _saveFavoritesToPrefs();
    notifyListeners();
  }

  Future<void> clearFavorites() async {
    _items = [];
    await _saveFavoritesToPrefs();
    notifyListeners();
  }
}
