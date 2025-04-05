import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pcland_store/services/app_localizations.dart';
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
                  builder:
                      (ctx) => AlertDialog(
                        title: Text(localizations.translate('clear')),
                        content: Text(
                          localizations.translate('clear_favorites_approval'),
                        ),
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
      body:
          favoriteItems.isEmpty
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
                    Text(
                      localizations.translate('empty_favorites_message'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              )
              : LayoutBuilder(
                builder: (context, constraints) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(14),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.67,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemCount: favoriteItems.length,
                    itemBuilder: (ctx, index) {
                      final favoriteItem = favoriteItems[index];
                      final productProvider = Provider.of<ProductProvider>(
                        context,
                        listen: false,
                      );
                      final product = productProvider.findById(favoriteItem.id);

                      return ProductGridItem(product: product);
                    },
                  );
                },
              ),
    );
  }
}
