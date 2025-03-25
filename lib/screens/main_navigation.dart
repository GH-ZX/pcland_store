import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:pcland_store/core/app_localizations.dart';
import 'package:pcland_store/providers/cart_provider.dart';
import 'package:pcland_store/screens/home_screen.dart';
import 'package:pcland_store/screens/search_screen.dart';
import 'package:pcland_store/screens/cart_screen.dart';
import 'package:pcland_store/screens/favorites_screen.dart';
import 'package:pcland_store/screens/settings_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const CartScreen(),
    const FavoritesScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final cartProvider = Provider.of<CartProvider>(context);
    
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: localizations.translate('home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: localizations.translate('search'),
          ),
          BottomNavigationBarItem(
            icon: badges.Badge(
              showBadge: cartProvider.itemCount > 0,
              badgeContent: Text(
                '${cartProvider.itemCount}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
              child: const Icon(Icons.shopping_cart),
            ),
            label: localizations.translate('cart'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            label: localizations.translate('favorites'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: localizations.translate('settings'),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
