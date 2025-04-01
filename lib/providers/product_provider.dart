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

  // هون مشان التخفيضات
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

  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      _items = [
        Product(
          id: '1',
          name: 'Dell XPS 15',
          category: 'laptops',
          price: 499.99,
          oldPrice: 549.99,
          imageUrl:
              'https://i.dell.com/is/image/DellContent/content/dam/ss2/product-images/dell-client-products/notebooks/xps-notebooks/xps-15-9520/media-gallery/black/laptop-xps-15-9520-black-gallery-4.psd?fmt=png-alpha&pscan=auto&scl=1&hei=402&wid=402&qlt=100,1&resMode=sharp2&size=402,402&chrss=full',
          images: [
            'https://i.dell.com/is/image/DellContent/content/dam/ss2/product-images/dell-client-products/notebooks/xps-notebooks/xps-15-9520/media-gallery/black/laptop-xps-15-9520-black-gallery-4.psd?fmt=png-alpha&pscan=auto&scl=1&hei=402&wid=402&qlt=100,1&resMode=sharp2&size=402,402&chrss=full',
            'https://i.dell.com/is/image/DellContent/content/dam/ss2/product-images/dell-client-products/notebooks/xps-notebooks/xps-15-9520/media-gallery/black/laptop-xps-15-9520-black-gallery-3.psd?fmt=png-alpha&pscan=auto&scl=1&hei=402&wid=402&qlt=100,1&resMode=sharp2&size=402,402&chrss=full',
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
          price: 459.99,
          oldPrice: 499.99,
          imageUrl:
              'https://ssl-product-images.www8-hp.com/digmedialib/prodimg/lowres/c08037217.png?impolicy=prdimg&imdensity=1&imwidth=400',
          images: [
            'https://ssl-product-images.www8-hp.com/digmedialib/prodimg/lowres/c08037217.png?impolicy=prdimg&imdensity=1&imwidth=400',
            'https://ssl-product-images.www8-hp.com/digmedialib/prodimg/lowres/c08037218.png?impolicy=prdimg&imdensity=1&imwidth=400',
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
          name: 'Lenovo ThinkPad X1',
          category: 'laptops',
          price: 529.99,
          imageUrl:
              'https://www.lenovo.com/medias/lenovo-laptop-thinkpad-x1-carbon-gen-10-14-intel-hero.png?context=bWFzdGVyfHJvb3R8MzE1NDI0fGltYWdlL3BuZ3xoOGQvaGI5LzEzMjU1MTI1NTkwMDQ2LnBuZ3wzZjU1YzNmYmMzZjk3MDRjYjZhZTJiYzQ4MjZkMTYwYTJkZjc3ZTJkNGU3ODZkZmU2ZDU1YzViZDU5ZTRiMTk4',
          images: [
            'https://www.lenovo.com/medias/lenovo-laptop-thinkpad-x1-carbon-gen-10-14-intel-hero.png?context=bWFzdGVyfHJvb3R8MzE1NDI0fGltYWdlL3BuZ3xoOGQvaGI5LzEzMjU1MTI1NTkwMDQ2LnBuZ3wzZjU1YzNmYmMzZjk3MDRjYjZhZTJiYzQ4MjZkMTYwYTJkZjc3ZTJkNGU3ODZkZmU2ZDU1YzViZDU5ZTRiMTk4',
            'https://www.lenovo.com/medias/ThinkPad-X1-Carbon-Gen-10-Intel-14-inch-NonTouch.png?context=bWFzdGVyfHJvb3R8MjIyMTU5fGltYWdlL3BuZ3xoNjcvaDY1LzEzMjU1MTI1NTIzNTEwLnBuZ3xiNjk0NmZhODJiMjY2ZTAwZjQ3ZTBlNjVkYTJhODk4ZDNmMzQ5YzFiYjg5ZmZkZGYyZjc1ZWM1YTU4MmIyZDFj',
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
          id: '4',
          name: 'Logitech MX Keys',
          category: 'accessories',
          price: 39.99,
          oldPrice: 44.99,
          imageUrl:
              'https://resource.logitech.com/content/dam/logitech/en/products/keyboards/mx-keys/gallery/mx-keys-gallery-hero.png',
          images: [
            'https://resource.logitech.com/content/dam/logitech/en/products/keyboards/mx-keys/gallery/mx-keys-gallery-hero.png',
            'https://resource.logitech.com/content/dam/logitech/en/products/keyboards/mx-keys/gallery/mx-keys-gallery-top.png',
          ],
          description:
              'Logitech MX Keys advanced keyboard with backlight, quiet keys, and ergonomic design.',
          descriptionAr:
              'لوحة مفاتيح لوجيتك MX Keys المتطورة مع إضاءة خلفية وتصميم مريح.',
          specifications: {
            'connectivity': 'Bluetooth, USB Receiver',
            'battery': 'Up to 10 days with backlight, 5 months without',
            'compatibility': 'Windows, macOS, Linux',
            'features': 'Backlit keys, Multi-device connectivity',
            'dimensions': '131.63 x 430.2 x 20.5 mm',
            'weight': '810g',
          },
          specificationsAr: {
            'التواصل': 'Bluetooth, USB Receiver',
            'البطارية': 'Up to 10 days with backlight, 5 months without',
            'التوافق': 'Windows, macOS, Linux',
            'المميزات': 'Backlit keys, Multi-device connectivity',
            'الأبعاد': '131.63 x 430.2 x 20.5 mm',
            'الوزن': '810g',
          },
          rating: 4.6,
          reviewCount: 78,
          brand: 'Logitech',
          createdAt: DateTime.now().subtract(const Duration(days: 60)),
        ),

        Product(
          id: '5',
          name: 'MacBook Pro 16',
          category: 'laptops',
          price: 899.99,
          oldPrice: 949.99,
          imageUrl:
              'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/mbp16-spacegray-select-202301?wid=452&hei=420&fmt=jpeg&qlt=95&.v=1671304673202',
          images: [
            'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/mbp16-spacegray-select-202301?wid=452&hei=420&fmt=jpeg&qlt=95&.v=1671304673202',
            'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/mbp16-silver-select-202301?wid=452&hei=420&fmt=jpeg&qlt=95&.v=1671304673496',
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
          price: 679.99,
          oldPrice: 729.99,
          imageUrl:
              'https://asset.msi.com/resize/image/global/product/product_1683621840c9f644c4b2a725686136a6c6e62d5f4a.png62405b38c58fe0f07fcef2367d8a9ba1/1024.png',
          images: [
            'https://asset.msi.com/resize/image/global/product/product_1683621840c9f644c4b2a725686136a6c6e62d5f4a.png62405b38c58fe0f07fcef2367d8a9ba1/1024.png',
            'https://asset.msi.com/resize/image/global/product/product_168362184166143de5bd5c0978cdc43708e90d8a11.png62405b38c58fe0f07fcef2367d8a9ba1/1024.png',
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
          name: 'Logitech MX Master 3S',
          category: 'accessories',
          price: 34.99,
          imageUrl:
              'https://resource.logitech.com/content/dam/logitech/en/products/mice/mx-master-3s/gallery/mx-master-3s-mouse-top-view-graphite.png',
          images: [
            'https://resource.logitech.com/content/dam/logitech/en/products/mice/mx-master-3s/gallery/mx-master-3s-mouse-top-view-graphite.png',
            'https://resource.logitech.com/content/dam/logitech/en/products/mice/mx-master-3s/gallery/mx-master-3s-mouse-side-view-graphite.png',
          ],
          description:
              'Logitech MX Master 3S advanced mouse with precise tracking, quiet clicks, and ergonomic design.',
          descriptionAr:
              'ماوس لوجيتك MX Master 3S المتطور مع تتبع دقيق وأزرار هادئة وتصميم مريح.',
          specifications: {
            'connectivity': 'Bluetooth, USB Receiver',
            'battery': 'Up to 70 days on a full charge',
            'compatibility': 'Windows, macOS, Linux',
            'features': '8K DPI sensor, Quiet clicks, MagSpeed wheel',
            'dimensions': '124.9 x 84.3 x 51 mm',
            'weight': '141g',
          },
          specificationsAr: {
            'التواصل': 'Bluetooth, USB Receiver',
            'البطارية': 'Up to 70 days on a full charge',
            'التوافق': 'Windows, macOS, Linux',
            'المميزات': '8K DPI sensor, Quiet clicks, MagSpeed wheel',
            'الأبعاد': '124.9 x 84.3 x 51 mm',
            'الوزن': '141g',
          },
          rating: 4.8,
          reviewCount: 112,
          brand: 'Logitech',
          createdAt: DateTime.now().subtract(const Duration(days: 40)),
        ),

        Product(
          id: '8',
          name: 'ASUS ROG Zephyrus G14',
          category: 'gaming',
          price: 599.99,
          oldPrice: 649.99,
          imageUrl:
              'https://dlcdnwebimgs.asus.com/gain/d1d14a18-53f8-4515-9d37-b7d7825a4409/',
          images: [
            'https://dlcdnwebimgs.asus.com/gain/d1d14a18-53f8-4515-9d37-b7d7825a4409/',
            'https://dlcdnwebimgs.asus.com/gain/708a7e32-135f-481b-b31c-beb52243264e/',
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
          id: '9',
          name: 'Sony WH-1000XM5',
          category: 'accessories',
          price: 149.99,
          oldPrice: 169.99,
          imageUrl:
              'https://www.sony.com/image/5d02da5df552836db894cead8a68f5f3?fmt=png-alpha&wid=660&hei=660',
          images: [
            'https://www.sony.com/image/5d02da5df552836db894cead8a68f5f3?fmt=png-alpha&wid=660&hei=660',
            'https://www.sony.com/image/fcb1bcd5a0b5ef221622ce7d4170750b?fmt=png-alpha&wid=660&hei=660',
          ],
          description:
              'Sony WH-1000XM5 wireless headphones with advanced noise cancellation and exceptional sound quality.',
          descriptionAr:
              'سماعات Sony WH-1000XM5 اللاسلكية مع خاصية إلغاء الضوضاء المتطورة وجودة صوت استثنائية.',
          specifications: {
            'connectivity': 'Bluetooth 5.2, 3.5mm audio cable',
            'battery': 'Up to 30 hours with NC on',
            'features': 'Industry-leading noise cancellation, LDAC support',
            'microphone': '8 microphones with AI noise reduction',
            'weight': '250g',
          },
          specificationsAr: {
            'التواصل': 'Bluetooth 5.2, 3.5mm audio cable',
            'البطارية': 'Up to 30 hours with NC on',
            'المميزات': 'Industry-leading noise cancellation, LDAC support',
            'الميكروفون': '8 microphones with AI noise reduction',
            'الوزن': '250g',
          },
          rating: 4.9,
          reviewCount: 178,
          brand: 'Sony',
          createdAt: DateTime.now().subtract(const Duration(days: 35)),
        ),

        Product(
          id: '10',
          name: 'Razer Blade 15',
          category: 'gaming',
          price: 749.99,
          imageUrl:
              'https://assets3.razerzone.com/CJR1aYjrWYT8RJ6WEQ2J7TZuZXg=/1500x1000/https%3A%2F%2Fhybrismediaprod.blob.core.windows.net%2Fsys-master-phoenix-images-container%2Fh78%2Fh24%2F9417810149406%2Fblade15-p1-500x500.png',
          images: [
            'https://assets3.razerzone.com/CJR1aYjrWYT8RJ6WEQ2J7TZuZXg=/1500x1000/https%3A%2F%2Fhybrismediaprod.blob.core.windows.net%2Fsys-master-phoenix-images-container%2Fh78%2Fh24%2F9417810149406%2Fblade15-p1-500x500.png',
            'https://assets3.razerzone.com/X-_cxgLUT-_fEprc8AErZ8kz-uY=/1500x1000/https%3A%2F%2Fhybrismediaprod.blob.core.windows.net%2Fsys-master-phoenix-images-container%2Fh9c%2Fh57%2F9417810116638%2Fblade15-p2-500x500.png',
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
          name: 'Samsung Odyssey G9',
          category: 'accessories',
          price: 429.99,
          oldPrice: 479.99,
          imageUrl:
              'https://image-us.samsung.com/us/monitors/odyssey-g95sc/G95SC-1.jpg',
          images: [
            'https://image-us.samsung.com/us/monitors/odyssey-g95sc/G95SC-1.jpg',
            'https://image-us.samsung.com/us/monitors/odyssey-g95sc/G95SC-2.jpg',
          ],
          description:
              'Samsung Odyssey G9 curved gaming monitor with 49-inch screen and 240Hz refresh rate.',
          descriptionAr:
              'شاشة Samsung Odyssey G9 المنحنية العملاقة بحجم 49 بوصة ومعدل تحديث 240 هرتز.',
          specifications: {
            'size': '49" Super Ultra-Wide',
            'resolution': '5120 x 1440 (DQHD)',
            'refresh_rate': '240Hz',
            'response_time': '1ms GTG',
            'panel_type': 'VA, Quantum Mini-LED',
            'hdr': 'HDR2000',
            'connectivity': 'DisplayPort 1.4, HDMI 2.1, USB Hub',
          },
          specificationsAr: {
            'الحجم': '49" Super Ultra-Wide',
            'الدقة': '5120 x 1440 (DQHD)',
            'معدل التحديث': '240Hz',
            'زمن الاستجابة': '1ms GTG',
            'نوع اللوحة': 'VA, Quantum Mini-LED',
            'HDR': 'HDR2000',
            'التواصل': 'DisplayPort 1.4, HDMI 2.1, USB Hub',
          },
          rating: 4.8,
          reviewCount: 67,
          brand: 'Samsung',
          createdAt: DateTime.now().subtract(const Duration(days: 22)),
        ),

        Product(
          id: '12',
          name: 'Alienware x17 R2',
          category: 'gaming',
          price: 899.99,
          oldPrice: 949.99,
          imageUrl:
              'https://i.dell.com/is/image/DellContent/content/dam/ss2/product-images/dell-client-products/notebooks/alienware-notebooks/alienware-x17-r2/media-gallery/notebook-alienware-x17-r2-silver-gallery-1.psd?fmt=png-alpha&pscan=auto&scl=1&hei=402&wid=402&qlt=100,1&resMode=sharp2&size=402,402',
          images: [
            'https://i.dell.com/is/image/DellContent/content/dam/ss2/product-images/dell-client-products/notebooks/alienware-notebooks/alienware-x17-r2/media-gallery/notebook-alienware-x17-r2-silver-gallery-1.psd?fmt=png-alpha&pscan=auto&scl=1&hei=402&wid=402&qlt=100,1&resMode=sharp2&size=402,402',
            'https://i.dell.com/is/image/DellContent/content/dam/ss2/product-images/dell-client-products/notebooks/alienware-notebooks/alienware-x17-r2/media-gallery/notebook-alienware-x17-r2-silver-gallery-2.psd?fmt=png-alpha&pscan=auto&scl=1&hei=402&wid=402&qlt=100,1&resMode=sharp2&size=402,402',
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
        Product(
          id: '13',
          name: 'AMD Ryzen 9 7950X',
          category: 'components',
          price: 299.99,
          oldPrice: 349.99,
          imageUrl:
              'https://www.amd.com/system/files/2022-08/1745310-amd-ryzen-7000-series-processors-front-angle-1260x709.png',
          images: [
            'https://www.amd.com/system/files/2022-08/1745310-amd-ryzen-7000-series-processors-front-angle-1260x709.png',
            'https://www.amd.com/system/files/2022-09/1593661-amd-ryzen-7000-series-PIB-1260x709.png',
          ],
          description:
              'AMD Ryzen 9 7950X processor with 16 cores, 32 threads, and exceptional gaming performance.',
          descriptionAr:
              'معالج AMD Ryzen 9 7950X مع 16 نواة و32 خيط ومعالجة وأداء استثنائي للألعاب.',
          specifications: {
            'cores': '16 cores, 32 threads',
            'base_clock': '4.5 GHz',
            'boost_clock': 'Up to 5.7 GHz',
            'cache': '80MB total cache',
            'tdp': '170W',
            'socket': 'AM5',
            'memory_support': 'DDR5',
            'pcie': 'PCIe 5.0',
          },
          specificationsAr: {
            'النوى': '16 نواة، 32 خيط',
            'التردد الأساسي': '4.5 جيجاهرتز',
            'التردد المعزز': 'حتى 5.7 جيجاهرتز',
            'الذاكرة المؤقتة': '80 ميجابايت',
            'استهلاك الطاقة': '170 واط',
            'المقبس': 'AM5',
            'دعم الذاكرة': 'DDR5',
            'PCIe': 'الإصدار 5.0',
          },
          rating: 4.9,
          reviewCount: 128,
          brand: 'AMD',
          createdAt: DateTime.now().subtract(const Duration(days: 14)),
        ),

        Product(
          id: '14',
          name: 'NVIDIA GeForce RTX 4090',
          category: 'components',
          price: 799.99,
          oldPrice: 849.99,
          imageUrl:
              'https://www.nvidia.com/content/dam/en-zz/Solutions/geforce/ada/rtx-4090/geforce-ada-4090-web-og-1200x630.jpg',
          images: [
            'https://www.nvidia.com/content/dam/en-zz/Solutions/geforce/ada/rtx-4090/geforce-ada-4090-web-og-1200x630.jpg',
            'https://www.nvidia.com/content/dam/en-zz/Solutions/geforce/ada/rtx-4090/geforce-rtx-4090-product-gallery-full-screen-3840-2.jpg',
          ],
          description:
              'NVIDIA GeForce RTX 4090 graphics card with ray tracing, DLSS 3, and extreme gaming performance.',
          descriptionAr:
              'كرت شاشة NVIDIA GeForce RTX 4090 مع تقنية تتبع الأشعة وDLSS 3 وأداء متطرف للألعاب.',
          specifications: {
            'cuda_cores': '16384',
            'memory': '24GB GDDR6X',
            'memory_speed': '21 Gbps',
            'boost_clock': '2.52 GHz',
            'ray_tracing_cores': '3rd Generation',
            'tensor_cores': '4th Generation',
            'power_consumption': '450W',
            'recommended_psu': '850W',
          },
          specificationsAr: {
            'نوى CUDA': '16384',
            'الذاكرة': '24GB GDDR6X',
            'سرعة الذاكرة': '21 جيجابت/ثانية',
            'التردد المعزز': '2.52 جيجاهرتز',
            'نوى تتبع الأشعة': 'الجيل الثالث',
            'نوى Tensor': 'الجيل الرابع',
            'استهلاك الطاقة': '450 واط',
            'مزود الطاقة الموصى به': '850 واط',
          },
          rating: 4.8,
          reviewCount: 95,
          brand: 'NVIDIA',
          createdAt: DateTime.now().subtract(const Duration(days: 21)),
        ),

        Product(
          id: '15',
          name: 'Samsung 990 PRO',
          category: 'components',
          price: 89.99,
          oldPrice: 99.99,
          imageUrl:
              'https://image-us.samsung.com/SamsungUS/home/computing/memory-and-storage/solid-state-drives/pdp/mz-v9p/gallery/MZ-V9P2T0B_001_Front_Black.jpg',
          images: [
            'https://image-us.samsung.com/SamsungUS/home/computing/memory-and-storage/solid-state-drives/pdp/mz-v9p/gallery/MZ-V9P2T0B_001_Front_Black.jpg',
            'https://image-us.samsung.com/SamsungUS/home/computing/memory-and-storage/solid-state-drives/pdp/mz-v9p/gallery/MZ-V9P2T0B_002_Back_Black.jpg',
          ],
          description:
              'Samsung 990 PRO NVMe SSD with PCIe 4.0, outstanding performance and reliability.',
          descriptionAr:
              'قرص تخزين Samsung 990 PRO NVMe SSD مع PCIe 4.0 وأداء وموثوقية متميزة.',
          specifications: {
            'capacity': '2TB',
            'interface': 'PCIe 4.0 x4',
            'form_factor': 'M.2 2280',
            'sequential_read': 'Up to 7,450 MB/s',
            'sequential_write': 'Up to 6,900 MB/s',
            'random_read': 'Up to 1,400K IOPS',
            'random_write': 'Up to 1,550K IOPS',
            'endurance': 'Up to 1200 TBW',
          },
          specificationsAr: {
            'السعة': '2 تيرابايت',
            'الواجهة': 'PCIe 4.0 x4',
            'الشكل': 'M.2 2280',
            'القراءة المتتابعة': 'حتى 7,450 ميجابايت/ثانية',
            'الكتابة المتتابعة': 'حتى 6,900 ميجابايت/ثانية',
            'القراءة العشوائية': 'حتى 1,400K IOPS',
            'الكتابة العشوائية': 'حتى 1,550K IOPS',
            'التحمل': 'حتى 1200 TBW',
          },
          rating: 4.7,
          reviewCount: 156,
          brand: 'Samsung',
          createdAt: DateTime.now().subtract(const Duration(days: 25)),
        ),

        Product(
          id: '16',
          name: 'ASUS ROG MAXIMUS Z790',
          category: 'components',
          price: 259.99,
          oldPrice: 289.99,
          imageUrl:
              'https://dlcdnwebimgs.asus.com/gain/37F5E647-9454-4C4F-9626-FE85143879F9/w1000/h732',
          images: [
            'https://dlcdnwebimgs.asus.com/gain/37F5E647-9454-4C4F-9626-FE85143879F9/w1000/h732',
            'https://dlcdnwebimgs.asus.com/gain/FB244C6C-9B8B-4C75-8D46-062F40265E8D/w1000/h732',
          ],
          description:
              'ASUS ROG MAXIMUS Z790 HERO motherboard with advanced features for extreme performance.',
          descriptionAr:
              'لوحة أم ASUS ROG MAXIMUS Z790 HERO مع ميزات متقدمة للأداء المتطرف.',
          specifications: {
            'socket': 'LGA 1700',
            'chipset': 'Intel Z790',
            'memory_support': 'DDR5 up to 7800MHz+',
            'pcie_slots': '2x PCIe 5.0 x16',
            'm2_slots': '5x M.2 slots',
            'usb_ports': 'USB 3.2 Gen 2x2 Type-C',
            'networking': '2.5Gb Ethernet, WiFi 6E',
            'audio': 'ROG SupremeFX 7.1',
          },
          specificationsAr: {
            'المقبس': 'LGA 1700',
            'الشريحة': 'Intel Z790',
            'دعم الذاكرة': 'DDR5 حتى 7800 ميجاهرتز+',
            'منافذ PCIe': '2x PCIe 5.0 x16',
            'منافذ M.2': '5 منافذ',
            'منافذ USB': 'USB 3.2 Gen 2x2 Type-C',
            'الشبكات': '2.5 جيجابت إيثرنت، WiFi 6E',
            'الصوت': 'ROG SupremeFX 7.1',
          },
          rating: 4.8,
          reviewCount: 89,
          brand: 'ASUS',
          createdAt: DateTime.now().subtract(const Duration(days: 32)),
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
