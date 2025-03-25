import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pcland_store/core/app_localizations.dart';
import 'package:pcland_store/providers/favorites_provider.dart';
import 'package:pcland_store/providers/product_provider.dart';
import 'package:pcland_store/widgets/product_grid_item.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favoriteItems = favoritesProvider.items;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('favorites')),
        actions: [
          if (favoriteItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(localizations.translate('clear')),
                    content: Text(localizations.translate('clear_favorites')),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: Text(localizations.translate('cancel')),
                      ),
                      TextButton(
                        onPressed: () {
                          favoritesProvider.clearFavorites();
                          Navigator.of(ctx).pop();
                        },
                        child: Text(
                          localizations.translate('clear'),
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: favoriteItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    localizations.translate('empty_favorites'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(localizations.translate('continue_shopping')),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: favoriteItems.length,
              itemBuilder: (ctx, index) {
                // Convert FavoriteItem to Product
                final favoriteItem = favoriteItems[index];
                final product = Product(
                  id: favoriteItem.id,
                  name: favoriteItem.name,
                  description: favoriteItem.description ?? '',
                  descriptionAr: favoriteItem.description ?? '',
                  price: favoriteItem.price,
                  imageUrl: favoriteItem.imageUrl,
                  category: '',
                  brand: '',
                  images: [favoriteItem.imageUrl],
                  specifications: {},
                  specificationsAr: {},
                  createdAt: DateTime.now(),
                  rating: 0,
                  reviewCount: 0,
                  inStock: true,
                );
                
                return ProductGridItem(product: product);
              },
            ),
    );
  }
}
