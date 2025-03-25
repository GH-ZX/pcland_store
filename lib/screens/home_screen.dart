import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:pcland_store/core/app_localizations.dart';
import 'package:pcland_store/providers/product_provider.dart';
import 'package:pcland_store/widgets/product_card.dart';
import 'package:pcland_store/widgets/section_title.dart';
import 'package:pcland_store/widgets/category_card.dart';
import 'package:pcland_store/screens/product_list_screen.dart';
import 'package:pcland_store/screens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> bannerImages = [
    'https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/RE4OXzi?ver=3a58',
    'https://p3-ofp.static.pub/ShareResource/na/subseries/hero/lenovo-thinkpad-x1-carbon-with-badge-hero.png',
    'https://www.apple.com/v/macbook-pro-14-and-16/b/images/overview/hero/intro__ewz1ro7xs14y_large.jpg',
    'https://i.ytimg.com/vi/6vrIIfy7Mfg/maxresdefault.jpg',
    'https://www.amd.com/content/dam/amd/en/images/products/laptops/2201103-amd-advantage-laptop-rog-zephyrus-g14-video-thumbnail.png',
  ];

  final List<Map<String, dynamic>> bannerData = [
    {
      'image': 'https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/RE4OXzi?ver=3a58',
      'title': 'Surface Laptop',
      'subtitle': 'Elegant and powerful',
      'color': Colors.blue.shade700,
    },
    {
      'image': 'https://p3-ofp.static.pub/ShareResource/na/subseries/hero/lenovo-thinkpad-x1-carbon-with-badge-hero.png',
      'title': 'Lenovo ThinkPad X1',
      'subtitle': 'Best for business and productivity',
      'color': Colors.red.shade800,
    },
    {
      'image': 'https://www.apple.com/v/macbook-pro-14-and-16/b/images/overview/hero/intro__ewz1ro7xs14y_large.jpg',
      'title': 'MacBook Pro',
      'subtitle': 'Incredible performance',
      'color': Colors.grey.shade900,
    },
    {
      'image': 'https://i.ytimg.com/vi/6vrIIfy7Mfg/maxresdefault.jpg',
      'title': 'MSI Stealth Gaming',
      'subtitle': 'Professional gaming experience',
      'color': Colors.purple.shade800,
    },
    {
      'image': 'https://www.amd.com/content/dam/amd/en/images/products/laptops/2201103-amd-advantage-laptop-rog-zephyrus-g14-video-thumbnail.png',
      'title': 'ASUS ROG Zephyrus G14',
      'subtitle': 'Most powerful gaming devices',
      'color': Colors.red.shade600,
    },
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final newArrivals = productProvider.newArrivals;
    final bestSellers = productProvider.bestSellers;
    final specialOffers = productProvider.specialOffers;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('app_name')),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: productProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => productProvider.fetchProducts(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome Text
                      Text(
                        localizations.translate('welcome'),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 20),

                      // Banner Slider
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 180,
                          aspectRatio: 16 / 9,
                          viewportFraction: 1.0,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 3),
                          autoPlayAnimationDuration: const Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                        ),
                        items: bannerData.map((banner) {
                          return Builder(
                            builder: (BuildContext context) {
                              final isDarkMode = Theme.of(context).brightness == Brightness.dark;
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: NetworkImage(banner['image']),
                                    fit: BoxFit.cover,
                                    colorFilter: isDarkMode 
                                        ? ColorFilter.mode(
                                            Colors.black.withOpacity(0.2),
                                            BlendMode.darken,
                                          )
                                        : null,
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        banner['color'].withOpacity(isDarkMode ? 0.8 : 0.7),
                                        Colors.transparent,
                                      ],
                                    ),
                                    boxShadow: isDarkMode
                                        ? [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.3),
                                              spreadRadius: 1,
                                              blurRadius: 5,
                                              offset: const Offset(0, 3),
                                            )
                                          ]
                                        : null,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          banner['title'],
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            shadows: [
                                              Shadow(
                                                blurRadius: 3.0,
                                                color: Colors.black.withOpacity(0.5),
                                                offset: const Offset(1.0, 1.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          banner['subtitle'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            shadows: [
                                              Shadow(
                                                blurRadius: 2.0,
                                                color: Colors.black.withOpacity(0.5),
                                                offset: const Offset(1.0, 1.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),

                      // Categories
                      SectionTitle(
                        title: localizations.translate('categories'),
                        onSeeAll: () {},
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 100,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            CategoryCard(
                              title: localizations.translate('laptops'),
                              icon: Icons.laptop_mac,
                              color: Colors.blue,
                              imageUrl: 'https://i.dell.com/is/image/DellContent/content/dam/ss2/product-images/dell-client-products/notebooks/xps-notebooks/xps-15-9520/media-gallery/black/laptop-xps-15-9520-black-gallery-4',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductListScreen(
                                      title: localizations.translate('laptops'),
                                      category: 'laptops',
                                    ),
                                  ),
                                );
                              },
                            ),
                            CategoryCard(
                              title: localizations.translate('accessories'),
                              icon: Icons.keyboard,
                              color: Colors.green,
                              imageUrl: 'https://resource.logitech.com/content/dam/logitech/en/products/mice/mx-master-3s/gallery/mx-master-3s-mouse-top-view-graphite.png',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductListScreen(
                                      title: localizations.translate('accessories'),
                                      category: 'accessories',
                                    ),
                                  ),
                                );
                              },
                            ),
                            CategoryCard(
                              title: localizations.translate('gaming'),
                              icon: Icons.sports_esports,
                              color: Colors.red,
                              imageUrl: 'https://assets3.razerzone.com/3JrVMgmxRXSphShZmGNBvWW3Zfw=',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductListScreen(
                                      title: localizations.translate('gaming'),
                                      category: 'gaming',
                                    ),
                                  ),
                                );
                              },
                            ),
                            CategoryCard(
                              title: localizations.translate('monitors'),
                              icon: Icons.desktop_windows,
                              color: Colors.purple,
                              imageUrl: 'https://images.samsung.com/is/image/samsung/p6pim/levant/ls49cg954suxen/gallery/levant-odyssey-g9-g95c-ls49cg954suxen-536860492',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductListScreen(
                                      title: localizations.translate('monitors'),
                                      category: 'accessories',
                                    ),
                                  ),
                                );
                              },
                            ),
                            CategoryCard(
                              title: localizations.translate('audio'),
                              icon: Icons.headphones,
                              color: Colors.orange,
                              imageUrl: 'https://www.sony.com/image/5d02da5df552836db894cead8a68f5f3',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductListScreen(
                                      title: localizations.translate('audio'),
                                      category: 'accessories',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // New Arrivals
                      SectionTitle(
                        title: localizations.translate('new_arrivals'),
                        onSeeAll: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductListScreen(
                                title: localizations.translate('new_arrivals'),
                                products: newArrivals,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 250,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: newArrivals.length,
                          itemBuilder: (context, index) {
                            return ProductCard(product: newArrivals[index]);
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Best Sellers
                      SectionTitle(
                        title: localizations.translate('best_sellers'),
                        onSeeAll: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductListScreen(
                                title: localizations.translate('best_sellers'),
                                products: bestSellers,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 250,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: bestSellers.length,
                          itemBuilder: (context, index) {
                            return ProductCard(product: bestSellers[index]);
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Special Offers
                      SectionTitle(
                        title: localizations.translate('special_offers'),
                        onSeeAll: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductListScreen(
                                title: localizations.translate('special_offers'),
                                products: specialOffers,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 250,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: specialOffers.length,
                          itemBuilder: (context, index) {
                            return ProductCard(product: specialOffers[index]);
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
