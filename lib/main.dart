import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Localizations
import 'package:pcland_store/services/app_localizations.dart';
import 'package:pcland_store/services/app_theme.dart';
import 'package:provider/provider.dart'; // Providers }>
import 'package:pcland_store/providers/theme_provider.dart';
import 'package:pcland_store/providers/language_provider.dart';
import 'package:pcland_store/providers/user_provider.dart';
import 'package:pcland_store/providers/cart_provider.dart';
import 'package:pcland_store/providers/favorites_provider.dart';
import 'package:pcland_store/providers/product_provider.dart'; //        <
import 'package:pcland_store/screens/main_navigation.dart';
import 'package:pcland_store/screens/login_screen.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();

  final themeProvider = ThemeProvider();
  final languageProvider = LanguageProvider();
  final userProvider = UserProvider();

  await themeProvider.loadThemeMode();
  await languageProvider.loadLanguage();
  await userProvider.tryAutoLogin();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: languageProvider),
        ChangeNotifierProvider.value(value: userProvider),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PCLand Store',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      locale: Locale(languageProvider.currentLanguage),
      supportedLocales: const [Locale('en', ''), Locale('ar', '')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routes: {
        '/':
            (context) =>
                userProvider.isLoggedIn
                    ? const MainNavigation()
                    : const LoginScreen(),
        '/home': (context) => const MainNavigation(),
        '/login': (context) => const LoginScreen(),
      },
      initialRoute: '/',
    );
  }
}
