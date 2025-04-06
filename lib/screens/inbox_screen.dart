import 'package:flutter/material.dart';
import 'package:pcland_store/screens/product_detail_screen.dart';
import 'package:pcland_store/services/app_localizations.dart';
import 'package:pcland_store/providers/product_provider.dart';
import 'package:provider/provider.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final productProvider = Provider.of<ProductProvider>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(localizations.translate('inbox')),
          bottom: TabBar(
            tabs: [
              Tab(text: localizations.translate('updates')),
              Tab(text: localizations.translate('promotions')),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildUpdatesList(context),
            _buildPromotionsList(context, productProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdatesList(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(
                index == 0
                    ? Icons.local_shipping
                    : index == 1
                    ? Icons.inventory_2
                    : Icons.done_all,
                color: Colors.white,
              ),
            ),
            title: Text(
              localizations
                  .translate('order_number_updated')
                  .replaceAll('{number}', '${1000 + index}'),
            ),
            subtitle: Text(
              localizations.translate(
                index == 0
                    ? 'order_shipped'
                    : index == 1
                    ? 'order_processing'
                    : 'order_delivered',
              ),
            ),
            trailing: Text(
              localizations
                  .translate('hours_ago')
                  .replaceAll('{hours}', '${index + 1}'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPromotionsList(
    BuildContext context,
    ProductProvider productProvider,
  ) {
    final localizations = AppLocalizations.of(context);
    final specialOffers = productProvider.specialOffers.take(3).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: specialOffers.length,
      itemBuilder: (context, index) {
        final product = specialOffers[index];
        return Card(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(product: product),
                ),
              );
            },
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.asset(
                      productProvider.getImagePath(product.imageUrl),
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    if (product.hasDiscount)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${product.discountPercentage.round()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        Localizations.localeOf(context).languageCode == 'ar'
                            ? product.descriptionAr
                            : product.description,
                        style: Theme.of(context).textTheme.bodyLarge,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (product.oldPrice != null)
                            Text(
                              '${product.oldPrice?.toStringAsFixed(2)} ${localizations.translate('currency')}',
                              style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                              ),
                            ),
                          const SizedBox(width: 8),
                          Text(
                            '${product.price.toStringAsFixed(2)} ${localizations.translate('currency')}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
