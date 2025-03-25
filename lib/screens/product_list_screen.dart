import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pcland_store/core/app_localizations.dart';
import 'package:pcland_store/providers/product_provider.dart';
import 'package:pcland_store/widgets/product_grid_item.dart';

class ProductListScreen extends StatefulWidget {
  final String title;
  final String? category;
  final List<Product>? products;

  const ProductListScreen({
    super.key,
    required this.title,
    this.category,
    this.products,
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late List<Product> _displayedProducts;
  String _sortBy = 'newest';

  @override
  void initState() {
    super.initState();
    _initProducts();
  }

  void _initProducts() {
    if (widget.products != null) {
      _displayedProducts = [...widget.products!];
    } else if (widget.category != null) {
      _displayedProducts = Provider.of<ProductProvider>(context, listen: false)
          .getProductsByCategory(widget.category!);
    } else {
      _displayedProducts = Provider.of<ProductProvider>(context, listen: false).items;
    }
    _sortProducts();
  }

  void _sortProducts() {
    switch (_sortBy) {
      case 'newest':
        _displayedProducts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'price_low_to_high':
        _displayedProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high_to_low':
        _displayedProducts.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'popularity':
        _displayedProducts.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
        break;
      case 'rating':
        _displayedProducts.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }
  }

  void _showSortOptions() {
    final localizations = AppLocalizations.of(context);
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                localizations.translate('sort_by'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(localizations.translate('newest_first')),
                leading: Radio<String>(
                  value: 'newest',
                  groupValue: _sortBy,
                  onChanged: (value) {
                    setState(() {
                      _sortBy = value!;
                      _sortProducts();
                      Navigator.pop(context);
                    });
                  },
                ),
              ),
              ListTile(
                title: Text(localizations.translate('price_low_to_high')),
                leading: Radio<String>(
                  value: 'price_low_to_high',
                  groupValue: _sortBy,
                  onChanged: (value) {
                    setState(() {
                      _sortBy = value!;
                      _sortProducts();
                      Navigator.pop(context);
                    });
                  },
                ),
              ),
              ListTile(
                title: Text(localizations.translate('price_high_to_low')),
                leading: Radio<String>(
                  value: 'price_high_to_low',
                  groupValue: _sortBy,
                  onChanged: (value) {
                    setState(() {
                      _sortBy = value!;
                      _sortProducts();
                      Navigator.pop(context);
                    });
                  },
                ),
              ),
              ListTile(
                title: Text(localizations.translate('popularity')),
                leading: Radio<String>(
                  value: 'popularity',
                  groupValue: _sortBy,
                  onChanged: (value) {
                    setState(() {
                      _sortBy = value!;
                      _sortProducts();
                      Navigator.pop(context);
                    });
                  },
                ),
              ),
              ListTile(
                title: Text(localizations.translate('rating')),
                leading: Radio<String>(
                  value: 'rating',
                  groupValue: _sortBy,
                  onChanged: (value) {
                    setState(() {
                      _sortBy = value!;
                      _sortProducts();
                      Navigator.pop(context);
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortOptions,
          ),
        ],
      ),
      body: _displayedProducts.isEmpty
          ? Center(
              child: Text(localizations.translate('no_results')),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _displayedProducts.length,
              itemBuilder: (ctx, index) {
                return ProductGridItem(product: _displayedProducts[index]);
              },
            ),
    );
  }
}
