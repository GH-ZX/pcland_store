import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pcland_store/providers/product_provider.dart';
import 'package:pcland_store/widgets/product_grid_item.dart';

class ProductListScreen extends StatelessWidget {
  final String title;
  final String? category;
  final String? brand; 
  final List<Product>? products;

  const ProductListScreen({
    super.key,
    required this.title,
    this.category,
    this.brand,
    this.products,
  });

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    List<Product> displayProducts =
        products ??
        (brand != null
            ? productProvider.getProductsByBrand(brand!)
            : category != null
            ? productProvider.getProductsByCategory(category!)
            : []);

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: displayProducts.length,
        itemBuilder: (context, index) {
          return ProductGridItem(product: displayProducts[index]);
        },
      ),
    );
  }
}
