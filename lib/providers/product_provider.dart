import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final double? oldPrice;
  final String imageUrl;
  final List<String> images;
  final String description;
  final String descriptionAr;
  final Map<String, dynamic> specifications;
  final Map<String, dynamic> specificationsAr;
  final double rating;
  final int reviewCount;
  final bool inStock;
  final String brand;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.oldPrice,
    required this.imageUrl,
    required this.images,
    required this.description,
    required this.descriptionAr,
    required this.specifications,
    required this.specificationsAr,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.inStock = true,
    required this.brand,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      price: json['price'].toDouble(),
      oldPrice: json['old_price']?.toDouble(),
      imageUrl: json['image_url'],
      images: List<String>.from(json['images']),
      description: json['description'],
      descriptionAr: json['description_ar'],
      specifications: Map<String, dynamic>.from(json['specifications']),
      specificationsAr: Map<String, dynamic>.from(json['specifications_ar']),
      rating: json['rating']?.toDouble() ?? 0.0,
      reviewCount: json['review_count'] ?? 0,
      inStock: json['in_stock'] ?? true,
      brand: json['brand'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'old_price': oldPrice,
      'image_url': imageUrl,
      'images': images,
      'description': description,
      'description_ar': descriptionAr,
      'specifications': specifications,
      'specifications_ar': specificationsAr,
      'rating': rating,
      'review_count': reviewCount,
      'in_stock': inStock,
      'brand': brand,
      'created_at': createdAt.toIso8601String(),
    };
  }

  double get discountPercentage {
    if (oldPrice == null || oldPrice! <= price) return 0.0;
    return ((oldPrice! - price) / oldPrice! * 100).roundToDouble();
  }

  bool get hasDiscount => oldPrice != null && oldPrice! > price;
}

class ProductProvider with ChangeNotifier {
  List<Product> _items = [];
  bool _isLoading = false;
  String? _error;

  List<Product> get items => [..._items];
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Mock data for demonstration
  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock data with reliable image URLs
      _items = [
        Product(
          id: '1',
          name: 'Dell XPS 15',
          category: 'laptops',
          price: 4999.99,
          oldPrice: 5499.99,
          imageUrl:
              'https://i.dell.com/is/image/DellContent/content/dam/ss2/product-images/dell-client-products/notebooks/xps-notebooks/xps-15-9530/media-gallery/touch-black/notebook-xps-15-9530-t-black-gallery-1.psd?fmt=png-alpha&pscan=auto&scl=1&hei=402&wid=654&qlt=100,1&resMode=sharp2&size=654,402&chrss=full',
          images: [
            'https://i.dell.com/is/image/DellContent/content/dam/ss2/product-images/dell-client-products/notebooks/xps-notebooks/xps-15-9530/media-gallery/touch-black/notebook-xps-15-9530-t-black-gallery-4.psd?fmt=png-alpha&pscan=auto&scl=1&hei=402&wid=677&qlt=100,1&resMode=sharp2&size=677,402&chrss=full',
            'https://i.dell.com/is/image/DellContent/content/dam/ss2/product-images/dell-client-products/notebooks/xps-notebooks/xps-15-9530/media-gallery/touch-black/notebook-xps-15-9530-t-black-gallery-5.psd?fmt=png-alpha&pscan=auto&scl=1&hei=402&wid=677&qlt=100,1&resMode=sharp2&size=677,402&chrss=full',
          ],
          description:
              'Dell XPS 15 laptop with 12th Gen Intel Core i7 processor, high-resolution display, and long-lasting battery.',
          descriptionAr:
              'لابتوب ديل XPS 15 مع معالج انتل كور i7 من الجيل الثاني عشر وشاشة عالية الدقة وبطارية تدوم طويلاً.',
          specifications: {
            'processor': 'Intel Core i7-12700H',
            'memory': '16GB DDR5',
            'storage': '512GB SSD',
            'graphics': 'NVIDIA GeForce RTX 3050 Ti',
            'display': '15.6" 4K OLED Touch',
            'operating_system': 'Windows 11 Pro',
            'battery': '86Whr',
            'weight': '1.8 kg',
          },
          specificationsAr: {
            'المعالج': 'انتل كور i7-12700H',
            'الذاكرة': '16 جيجابايت DDR5',
            'التخزين': '512 جيجابايت SSD',
            'الرسومات': 'انفيديا جي فورس RTX 3050 Ti',
            'الشاشة': 'شاشة لمس OLED 4K مقاس 15.6 بوصة',
            'نظام التشغيل': 'ويندوز 11 برو',
            'البطارية': '86 واط/ساعة',
            'الوزن': '1.8 كجم',
          },
          rating: 4.8,
          reviewCount: 124,
          brand: 'Dell',
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
        ),
        Product(
          id: '2',
          name: 'HP Spectre x360',
          category: 'laptops',
          price: 4599.99,
          oldPrice: 4999.99,
          imageUrl:
              'https://m.media-amazon.com/images/I/81ZvaBihNsL.__AC_SY300_SX300_QL70_FMwebp_.jpg',
          images: [
            'https://m.media-amazon.com/images/I/81BmB0Mx2rL._AC_SX466_.jpg',
            'https://m.media-amazon.com/images/I/71PUZ9o9U6L._AC_SX466_.jpg',
          ],
          description:
              'HP Spectre x360 convertible laptop with touchscreen, excellent performance, and elegant design.',
          descriptionAr:
              'لابتوب HP Spectre x360 قابل للتحويل مع شاشة لمس وأداء ممتاز وتصميم أنيق.',
          specifications: {
            'processor': 'Intel Core i7-1260P',
            'memory': '16GB LPDDR4x',
            'storage': '1TB SSD',
            'graphics': 'Intel Iris Xe',
            'display': '13.5" 3K2K OLED Touch',
            'operating_system': 'Windows 11 Home',
            'battery': '66Whr',
            'weight': '1.36 kg',
          },
          specificationsAr: {
            'المعالج': 'انتل كور i7-1260P',
            'الذاكرة': '16 جيجابايت LPDDR4x',
            'التخزين': '1 تيرابايت SSD',
            'الرسومات': 'انتل آيريس Xe',
            'الشاشة': 'شاشة لمس OLED 3K2K مقاس 13.5 بوصة',
            'نظام التشغيل': 'ويندوز 11 هوم',
            'البطارية': '66 واط/ساعة',
            'الوزن': '1.36 كجم',
          },
          rating: 4.7,
          reviewCount: 89,
          brand: 'HP',
          createdAt: DateTime.now().subtract(const Duration(days: 45)),
        ),
        Product(
          id: '3',
          name: 'Lenovo ThinkPad X1 Carbon',
          category: 'laptops',
          price: 5299.99,
          imageUrl:
              'https://m.media-amazon.com/images/I/61XXyxsfdRL.__AC_SY300_SX300_QL70_FMwebp_.jpg',
          images: [
            'https://m.media-amazon.com/images/I/616lsDxAaCL._AC_SX466_.jpg',
            ' https://m.media-amazon.com/images/I/61z0CIA8JKL._AC_SL1500_.jpg',
          ],
          description:
              'Lenovo ThinkPad X1 Carbon laptop ideal for business with advanced security and excellent performance.',
          descriptionAr:
              'لابتوب لينوفو ThinkPad X1 Carbon مثالي للأعمال مع أمان متقدم وأداء ممتاز.',
          specifications: {
            'processor': 'Intel Core i7-1270P vPro',
            'memory': '16GB LPDDR5',
            'storage': '1TB SSD',
            'graphics': 'Intel Iris Xe',
            'display': '14" WUXGA IPS',
            'operating_system': 'Windows 11 Pro',
            'battery': '57Whr',
            'weight': '1.12 kg',
          },
          specificationsAr: {
            'المعالج': 'انتل كور i7-1270P vPro',
            'الذاكرة': '16 جيجابايت LPDDR5',
            'التخزين': '1 تيرابايت SSD',
            'الرسومات': 'انتل آيريس Xe',
            'الشاشة': 'شاشة IPS WUXGA مقاس 14 بوصة',
            'نظام التشغيل': 'ويندوز 11 برو',
            'البطارية': '57 واط/ساعة',
            'الوزن': '1.12 كجم',
          },
          rating: 4.9,
          reviewCount: 156,
          brand: 'Lenovo',
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
        ),
        Product(
          id: '3', // ID جديد للمنتج
          name: 'Samsung Galaxy Book3 Ultra',
          category: 'laptops',
          price: 7999.99,
          oldPrice: 8499.99,
          imageUrl:
              'https://m.media-amazon.com/images/I/619AWhGKTEL._AC_SX679_.jpg',
          images: [
            'https://m.media-amazon.com/images/I/51S94EVMNbL._AC_SX679_.jpg',
            'https://m.media-amazon.com/images/I/51dcDr-HZIL._AC_SL1500_.jpg',
          ],
          description:
              'Samsung Galaxy Book3 Ultra laptop with powerful performance, stunning AMOLED display, and sleek design.',
          descriptionAr:
              'لابتوب Samsung Galaxy Book3 Ultra بأداء قوي، شاشة AMOLED مذهلة وتصميم أنيق.',
          specifications: {
            'processor': 'Intel Core i9-13900H',
            'memory': '32GB LPDDR5',
            'storage': '1TB SSD',
            'graphics': 'NVIDIA GeForce RTX 4070',
            'display': '16" 4K AMOLED Touch',
            'operating_system': 'Windows 11 Pro',
            'battery': '76Whr',
            'weight': '1.8 kg',
          },
          specificationsAr: {
            'المعالج': 'Intel Core i9-13900H',
            'الذاكرة': '32 جيجابايت LPDDR5',
            'التخزين': '1 تيرابايت SSD',
            'الرسومات': 'NVIDIA GeForce RTX 4070',
            'الشاشة': 'شاشة لمس AMOLED 4K مقاس 16 بوصة',
            'نظام التشغيل': 'ويندوز 11 برو',
            'البطارية': '76 واط/ساعة',
            'الوزن': '1.8 كجم',
          },
          rating: 4.8,
          reviewCount: 120,
          brand: 'Samsung',
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
        ),
        Product(
          id: '5',
          name: 'MacBook Pro 16',
          category: 'laptops',
          price: 8999.99,
          oldPrice: 9499.99,
          imageUrl:
              'https://m.media-amazon.com/images/I/71pC69I3lzL.__AC_SY445_SX342_QL70_FMwebp_.jpg',
          images: [
            'https://m.media-amazon.com/images/I/81aot0jAfFL._AC_SX522_.jpg',
            'https://m.media-amazon.com/images/I/718Pz9bYxWL._AC_SX522_.jpg',
          ],
          description:
              'MacBook Pro 16 laptop with M2 Pro chip, Liquid Retina XDR display, and exceptional performance.',
          descriptionAr:
              'لابتوب ماك بوك برو 16 مع شريحة M2 Pro وشاشة Liquid Retina XDR وأداء استثنائي.',
          specifications: {
            'processor': 'Apple M2 Pro',
            'memory': '32GB Unified Memory',
            'storage': '1TB SSD',
            'graphics': 'Apple M2 Pro 19-core GPU',
            'display': '16.2" Liquid Retina XDR',
            'operating_system': 'macOS',
            'battery': 'Up to 22 hours',
            'weight': '2.15 kg',
          },
          specificationsAr: {
            'المعالج': 'Apple M2 Pro',
            'الذاكرة': '32GB Unified Memory',
            'التخزين': '1TB SSD',
            'الرسومات': 'Apple M2 Pro 19-core GPU',
            'الشاشة': '16.2" Liquid Retina XDR',
            'نظام التشغيل': 'macOS',
            'البطارية': 'Up to 22 hours',
            'الوزن': '2.15 kg',
          },
          rating: 4.9,
          reviewCount: 205,
          brand: 'Apple',
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
        ),
        Product(
          id: '6',
          name: 'MSI Stealth 16',
          category: 'gaming',
          price: 6799.99,
          oldPrice: 7299.99,
          imageUrl:
              'https://m.media-amazon.com/images/I/71cWXOi88TL.__AC_SX300_SY300_QL70_FMwebp_.jpg',
          images: [
            'https://m.media-amazon.com/images/I/81xnPxvo-rL._AC_SX466_.jpg',
            'https://m.media-amazon.com/images/I/71j1xB7xqJL._AC_SX466_.jpg',
          ],
          description:
              'MSI Stealth 16 gaming laptop with powerful processor, advanced graphics, and effective cooling.',
          descriptionAr:
              'لابتوب MSI Stealth 16 للألعاب مع معالج قوي وكرت شاشة متطور وتبريد فعال.',
          specifications: {
            'processor': 'Intel Core i9-13900H',
            'memory': '32GB DDR5',
            'storage': '2TB NVMe SSD',
            'graphics': 'NVIDIA GeForce RTX 4070',
            'display': '16" QHD+ 240Hz',
            'operating_system': 'Windows 11 Pro',
            'battery': '99.9Whr',
            'weight': '1.99 kg',
          },
          specificationsAr: {
            'المعالج': 'Intel Core i9-13900H',
            'الذاكرة': '32GB DDR5',
            'التخزين': '2TB NVMe SSD',
            'الرسومات': 'NVIDIA GeForce RTX 4070',
            'الشاشة': '16" QHD+ 240Hz',
            'نظام التشغيل': 'Windows 11 Pro',
            'البطارية': '99.9Whr',
            'الوزن': '1.99 kg',
          },
          rating: 4.7,
          reviewCount: 87,
          brand: 'MSI',
          createdAt: DateTime.now().subtract(const Duration(days: 20)),
        ),
        Product(
          id: '7',
          name: 'ASUS ZenBook 14 OLED',
          category: 'laptops',
          price: 3999.99,
          oldPrice: 4499.99,
          imageUrl:
              'https://m.media-amazon.com/images/I/51okgnHrVkL._AC_SX466_.jpg',
          images: [
            'https://m.media-amazon.com/images/I/41EZVl5-AeL._AC_SX466_.jpg',
            'https://m.media-amazon.com/images/I/51-wW42X--L._AC_SL1000_.jpg',
          ],
          description:
              'ASUS ZenBook 14 OLED laptop with vibrant OLED display, compact design, and powerful performance.',
          descriptionAr:
              'لابتوب ASUS ZenBook 14 OLED بشاشة OLED مشرقة، تصميم مدمج وأداء قوي.',
          specifications: {
            'processor': 'AMD Ryzen 7 5800H',
            'memory': '16GB LPDDR4X',
            'storage': '1TB PCIe SSD',
            'graphics': 'NVIDIA GeForce MX450',
            'display': '14" 2.8K OLED (2880 x 1800), 90Hz',
            'operating_system': 'Windows 11 Home',
            'battery': '63Whr',
            'weight': '1.39 kg',
          },
          specificationsAr: {
            'المعالج': 'AMD Ryzen 7 5800H',
            'الذاكرة': '16GB LPDDR4X',
            'التخزين': '1TB PCIe SSD',
            'الرسومات': 'NVIDIA GeForce MX450',
            'الشاشة': '14" 2.8K OLED (2880 x 1800), 90Hz',
            'نظام التشغيل': 'Windows 11 Home',
            'البطارية': '63 واط/ساعة',
            'الوزن': '1.39 كجم',
          },
          rating: 4.8,
          reviewCount: 130,
          brand: 'ASUS',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
        Product(
          id: '8',
          name: 'ASUS ROG Zephyrus G14',
          category: 'gaming',
          price: 5999.99,
          oldPrice: 6499.99,
          imageUrl:
              'https://m.media-amazon.com/images/I/81m-xYfxznL.__AC_SY300_SX300_QL70_FMwebp_.jpg',
          images: [
            'https://m.media-amazon.com/images/I/51671b+p4bL._AC_SX466_.jpg',
            'https://m.media-amazon.com/images/I/61g8-qIlt0L._AC_SX466_.jpg',
          ],
          description:
              'ASUS ROG Zephyrus G14 gaming laptop with powerful performance in a lightweight design.',
          descriptionAr:
              'لابتوب ASUS ROG Zephyrus G14 للألعاب مع أداء قوي في تصميم خفيف الوزن.',
          specifications: {
            'processor': 'AMD Ryzen 9 7940HS',
            'memory': '16GB DDR5',
            'storage': '1TB PCIe 4.0 SSD',
            'graphics': 'NVIDIA GeForce RTX 4060',
            'display': '14" QHD+ 165Hz',
            'operating_system': 'Windows 11 Home',
            'battery': '76Whr',
            'weight': '1.65 kg',
          },
          specificationsAr: {
            'المعالج': 'AMD Ryzen 9 7940HS',
            'الذاكرة': '16GB DDR5',
            'التخزين': '1TB PCIe 4.0 SSD',
            'الرسومات': 'NVIDIA GeForce RTX 4060',
            'الشاشة': '14" QHD+ 165Hz',
            'نظام التشغيل': 'Windows 11 Home',
            'البطارية': '76Whr',
            'الوزن': '1.65 kg',
          },
          rating: 4.8,
          reviewCount: 145,
          brand: 'ASUS',
          createdAt: DateTime.now().subtract(const Duration(days: 25)),
        ),
        Product(
          id: '9', // ID جديد للمنتج
          name: 'Acer Predator Helios 300',
          category: 'laptops',
          price: 6499.99,
          oldPrice: 6999.99,
          imageUrl:
              'https://m.media-amazon.com/images/I/71sS7G5ZpQL._AC_SL1500_.jpg',
          images: [
            'https://m.media-amazon.com/images/I/71AZoZVYdFL._AC_SL1500_.jpg',
            'https://m.media-amazon.com/images/I/71famvQhb0L._AC_SL1500_.jpg',
          ],
          description:
              'Acer Predator Helios 300 gaming laptop with powerful Intel Core i7 processor, NVIDIA GeForce RTX 3060, and a high-refresh-rate display.',
          descriptionAr:
              'لابتوب Acer Predator Helios 300 للألعاب مع معالج Intel Core i7 قوي، كرت شاشة NVIDIA GeForce RTX 3060 وشاشة ذات معدل تحديث عالي.',
          specifications: {
            'processor': 'Intel Core i7-12700H',
            'memory': '16GB DDR5',
            'storage': '512GB SSD',
            'graphics': 'NVIDIA GeForce RTX 3060',
            'display': '15.6" Full HD 144Hz IPS',
            'operating_system': 'Windows 11 Home',
            'battery': '56Whr',
            'weight': '2.4 kg',
          },
          specificationsAr: {
            'المعالج': 'Intel Core i7-12700H',
            'الذاكرة': '16GB DDR5',
            'التخزين': '512GB SSD',
            'الرسومات': 'NVIDIA GeForce RTX 3060',
            'الشاشة': '15.6" Full HD 144Hz IPS',
            'نظام التشغيل': 'Windows 11 Home',
            'البطارية': '56Whr',
            'الوزن': '2.4 كجم',
          },
          rating: 4.7,
          reviewCount: 110,
          brand: 'Acer',
          createdAt: DateTime.now().subtract(const Duration(days: 12)),
        ),
        Product(
          id: '10',
          name: 'Razer Blade 15',
          category: 'gaming',
          price: 7499.99,
          imageUrl:
              'https://m.media-amazon.com/images/I/71kcJxMggRL._AC_SX466_.jpg',
          images: [
            'https://m.media-amazon.com/images/I/710ktDbS7-L._AC_SX466_.jpg',
            'https://m.media-amazon.com/images/I/71Jbr7BGgSL._AC_SL1500_.jpg',
          ],
          description:
              'Razer Blade 15 gaming laptop with sleek design, powerful performance, and high-refresh-rate display.',
          descriptionAr:
              'لابتوب Razer Blade 15 للألعاب مع تصميم أنيق وأداء قوي وشاشة عالية التحديث.',
          specifications: {
            'processor': 'Intel Core i9-13900H',
            'memory': '32GB DDR5',
            'storage': '1TB PCIe Gen4 SSD',
            'graphics': 'NVIDIA GeForce RTX 4080',
            'display': '15.6" QHD 240Hz',
            'operating_system': 'Windows 11 Pro',
            'battery': '80Whr',
            'weight': '2.01 kg',
          },
          specificationsAr: {
            'المعالج': 'Intel Core i9-13900H',
            'الذاكرة': '32GB DDR5',
            'التخزين': '1TB PCIe Gen4 SSD',
            'الرسومات': 'NVIDIA GeForce RTX 4080',
            'الشاشة': '15.6" QHD 240Hz',
            'نظام التشغيل': 'Windows 11 Pro',
            'البطارية': '80Whr',
            'الوزن': '2.01 kg',
          },
          rating: 4.7,
          reviewCount: 92,
          brand: 'Razer',
          createdAt: DateTime.now().subtract(const Duration(days: 18)),
        ),
        Product(
          id: '11',
          name: 'Microsoft Surface Laptop 5',
          category: 'laptops',
          price: 4799.99,
          oldPrice: 5299.99,
          imageUrl:
              'https://m.media-amazon.com/images/I/61N76Vyn7nL.__AC_SX300_SY300_QL70_FMwebp_.jpg',
          images: [
            'https://m.media-amazon.com/images/I/714kJoQ-0zL._AC_SX466_.jpg',
            'https://m.media-amazon.com/images/I/614xqqwzToL._AC_SX466_.jpg',
          ],
          description:
              'Microsoft Surface Laptop 5 with sleek design, powerful performance, and long-lasting battery.',
          descriptionAr:
              'لابتوب Microsoft Surface Laptop 5 بتصميم أنيق وأداء قوي وبطارية تدوم طويلاً.',
          specifications: {
            'processor': 'Intel Core i7-1255U',
            'memory': '16GB LPDDR5',
            'storage': '512GB SSD',
            'graphics': 'Intel Iris Xe',
            'display': '13.5" PixelSense Touch',
            'operating_system': 'Windows 11 Pro',
            'battery': 'Up to 17 hours',
            'weight': '1.26 kg',
          },
          specificationsAr: {
            'المعالج': 'Intel Core i7-1255U',
            'الذاكرة': '16GB LPDDR5',
            'التخزين': '512GB SSD',
            'الرسومات': 'Intel Iris Xe',
            'الشاشة': '13.5" PixelSense Touch',
            'نظام التشغيل': 'Windows 11 Pro',
            'البطارية': 'تصل إلى 17 ساعة',
            'الوزن': '1.26 كجم',
          },
          rating: 4.8,
          reviewCount: 102,
          brand: 'Microsoft',
          createdAt: DateTime.now().subtract(const Duration(days: 22)),
        ),
        Product(
          id: '12',
          name: 'Alienware x17 R2',
          category: 'gaming',
          price: 8999.99,
          oldPrice: 9499.99,
          imageUrl:
              'https://m.media-amazon.com/images/I/81DjXH4tlHL.__AC_SX300_SY300_QL70_FMwebp_.jpg',
          images: [
            'https://m.media-amazon.com/images/I/81oMT5RcWZL._AC_SX466_.jpg',
            'https://m.media-amazon.com/images/I/81e5WWkfs1L._AC_SX466_.jpg',
          ],
          description:
              'Alienware x17 R2 gaming laptop with advanced features, powerful performance, and advanced cooling system.',
          descriptionAr:
              'لابتوب Alienware x17 R2 للألعاب المتطورة مع أقوى المواصفات ونظام تبريد متقدم.',
          specifications: {
            'processor': 'Intel Core i9-12900HK',
            'memory': '64GB DDR5',
            'storage': '4TB SSD (2x 2TB RAID0)',
            'graphics': 'NVIDIA GeForce RTX 3080 Ti 16GB',
            'display': '17.3" UHD 120Hz',
            'operating_system': 'Windows 11 Pro',
            'battery': '87Whr',
            'weight': '3.02 kg',
          },
          specificationsAr: {
            'المعالج': 'Intel Core i9-12900HK',
            'الذاكرة': '64GB DDR5',
            'التخزين': '4TB SSD (2x 2TB RAID0)',
            'الرسومات': 'NVIDIA GeForce RTX 3080 Ti 16GB',
            'الشاشة': '17.3" UHD 120Hz',
            'نظام التشغيل': 'Windows 11 Pro',
            'البطارية': '87Whr',
            'الوزن': '3.02 kg',
          },
          rating: 4.6,
          reviewCount: 54,
          brand: 'Alienware',
          createdAt: DateTime.now().subtract(const Duration(days: 28)),
        ),
      ];

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _error = error.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Product> getProductsByCategory(String category) {
    return _items.where((product) => product.category == category).toList();
  }

  List<Product> get newArrivals {
    final sortedProducts = [..._items];
    sortedProducts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sortedProducts.take(5).toList();
  }

  List<Product> get bestSellers {
    final sortedProducts = [..._items];
    sortedProducts.sort((a, b) => b.rating.compareTo(a.rating));
    return sortedProducts.take(5).toList();
  }

  List<Product> get specialOffers {
    return _items.where((product) => product.hasDiscount).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  List<Product> searchProducts(String query) {
    if (query.isEmpty) return [];

    final lowercaseQuery = query.toLowerCase();
    return _items.where((product) {
      final lowercaseName = product.name.toLowerCase();
      final lowercaseBrand = product.brand.toLowerCase();
      final lowercaseDescription = product.description.toLowerCase();

      return lowercaseName.contains(lowercaseQuery) ||
          lowercaseBrand.contains(lowercaseQuery) ||
          lowercaseDescription.contains(lowercaseQuery);
    }).toList();
  }
}
