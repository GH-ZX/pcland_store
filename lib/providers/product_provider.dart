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
      imageUrl: json['image_url'].map((path) => path).toList(),
      images: List<String>.from(json['images']).map((path) => path).toList(),
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
          category: 'Laptop', // تحديث
          price: 4999.99,
          oldPrice: 5499.99,
          imageUrl: 'assets/images/laptops/dell/xps_15_main.png',
          images: [
            'assets/images/laptops/dell/xps_15_side.png',
            'assets/images/laptops/dell/xps_15_back.png',
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
          category: 'Laptop', // تحديث
          price: 4599.99,
          oldPrice: 4999.99,
          imageUrl: 'assets/images/laptops/hp/spectre_x360_main.png',
          images: [
            'assets/images/laptops/hp/spectre_x360_side.png',
            'assets/images/laptops/hp/spectre_x360_back.png',
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
          category: 'Laptop',
          price: 5299.99,
          imageUrl: 'assets/images/laptops/lenovo/thinkpad_x1_carbon_main.png',
          images: [
            'assets/images/laptops/lenovo/thinkpad_x1_carbon_side.png',
            'assets/images/laptops/lenovo/thinkpad_x1_carbon_back.png',
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
          category: 'Laptop', // تحديث
          price: 7999.99,
          oldPrice: 8499.99,
          imageUrl: 'assets/images/laptops/samsung/book3_ultra_main.png',
          images: [
            'assets/images/laptops/samsung/book3_ultra_side.png',
            'assets/images/laptops/samsung/book3_ultra_back.png',
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
          category: 'Laptop',
          price: 8999.99,
          oldPrice: 9499.99,
          imageUrl: 'assets/images/laptops/apple/macbook_pro_16_main.png',
          images: [
            'assets/images/laptops/apple/macbook_pro_16_side.png',
            'assets/images/laptops/apple/macbook_pro_16_back.png',
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
            'الوزن': '2.15 كجم',
          },
          rating: 4.9,
          reviewCount: 205,
          brand: 'Apple',
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
        ),
        Product(
          id: '6',
          name: 'MSI Stealth 16',
          category: 'Laptop',
          price: 6799.99,
          oldPrice: 7299.99,
          imageUrl: 'assets/images/laptops/msi/stealth_16_main.png',
          images: [
            'assets/images/laptops/msi/stealth_16_side.png',
            'assets/images/laptops/msi/stealth_16_back.png',
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
            'الوزن': '1.99 كجم',
          },
          rating: 4.7,
          reviewCount: 87,
          brand: 'MSI',
          createdAt: DateTime.now().subtract(const Duration(days: 20)),
        ),
        Product(
          id: '7',
          name: 'ASUS ZenBook 14 OLED',
          category: 'Laptop',
          price: 3999.99,
          oldPrice: 4499.99,
          imageUrl: 'assets/images/laptops/asus/zenbook_14_main.png',
          images: [
            'assets/images/laptops/asus/zenbook_14_side.png',
            'assets/images/laptops/asus/zenbook_14_back.png',
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
          category: 'Laptop',
          price: 5999.99,
          oldPrice: 6499.99,
          imageUrl: 'assets/images/laptops/asus/rog_zephyrus_g14_main.png',
          images: [
            'assets/images/laptops/asus/rog_zephyrus_g14_side.png',
            'assets/images/laptops/asus/rog_zephyrus_g14_back.png',
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
            'الوزن': '1.65 كجم',
          },
          rating: 4.8,
          reviewCount: 145,
          brand: 'ASUS',
          createdAt: DateTime.now().subtract(const Duration(days: 25)),
        ),
        Product(
          id: '9',
          name: 'Acer Predator Helios 300',
          category: 'Laptop',
          price: 6499.99,
          oldPrice: 6999.99,
          imageUrl: 'assets/images/laptops/acer/predator_helios_300_main.png',
          images: [
            'assets/images/laptops/acer/predator_helios_300_side.png',
            'assets/images/laptops/acer/predator_helios_300_back.png',
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
          name: 'Microsoft Surface Laptop Studio',
          category: 'Laptop',
          price: 7299.99,
          oldPrice: 7799.99,
          imageUrl:
              'assets/images/laptops/microsoft/surface_laptop_studio_main.png',
          images: [
            'assets/images/laptops/microsoft/surface_laptop_studio_side.png',
            'assets/images/laptops/microsoft/surface_laptop_studio_back.png',
          ],
          description:
              'Microsoft Surface Laptop Studio with innovative design, powerful performance, and versatile functionality.',
          descriptionAr:
              'لابتوب مايكروسوفت Surface Laptop Studio بتصميم مبتكر وأداء قوي ووظائف متعددة.',
          specifications: {
            'processor': 'Intel Core i7-11370H',
            'memory': '32GB LPDDR4x',
            'storage': '1TB SSD',
            'graphics': 'NVIDIA GeForce RTX 3050 Ti',
            'display': '14.4" PixelSense Flow Touch 120Hz',
            'operating_system': 'Windows 11 Pro',
            'battery': 'Up to 18 hours',
            'weight': '1.82 kg',
          },
          specificationsAr: {
            'المعالج': 'Intel Core i7-11370H',
            'الذاكرة': '32GB LPDDR4x',
            'التخزين': '1TB SSD',
            'الرسومات': 'NVIDIA GeForce RTX 3050 Ti',
            'الشاشة': '14.4" PixelSense Flow تعمل باللمس 120Hz',
            'نظام التشغيل': 'Windows 11 Pro',
            'البطارية': 'حتى 18 ساعة',
            'الوزن': '1.82 كجم',
          },
          rating: 4.8,
          reviewCount: 95,
          brand: 'Microsoft',
          createdAt: DateTime.now().subtract(const Duration(days: 16)),
        ),
        Product(
          id: '11',
          name: 'Microsoft Surface Laptop 5',
          category: 'Laptop',
          price: 4799.99,
          oldPrice: 5299.99,
          imageUrl: 'assets/images/laptops/microsoft/surface_laptop_5_main.png',
          images: [
            'assets/images/laptops/microsoft/surface_laptop_5_side.png',
            'assets/images/laptops/microsoft/surface_laptop_5_back.png',
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
          category: 'Laptop',
          price: 8999.99,
          oldPrice: 9499.99,
          imageUrl: 'assets/images/laptops/alienware/x17_r2_main.png',
          images: [
            'assets/images/laptops/alienware/x17_r2_side.png',
            'assets/images/laptops/alienware/x17_r2_back.png',
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
            'الوزن': '3.02 كجم',
          },
          rating: 4.6,
          reviewCount: 54,
          brand: 'Alienware',
          createdAt: DateTime.now().subtract(const Duration(days: 28)),
        ),
        Product(
          id: '13',
          name: 'Lenovo Legion Pro 7i',
          category: 'Laptop',
          price: 7299.99,
          oldPrice: 7899.99,
          imageUrl: 'assets/images/laptops/lenovo/legion_pro_7i_main.png',
          images: [
            'assets/images/laptops/lenovo/legion_pro_7i_side.png',
            'assets/images/laptops/lenovo/legion_pro_7i_back.png',
          ],
          description:
              'Lenovo Legion Pro 7i gaming laptop with exceptional performance and advanced cooling system.',
          descriptionAr:
              'لابتوب لينوفو Legion Pro 7i للألعاب بأداء استثنائي ونظام تبريد متقدم.',
          specifications: {
            'processor': 'Intel Core i9-13900HX',
            'memory': '32GB DDR5',
            'storage': '2TB PCIe SSD',
            'graphics': 'NVIDIA GeForce RTX 4090',
            'display': '16" WQXGA 240Hz',
            'operating_system': 'Windows 11 Pro',
            'battery': '99.99Whr',
            'weight': '2.5 kg',
          },
          specificationsAr: {
            'المعالج': 'Intel Core i9-13900HX',
            'الذاكرة': '32GB DDR5',
            'التخزين': '2TB PCIe SSD',
            'الرسومات': 'NVIDIA GeForce RTX 4090',
            'الشاشة': '16" WQXGA 240Hz',
            'نظام التشغيل': 'Windows 11 Pro',
            'البطارية': '99.99 واط/ساعة',
            'الوزن': '2.5 كجم',
          },
          rating: 4.9,
          reviewCount: 78,
          brand: 'Lenovo',
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
        ),
        Product(
          id: '14',
          name: 'Lenovo Yoga 9i',
          category: 'Laptop',
          price: 4999.99,
          oldPrice: 5299.99,
          imageUrl: 'assets/images/laptops/lenovo/yoga_9i_main.png',
          images: [
            'assets/images/laptops/lenovo/yoga_9i_side.png',
            'assets/images/laptops/lenovo/yoga_9i_back.png',
          ],
          description:
              'Lenovo Yoga 9i convertible laptop with premium design and stunning OLED display.',
          descriptionAr:
              'لابتوب لينوفو Yoga 9i القابل للتحويل بتصميم فاخر وشاشة OLED مذهلة.',
          specifications: {
            'processor': 'Intel Core i7-1360P',
            'memory': '16GB LPDDR5',
            'storage': '1TB PCIe SSD',
            'graphics': 'Intel Iris Xe',
            'display': '14" 4K OLED Touch',
            'operating_system': 'Windows 11 Home',
            'battery': '75Whr',
            'weight': '1.4 kg',
          },
          specificationsAr: {
            'المعالج': 'Intel Core i7-1360P',
            'الذاكرة': '16GB LPDDR5',
            'التخزين': '1TB PCIe SSD',
            'الرسومات': 'Intel Iris Xe',
            'الشاشة': '14" 4K OLED تعمل باللمس',
            'نظام التشغيل': 'Windows 11 Home',
            'البطارية': '75 واط/ساعة',
            'الوزن': '1.4 كجم',
          },
          rating: 4.7,
          reviewCount: 92,
          brand: 'Lenovo',
          createdAt: DateTime.now().subtract(const Duration(days: 20)),
        ),
        Product(
          id: '15',
          name: 'Dell Precision 7780',
          category: 'Laptop',
          price: 9499.99,
          oldPrice: 9999.99,
          imageUrl: 'assets/images/laptops/dell/precision_7780_main.png',
          images: [
            'assets/images/laptops/dell/precision_7780_side.png',
            'assets/images/laptops/dell/precision_7780_back.png',
          ],
          description:
              'Dell Precision 7780 workstation laptop with professional-grade performance and reliability.',
          descriptionAr:
              'محطة عمل لابتوب Dell Precision 7780 بأداء احترافي وموثوقية عالية.',
          specifications: {
            'processor': 'Intel Core i9-13950HX',
            'memory': '64GB DDR5',
            'storage': '4TB PCIe SSD',
            'graphics': 'NVIDIA RTX 5000 Ada 16GB',
            'display': '17" UHD+ HDR',
            'operating_system': 'Windows 11 Pro',
            'battery': '93Whr',
            'weight': '3.2 kg',
          },
          specificationsAr: {
            'المعالج': 'Intel Core i9-13950HX',
            'الذاكرة': '64GB DDR5',
            'التخزين': '4TB PCIe SSD',
            'الرسومات': 'NVIDIA RTX 5000 Ada 16GB',
            'الشاشة': '17" UHD+ HDR',
            'نظام التشغيل': 'Windows 11 Pro',
            'البطارية': '93 واط/ساعة',
            'الوزن': '3.2 كجم',
          },
          rating: 4.8,
          reviewCount: 45,
          brand: 'Dell',
          createdAt: DateTime.now().subtract(const Duration(days: 25)),
        ),
        Product(
          id: '16',
          name: 'Dell G15 Gaming',
          category: 'Laptop',
          price: 4299.99,
          oldPrice: 4699.99,
          imageUrl: 'assets/images/laptops/dell/g15_main.png',
          images: [
            'assets/images/laptops/dell/g15_side.png',
            'assets/images/laptops/dell/g15_back.png',
          ],
          description:
              'Dell G15 Gaming laptop offering great gaming performance at an affordable price.',
          descriptionAr:
              'لابتوب Dell G15 للألعاب يقدم أداءً رائعاً للألعاب بسعر معقول.',
          specifications: {
            'processor': 'AMD Ryzen 7 7840HS',
            'memory': '16GB DDR5',
            'storage': '1TB SSD',
            'graphics': 'NVIDIA GeForce RTX 4060',
            'display': '15.6" FHD 165Hz',
            'operating_system': 'Windows 11 Home',
            'battery': '86Whr',
            'weight': '2.81 kg',
          },
          specificationsAr: {
            'المعالج': 'AMD Ryzen 7 7840HS',
            'الذاكرة': '16GB DDR5',
            'التخزين': '1TB SSD',
            'الرسومات': 'NVIDIA GeForce RTX 4060',
            'الشاشة': '15.6" FHD 165Hz',
            'نظام التشغيل': 'Windows 11 Home',
            'البطارية': '86 واط/ساعة',
            'الوزن': '2.81 كجم',
          },
          rating: 4.6,
          reviewCount: 156,
          brand: 'Dell',
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
        ),
        Product(
          id: '17',
          name: 'HP Omen 16',
          category: 'Laptop',
          price: 5999.99,
          oldPrice: 6499.99,
          imageUrl: 'assets/images/laptops/hp/omen_16_main.png',
          images: [
            'assets/images/laptops/hp/omen_16_side.png',
            'assets/images/laptops/hp/omen_16_back.png',
          ],
          description:
              'HP Omen 16 gaming laptop with powerful performance and advanced cooling system.',
          descriptionAr:
              'لابتوب HP Omen 16 للألعاب مع أداء قوي ونظام تبريد متقدم.',
          specifications: {
            'processor': 'Intel Core i9-13900HX',
            'memory': '32GB DDR5',
            'storage': '2TB PCIe Gen4 SSD',
            'graphics': 'NVIDIA GeForce RTX 4080',
            'display': '16.1" QHD 240Hz',
            'operating_system': 'Windows 11 Pro',
            'battery': '83Whr',
            'weight': '2.3 kg',
          },
          specificationsAr: {
            'المعالج': 'Intel Core i9-13900HX',
            'الذاكرة': '32GB DDR5',
            'التخزين': '2TB PCIe Gen4 SSD',
            'الرسومات': 'NVIDIA GeForce RTX 4080',
            'الشاشة': '16.1" QHD 240Hz',
            'نظام التشغيل': 'Windows 11 Pro',
            'البطارية': '83 واط/ساعة',
            'الوزن': '2.3 كجم',
          },
          rating: 4.8,
          reviewCount: 89,
          brand: 'HP',
          createdAt: DateTime.now().subtract(const Duration(days: 8)),
        ),
        Product(
          id: '18',
          name: 'HP Elite Dragonfly G3',
          category: 'Laptop',
          price: 5499.99,
          oldPrice: 5999.99,
          imageUrl: 'assets/images/laptops/hp/elite_dragonfly_g3_main.png',
          images: [
            'assets/images/laptops/hp/elite_dragonfly_g3_side.png',
            'assets/images/laptops/hp/elite_dragonfly_g3_back.png',
          ],
          description:
              'HP Elite Dragonfly G3 business laptop with premium design and enterprise security features.',
          descriptionAr:
              'لابتوب HP Elite Dragonfly G3 للأعمال بتصميم فاخر وميزات أمان للشركات.',
          specifications: {
            'processor': 'Intel Core i7-1265U',
            'memory': '32GB LPDDR5',
            'storage': '1TB PCIe Gen4 SSD',
            'graphics': 'Intel Iris Xe',
            'display': '13.5" 3K2K OLED Touch',
            'operating_system': 'Windows 11 Pro',
            'battery': '68Whr',
            'weight': '0.99 kg',
          },
          specificationsAr: {
            'المعالج': 'Intel Core i7-1265U',
            'الذاكرة': '32GB LPDDR5',
            'التخزين': '1TB PCIe Gen4 SSD',
            'الرسومات': 'Intel Iris Xe',
            'الشاشة': '13.5" 3K2K OLED تعمل باللمس',
            'نظام التشغيل': 'Windows 11 Pro',
            'البطارية': '68 واط/ساعة',
            'الوزن': '0.99 كجم',
          },
          rating: 4.7,
          reviewCount: 76,
          brand: 'HP',
          createdAt: DateTime.now().subtract(const Duration(days: 14)),
        ),
        Product(
          id: '19',
          name: 'MacBook Air M2',
          category: 'Laptop',
          price: 4999.99,
          oldPrice: 5299.99,
          imageUrl: 'assets/images/laptops/apple/macbook_air_m2_main.png',
          images: [
            'assets/images/laptops/apple/macbook_air_m2_side.png',
            'assets/images/laptops/apple/macbook_air_m2_back.png',
          ],
          description:
              'MacBook Air with M2 chip, featuring all-day battery life and stunning Liquid Retina display.',
          descriptionAr:
              'ماك بوك اير مع شريحة M2، يتميز ببطارية تدوم طوال اليوم وشاشة Liquid Retina مذهلة.',
          specifications: {
            'processor': 'Apple M2',
            'memory': '16GB Unified Memory',
            'storage': '512GB SSD',
            'graphics': 'Apple M2 10-core GPU',
            'display': '13.6" Liquid Retina',
            'operating_system': 'macOS',
            'battery': 'Up to 18 hours',
            'weight': '1.24 kg',
          },
          specificationsAr: {
            'المعالج': 'Apple M2',
            'الذاكرة': '16GB Unified Memory',
            'التخزين': '512GB SSD',
            'الرسومات': 'Apple M2 10-core GPU',
            'الشاشة': '13.6" Liquid Retina',
            'نظام التشغيل': 'macOS',
            'البطارية': 'حتى 18 ساعة',
            'الوزن': '1.24 كجم',
          },
          rating: 4.9,
          reviewCount: 245,
          brand: 'Apple',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
        Product(
          id: '20',
          name: 'MacBook Pro 14',
          category: 'Laptop',
          price: 7499.99,
          oldPrice: 7999.99,
          imageUrl: 'assets/images/laptops/apple/macbook_pro_14_main.png',
          images: [
            'assets/images/laptops/apple/macbook_pro_14_side.png',
            'assets/images/laptops/apple/macbook_pro_14_back.png',
          ],
          description:
              'MacBook Pro 14 with M2 Max chip, delivering extraordinary performance and battery life.',
          descriptionAr:
              'ماك بوك برو 14 مع شريحة M2 Max، يقدم أداءً استثنائياً وعمر بطارية طويل.',
          specifications: {
            'processor': 'Apple M2 Max',
            'memory': '32GB Unified Memory',
            'storage': '1TB SSD',
            'graphics': 'Apple M2 Max 30-core GPU',
            'display': '14.2" Liquid Retina XDR',
            'operating_system': 'macOS',
            'battery': 'Up to 18 hours',
            'weight': '1.61 kg',
          },
          specificationsAr: {
            'المعالج': 'Apple M2 Max',
            'الذاكرة': '32GB Unified Memory',
            'التخزين': '1TB SSD',
            'الرسومات': 'Apple M2 Max 30-core GPU',
            'الشاشة': '14.2" Liquid Retina XDR',
            'نظام التشغيل': 'macOS',
            'البطارية': 'حتى 18 ساعة',
            'الوزن': '1.61 كجم',
          },
          rating: 4.9,
          reviewCount: 178,
          brand: 'Apple',
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
        ),
        Product(
          id: '21',
          name: 'MSI GL75 Leopard',
          category: 'Laptop',
          price: 5999.99,
          oldPrice: 6499.99,
          imageUrl: 'assets/images/laptops/msi/gl75_leopard_main.png',
          images: [
            'assets/images/laptops/msi/gl75_leopard_side.png',
            'assets/images/laptops/msi/gl75_leopard_back.png',
          ],
          description:
              'MSI GL75 Leopard gaming laptop with powerful performance and high-refresh-rate display.',
          descriptionAr:
              'لابتوب MSI GL75 Leopard للألعاب بأداء قوي وشاشة ذات معدل تحديث عالي.',
          specifications: {
            'processor': 'Intel Core i7-10750H',
            'memory': '16GB DDR4',
            'storage': '1TB NVMe SSD',
            'graphics': 'NVIDIA GeForce RTX 3060',
            'display': '17.3" FHD 144Hz',
            'operating_system': 'Windows 11 Home',
            'battery': '51Whr',
            'weight': '2.6 kg',
          },
          specificationsAr: {
            'المعالج': 'Intel Core i7-10750H',
            'الذاكرة': '16GB DDR4',
            'التخزين': '1TB NVMe SSD',
            'الرسومات': 'NVIDIA GeForce RTX 3060',
            'الشاشة': '17.3" FHD 144Hz',
            'نظام التشغيل': 'Windows 11 Home',
            'البطارية': '51 واط/ساعة',
            'الوزن': '2.6 كجم',
          },
          rating: 4.6,
          reviewCount: 128,
          brand: 'MSI',
          createdAt: DateTime.now().subtract(const Duration(days: 22)),
        ),
        Product(
          id: '22',
          name: 'Samsung Galaxy Book3 Pro',
          category: 'Laptop',
          price: 5999.99,
          oldPrice: 6499.99,
          imageUrl: 'assets/images/laptops/samsung/book3_pro_main.png',
          images: [
            'assets/images/laptops/samsung/book3_pro_side.png',
            'assets/images/laptops/samsung/book3_pro_back.png',
          ],
          description:
              'Samsung Galaxy Book3 Pro with Dynamic AMOLED display and powerful Intel processor.',
          descriptionAr:
              'سامسونج جالاكسي بوك3 برو مع شاشة Dynamic AMOLED ومعالج انتل قوي.',
          specifications: {
            'processor': 'Intel Core i7-1360P',
            'memory': '16GB LPDDR5',
            'storage': '512GB NVMe SSD',
            'graphics': 'Intel Iris Xe',
            'display': '14" 3K AMOLED (2880x1800)',
            'operating_system': 'Windows 11 Pro',
            'battery': '63Whr',
            'weight': '1.17 kg',
          },
          specificationsAr: {
            'المعالج': 'Intel Core i7-1360P',
            'الذاكرة': '16GB LPDDR5',
            'التخزين': '512GB NVMe SSD',
            'الرسومات': 'Intel Iris Xe',
            'الشاشة': '14" 3K AMOLED (2880x1800)',
            'نظام التشغيل': 'Windows 11 Pro',
            'البطارية': '63 واط/ساعة',
            'الوزن': '1.17 كجم',
          },
          rating: 4.7,
          reviewCount: 85,
          brand: 'Samsung',
          createdAt: DateTime.now().subtract(const Duration(days: 18)),
        ),
        Product(
          id: '23',
          name: 'Samsung Galaxy Book3 360',
          category: 'Laptop',
          price: 4999.99,
          oldPrice: 5499.99,
          imageUrl: 'assets/images/laptops/samsung/book3_360_main.png',
          images: [
            'assets/images/laptops/samsung/book3_360_side.png',
            'assets/images/laptops/samsung/book3_360_back.png',
          ],
          description:
              'Samsung Galaxy Book3 360 convertible laptop with S Pen support and versatile design.',
          descriptionAr:
              'سامسونج جالاكسي بوك3 360 القابل للتحويل مع دعم S Pen وتصميم متعدد الاستخدامات.',
          specifications: {
            'processor': 'Intel Core i7-1360P',
            'memory': '16GB LPDDR5',
            'storage': '512GB NVMe SSD',
            'graphics': 'Intel Iris Xe',
            'display': '15.6" FHD AMOLED Touch',
            'operating_system': 'Windows 11 Home',
            'battery': '68Whr',
            'weight': '1.46 kg',
          },
          specificationsAr: {
            'المعالج': 'Intel Core i7-1360P',
            'الذاكرة': '16GB LPDDR5',
            'التخزين': '512GB NVMe SSD',
            'الرسومات': 'Intel Iris Xe',
            'الشاشة': '15.6" FHD AMOLED تعمل باللمس',
            'نظام التشغيل': 'Windows 11 Home',
            'البطارية': '68 واط/ساعة',
            'الوزن': '1.46 كجم',
          },
          rating: 4.6,
          reviewCount: 92,
          brand: 'Samsung',
          createdAt: DateTime.now().subtract(const Duration(days: 25)),
        ),
        Product(
          id: '24',
          name: 'Acer Nitro 5',
          category: 'Laptop',
          price: 4299.99,
          oldPrice: 4799.99,
          imageUrl: 'assets/images/laptops/acer/nitro_5_main.png',
          images: [
            'assets/images/laptops/acer/nitro_5_side.png',
            'assets/images/laptops/acer/nitro_5_back.png',
          ],
          description:
              'Acer Nitro 5 gaming laptop with powerful performance and advanced cooling.',
          descriptionAr: 'لابتوب ايسر نيترو 5 للألعاب بأداء قوي وتبريد متقدم.',
          specifications: {
            'processor': 'AMD Ryzen 7 6800H',
            'memory': '16GB DDR5',
            'storage': '1TB NVMe SSD',
            'graphics': 'NVIDIA GeForce RTX 3060',
            'display': '15.6" FHD 144Hz IPS',
            'operating_system': 'Windows 11 Home',
            'battery': '57Whr',
            'weight': '2.5 kg',
          },
          specificationsAr: {
            'المعالج': 'AMD Ryzen 7 6800H',
            'الذاكرة': '16GB DDR5',
            'التخزين': '1TB NVMe SSD',
            'الرسومات': 'NVIDIA GeForce RTX 3060',
            'الشاشة': '15.6" FHD 144Hz IPS',
            'نظام التشغيل': 'Windows 11 Home',
            'البطارية': '57 واط/ساعة',
            'الوزن': '2.5 كجم',
          },
          rating: 4.5,
          reviewCount: 165,
          brand: 'Acer',
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
        ),
        Product(
          id: '25',
          name: 'Alienware m18',
          category: 'Laptop',
          price: 9999.99,
          oldPrice: 10499.99,
          imageUrl: 'assets/images/laptops/alienware/m18_main.png',
          images: [
            'assets/images/laptops/alienware/m18_side.png',
            'assets/images/laptops/alienware/m18_back.png',
          ],
          description:
              'Alienware m18 gaming laptop with ultimate performance and immersive 18-inch display.',
          descriptionAr:
              'لابتوب الين وير m18 للألعاب بأداء فائق وشاشة غامرة مقاس 18 بوصة.',
          specifications: {
            'processor': 'Intel Core i9-13980HX',
            'memory': '64GB DDR5',
            'storage': '4TB (2x 2TB) PCIe NVMe SSD',
            'graphics': 'NVIDIA GeForce RTX 4090',
            'display': '18" QHD+ 165Hz',
            'operating_system': 'Windows 11 Pro',
            'battery': '97Whr',
            'weight': '3.83 kg',
          },
          specificationsAr: {
            'المعالج': 'Intel Core i9-13980HX',
            'الذاكرة': '64GB DDR5',
            'التخزين': '4TB (2x 2TB) PCIe NVMe SSD',
            'الرسومات': 'NVIDIA GeForce RTX 4090',
            'الشاشة': '18" QHD+ 165Hz',
            'نظام التشغيل': 'Windows 11 Pro',
            'البطارية': '97 واط/ساعة',
            'الوزن': '3.83 كجم',
          },
          rating: 4.9,
          reviewCount: 48,
          brand: 'Alienware',
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
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

  String getImagePath(String path) {
    return 'assets/images/$path';
  }

  List<Product> getProductsByCategory(String category) {
    return _items.where((product) => product.category == category).toList();
  }

  List<Product> getProductsByBrand(String brand) {
    return _items.where((product) => product.brand == brand).toList();
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
