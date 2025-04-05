import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:pcland_store/services/app_localizations.dart';
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
      'image':
          'https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/RE4OXzi?ver=3a58',
      'title': 'Surface Laptop',
      'subtitle': 'Elegant and powerful',
      'color': Colors.blue.shade700,
      'shadow': Colors.black.withOpacity(0.3),
    },
    {
      'image':
          'https://p3-ofp.static.pub/ShareResource/na/subseries/hero/lenovo-thinkpad-x1-carbon-with-badge-hero.png',
      'title': 'Lenovo ThinkPad X1',
      'subtitle': 'Best for business and productivity',
      'color': Colors.red.shade800,
    },
    {
      'image':
          'https://www.apple.com/v/macbook-pro-14-and-16/b/images/overview/hero/intro__ewz1ro7xs14y_large.jpg',
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
      'image':
          'https://www.amd.com/content/dam/amd/en/images/products/laptops/2201103-amd-advantage-laptop-rog-zephyrus-g14-video-thumbnail.png',
      'title': 'ASUS ROG Zephyrus G14',
      'subtitle': 'Most powerful gaming devices',
      'color': const Color.fromARGB(255, 105, 18, 199),
    },
    {
      'image':
          'https://i.pcmag.com/imagery/reviews/01FIvTZt1sIxZydOira9RYm-5..v1680798175.jpg',
      'title': 'MSI Katana GF66',
      'subtitle': 'Best for business and productivity',
      'color': Colors.red.shade800,
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
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      body:
          productProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: () => productProvider.fetchProducts(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Welcome Text
                        Text(
                          localizations.translate('Soon'),
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 20),

                        // Banner Slider
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 210,
                            aspectRatio: 16 / 9,
                            viewportFraction: 1.0,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 3),
                            autoPlayAnimationDuration: const Duration(
                              milliseconds: 800,
                            ),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                          ),
                          items:
                              bannerData.map((banner) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    final isDarkMode =
                                        Theme.of(context).brightness ==
                                        Brightness.dark;
                                    return Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 5.0,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(
                                          image: NetworkImage(banner['image']),
                                          fit: BoxFit.cover,
                                          colorFilter:
                                              isDarkMode
                                                  ? ColorFilter.mode(
                                                    Colors.black.withOpacity(
                                                      0.2,
                                                    ),
                                                    BlendMode.darken,
                                                  )
                                                  : null,
                                        ),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              banner['color'].withOpacity(
                                                isDarkMode ? 0.8 : 0.7,
                                              ),
                                              Colors.transparent,
                                            ],
                                          ),
                                          boxShadow:
                                              isDarkMode
                                                  ? [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.3),
                                                      spreadRadius: 1,
                                                      blurRadius: 5,
                                                      offset: const Offset(
                                                        0,
                                                        3,
                                                      ),
                                                    ),
                                                  ]
                                                  : null,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                      color: Colors.black
                                                          .withOpacity(0.5),
                                                      offset: const Offset(
                                                        1.0,
                                                        1.0,
                                                      ),
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
                                                      color: Colors.black
                                                          .withOpacity(0.5),
                                                      offset: const Offset(
                                                        1.0,
                                                        1.0,
                                                      ),
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
                        Text(
                          localizations.translate('categories'),
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 110,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              CategoryCard(
                                title: 'All Brands',
                                icon: Icons.laptop_mac,
                                color:
                                    Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.grey.shade600
                                        : Colors.black87,

                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => const ProductListScreen(
                                            title: 'All Brands',
                                            category: 'Laptop',
                                          ),
                                    ),
                                  );
                                },
                              ),
                              CategoryCard(
                                title: 'Dell',
                                icon: Icons.laptop_mac,
                                color:
                                    Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.blue.shade800
                                        : Colors.blue.shade300,
                                imageUrl:
                                    'https://upload.wikimedia.org/wikipedia/commons/thumb/4/48/Dell_Logo.svg/300px-Dell_Logo.svg.png',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => ProductListScreen(
                                            title: 'Dell',
                                            brand: 'Dell',
                                          ),
                                    ),
                                  );
                                },
                              ),
                              CategoryCard(
                                title: 'ASUS',
                                icon: Icons.laptop,
                                color:
                                    Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.deepPurple.shade600
                                        : Colors.deepPurple.shade300,
                                imageUrl:
                                    'https://cdn.freebiesupply.com/logos/large/2x/asus-6630-logo-png-transparent.png',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => ProductListScreen(
                                            title: 'ASUS',
                                            brand: 'ASUS',
                                          ),
                                    ),
                                  );
                                },
                              ),
                              CategoryCard(
                                title: 'MSI',
                                icon: Icons.laptop,
                                color:
                                    Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.red.shade900
                                        : Colors.red.shade300,
                                imageUrl:
                                    'https://static.cdnlogo.com/logos/m/21/msi.png',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => ProductListScreen(
                                            title: 'MSI',
                                            brand: 'MSI',
                                          ),
                                    ),
                                  );
                                },
                              ),
                              CategoryCard(
                                title: 'Apple',
                                icon: Icons.laptop_mac,
                                color:
                                    Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.grey.shade600
                                        : Colors.grey.shade300,
                                imageUrl:
                                    'https://cdn.freebiesupply.com/images/large/2x/apple-logo-transparent.png',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => ProductListScreen(
                                            title: 'Apple',
                                            brand: 'Apple',
                                          ),
                                    ),
                                  );
                                },
                              ),
                              CategoryCard(
                                title: 'Microsoft',
                                icon: Icons.laptop,
                                color:
                                    Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.orange.shade900
                                        : Colors.orange.shade100,
                                imageUrl:
                                    'https://pngimg.com/uploads/microsoft/microsoft_PNG5.png',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => ProductListScreen(
                                            title: 'Microsoft',
                                            brand: 'Microsoft',
                                          ),
                                    ),
                                  );
                                },
                              ),
                              CategoryCard(
                                title: 'Alienware',
                                icon: Icons.laptop,
                                color:
                                    Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.grey.shade800
                                        : Colors.grey.shade400,
                                imageUrl:
                                    'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7c/Alienware_logo.svg/1200px-Alienware_logo.svg.png',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => ProductListScreen(
                                            title: 'Alienware',
                                            brand: 'Alienware',
                                          ),
                                    ),
                                  );
                                },
                              ),
                              CategoryCard(
                                title: 'Acer',
                                icon: Icons.laptop,
                                color:
                                    Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.green.shade700
                                        : Colors.green.shade300,
                                imageUrl:
                                    'https://www.acer.com/content/dam/acer/global-asset-library/logos/acer-share-logo.png',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => ProductListScreen(
                                            title: 'Acer',
                                            brand: 'Acer',
                                          ),
                                    ),
                                  );
                                },
                              ),
                              CategoryCard(
                                title: 'Lenovo',
                                icon: Icons.laptop,
                                color:
                                    Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.red.shade700
                                        : Colors.red.shade300,
                                imageUrl:
                                    'https://www.lenovo.com/medias/lenovo-logo-footer.png?context=bWFzdGVyfHJvb3R8NDA0MXxpbWFnZS9wbmd8aDY5L2g2NS85NDQ5NTM2MDk0MjM4LnBuZ3w0YjUxMWQ5ZTc1MDJkYTQ3ODI0YmZhZTJkMjYyMzJiYjY5ZGYxM2ZhNTU5ZTRiYmM0ZjE3NzJjNGQ5ZTRjYzU1',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => ProductListScreen(
                                            title: 'Lenovo',
                                            brand: 'Lenovo',
                                          ),
                                    ),
                                  );
                                },
                              ),
                              CategoryCard(
                                title: 'Samsung',
                                icon: Icons.laptop,
                                color:
                                    Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.blue.shade700
                                        : Colors.blue.shade300,
                                imageUrl:
                                    'https://cdn.freebiesupply.com/logos/large/2x/samsung-1-logo-png-transparent.png',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => ProductListScreen(
                                            title: 'Samsung',
                                            brand: 'Samsung',
                                          ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),

                        // New Arrivals
                        SectionTitle(
                          title: localizations.translate('new_arrivals'),
                          onSeeAll: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ProductListScreen(
                                      title: localizations.translate(
                                        'new_arrivals',
                                      ),
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
                                builder:
                                    (context) => ProductListScreen(
                                      title: localizations.translate(
                                        'best_sellers',
                                      ),
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
                                builder:
                                    (context) => ProductListScreen(
                                      title: localizations.translate(
                                        'special_offers',
                                      ),
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
