import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:pcland_store/core/app_localizations.dart';
import 'package:pcland_store/providers/product_provider.dart';
import 'package:pcland_store/providers/cart_provider.dart';
import 'package:pcland_store/providers/favorites_provider.dart';
import 'package:pcland_store/widgets/product_card.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final relatedProducts = productProvider.getProductsByCategory(widget.product.category)
        .where((p) => p.id != widget.product.id)
        .take(5)
        .toList();
    
    final isFavorite = favoritesProvider.isFavorite(widget.product.id);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              favoritesProvider.toggleFavorite(
                id: widget.product.id,
                name: widget.product.name,
                price: widget.product.price,
                imageUrl: widget.product.imageUrl,
                description: widget.product.description,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Carousel
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 300,
                          viewportFraction: 1.0,
                          enableInfiniteScroll: widget.product.images.length > 1,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentImageIndex = index;
                            });
                          },
                        ),
                        items: widget.product.images.map((imageUrl) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.contain,
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                      if (widget.product.images.length > 1)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: widget.product.images.asMap().entries.map((entry) {
                              return Container(
                                width: 8.0,
                                height: 8.0,
                                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).primaryColor.withOpacity(
                                      _currentImageIndex == entry.key ? 0.9 : 0.4),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),
                  
                  // Product Info
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.product.brand,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const Spacer(),
                            if (!widget.product.inStock)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  localizations.translate('out_of_stock'),
                                  style: TextStyle(color: Colors.red.shade800),
                                ),
                              ),
                            if (widget.product.inStock)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  localizations.translate('in_stock'),
                                  style: TextStyle(color: Colors.green.shade800),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.product.name,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            RatingBarIndicator(
                              rating: widget.product.rating,
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 20.0,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '(${widget.product.reviewCount})',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              '${widget.product.price.toStringAsFixed(2)} ${localizations.isArabic ? 'ريال' : 'SAR'}',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (widget.product.hasDiscount)
                              Text(
                                '${widget.product.oldPrice!.toStringAsFixed(2)} ${localizations.isArabic ? 'ريال' : 'SAR'}',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                ),
                              ),
                            if (widget.product.hasDiscount) const Spacer(),
                            if (widget.product.hasDiscount)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '-${widget.product.discountPercentage.toInt()}%',
                                  style: TextStyle(
                                    color: Colors.red.shade800,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Tabs
                        TabBar(
                          controller: _tabController,
                          tabs: [
                            Tab(text: localizations.translate('product_details')),
                            Tab(text: localizations.translate('specifications')),
                            Tab(text: localizations.translate('reviews')),
                          ],
                        ),
                        SizedBox(
                          height: 200,
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              // Product Details Tab
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                child: Text(localizations.isArabic ? widget.product.descriptionAr : widget.product.description),
                              ),
                              
                              // Specifications Tab
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: localizations.isArabic 
                                      ? widget.product.specificationsAr.length 
                                      : widget.product.specifications.length,
                                  itemBuilder: (context, index) {
                                    final entry = localizations.isArabic
                                        ? widget.product.specificationsAr.entries.elementAt(index)
                                        : widget.product.specifications.entries.elementAt(index);
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 120,
                                            child: Text(
                                              localizations.isArabic 
                                                  ? entry.key 
                                                  : localizations.translate(entry.key),
                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(entry.value.toString()),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              
                              // Reviews Tab
                              Center(
                                child: Text(
                                  '${widget.product.reviewCount} ${localizations.translate('reviews')}',
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Related Products
                        if (relatedProducts.isNotEmpty) ...[
                          Text(
                            localizations.translate('related_products'),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 250,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: relatedProducts.length,
                              itemBuilder: (context, index) {
                                return ProductCard(product: relatedProducts[index]);
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.product.inStock
                        ? () {
                            cartProvider.addItem(
                              productId: widget.product.id,
                              name: widget.product.name,
                              price: widget.product.price,
                              imageUrl: widget.product.imageUrl,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${widget.product.name} ${localizations.translate('add_to_cart')}',
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        : null,
                    child: Text(localizations.translate('add_to_cart')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
