import 'package:flutter/material.dart';
import 'package:pcland_store/screens/address_screen.dart';
import 'package:pcland_store/screens/orders_screen.dart';
import 'package:pcland_store/screens/inbox_screen.dart'; // Add this import
import 'package:provider/provider.dart';
import 'package:pcland_store/services/app_localizations.dart';
import 'package:pcland_store/providers/theme_provider.dart';
import 'package:pcland_store/providers/language_provider.dart';
import 'package:pcland_store/providers/user_provider.dart';
import 'package:pcland_store/screens/profile_screen.dart';
import 'package:pcland_store/screens/login_screen.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.translate('settings'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // User Profile Section
          if (userProvider.isLoggedIn)
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    radius: 25,
                    backgroundImage:
                        userProvider.user!.profileImage != null
                            ? NetworkImage(userProvider.user!.profileImage!)
                            : null,
                    child:
                        userProvider.user!.profileImage == null
                            ? Text(
                              userProvider.user!.name
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            )
                            : null,
                  ),
                  title: Text(
                    userProvider.user!.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(userProvider.user!.email),
                      const SizedBox(height: 2),
                      Text(userProvider.user!.phoneNumber),
                    ],
                  ),

                  isThreeLine: true,
                ),
              ),
            ),
          if (userProvider.isLoggedIn) const SizedBox(height: 16),

          // Account Settings Section
          if (userProvider.isLoggedIn)
            _buildSectionHeader(
              context,
              localizations.translate('account settings'),
            ),
          if (userProvider.isLoggedIn)
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: Text(localizations.translate('profile')),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  ),
                  const Divider(height: 1),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OrdersScreen(),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: const Icon(Icons.shopping_bag_outlined),
                      title: Text(localizations.translate('my_orders')),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  ),
                  const Divider(height: 1),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddressScreen(),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: const Icon(Icons.location_on_outlined),
                      title: Text(localizations.translate('addresses')),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  ),
                  const Divider(height: 1),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InboxScreen(),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: const Icon(Icons.notifications_outlined),
                      title: Text(localizations.translate('inbox')),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  ),
                ],
              ),
            ),
          if (userProvider.isLoggedIn) const SizedBox(height: 16),

          // App Settings Section
          _buildSectionHeader(context, localizations.translate('app_settings')),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // Theme Settings
                InkWell(
                  onTap: () {
                    _showThemeSelectionDialog(
                      context,
                      themeProvider,
                      localizations,
                    );
                  },
                  child: ListTile(
                    leading: Icon(
                      isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    ),
                    title: Text(localizations.translate('theme')),
                    trailing: Text(
                      localizations.translate(
                        themeProvider.themeMode == ThemeMode.system
                            ? 'system'
                            : themeProvider.themeMode == ThemeMode.light
                            ? 'light'
                            : 'dark',
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1),
                // Language Settings
                InkWell(
                  onTap: () {
                    _showLanguageSelectionDialog(
                      context,
                      languageProvider,
                      localizations,
                    );
                  },
                  child: ListTile(
                    leading: const Icon(Icons.language),
                    title: Text(localizations.translate('language')),
                    trailing: Text(
                      localizations.translate(languageProvider.currentLanguage),
                    ),
                  ),
                ),
                const Divider(height: 1),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Support & About Section
          _buildSectionHeader(
            context,
            localizations.translate('support and about'),
          ),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // About
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder:
                          (ctx) => AlertDialog(
                            title: Text(localizations.translate('about')),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.computer,
                                    size: 30,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'PCLand Store',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 4),
                                Text('Version 1.0.0'),
                                const SizedBox(height: 16),
                                Text(
                                  localizations.translate('about_description'),
                                ),
                                const SizedBox(height: 16),
                                const Divider(),
                                const SizedBox(height: 16),
                                Text(
                                  localizations.translate('special thanks'),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  localizations.translate(
                                    'special thanks decription',
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(),
                                child: Text(localizations.translate('close')),
                              ),
                            ],
                          ),
                    );
                  },
                  child: ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: Text(localizations.translate('about')),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                ),
                const Divider(height: 1),
                // Contact Us
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder:
                          (ctx) => AlertDialog(
                            title: Text(localizations.translate('contact us')),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.phone),
                                  title: Text(
                                    localizations.translate('Ahmed Ghawi'),
                                  ),
                                  subtitle: const Text('+352681142074'),
                                  onTap: () async {
                                    Navigator.pop(ctx);
                                    final phoneNumber = '+352681142074';
                                    final url = 'tel:$phoneNumber';
                                    if (!await url_launcher.launchUrl(
                                      Uri.parse(url),
                                    )) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Could not launch phone dialer',
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.phone),
                                  title: Text(
                                    localizations.translate(
                                      'Abd-AlGhani Al-Omar',
                                    ),
                                  ),
                                  subtitle: const Text('+97693553256'),
                                  onTap: () async {
                                    Navigator.pop(ctx);
                                    final phoneNumber = '+97693553256';
                                    final url = 'tel:$phoneNumber';
                                    if (!await url_launcher.launchUrl(
                                      Uri.parse(url),
                                    )) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Could not launch phone dialer',
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: Text(localizations.translate('close')),
                              ),
                            ],
                          ),
                    );
                  },
                  child: ListTile(
                    leading: const Icon(Icons.contact_support_outlined),
                    title: Text(localizations.translate('contact us')),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Login/Logout Section
          Card(
            elevation: 2,
            color:
                userProvider.isLoggedIn
                    ? Colors.red.withOpacity(0.1)
                    : Theme.of(context).colorScheme.primary.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () {
                if (userProvider.isLoggedIn) {
                  showDialog(
                    context: context,
                    builder:
                        (ctx) => AlertDialog(
                          title: Text(localizations.translate('logout')),
                          content: Text(
                            localizations.translate('logout_confirm'),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: Text(localizations.translate('cancel')),
                            ),
                            TextButton(
                              onPressed: () {
                                userProvider.logout();
                                Navigator.of(ctx).pop();
                                // Navigate to login screen
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                  (route) => false,
                                );
                              },
                              child: Text(
                                localizations.translate('logout'),
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                }
              },
              child:
                  userProvider.isLoggedIn
                      ? ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: Text(
                          localizations.translate('logout'),
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                      : ListTile(
                        leading: Icon(
                          Icons.login,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        title: Text(
                          localizations.translate('login'),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
            ),
          ),
          const SizedBox(height: 32),

          Center(
            child: Text(
              '${localizations.translate('made')} ${localizations.translate('by')} ',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  void _showThemeSelectionDialog(
    BuildContext context,
    ThemeProvider themeProvider,
    AppLocalizations localizations,
  ) {
    showDialog(
      context: context,
      builder:
          (ctx) => SimpleDialog(
            title: Text(localizations.translate('select theme')),
            children: [
              RadioListTile<ThemeMode>(
                title: Text(localizations.translate('system')),
                value: ThemeMode.system,
                groupValue: themeProvider.themeMode,
                onChanged: (ThemeMode? value) {
                  if (value != null) {
                    themeProvider.setThemeMode(value);
                    Navigator.of(ctx).pop();
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                title: Text(localizations.translate('light')),
                value: ThemeMode.light,
                groupValue: themeProvider.themeMode,
                onChanged: (ThemeMode? value) {
                  if (value != null) {
                    themeProvider.setThemeMode(value);
                    Navigator.of(ctx).pop();
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                title: Text(localizations.translate('dark')),
                value: ThemeMode.dark,
                groupValue: themeProvider.themeMode,
                onChanged: (ThemeMode? value) {
                  if (value != null) {
                    themeProvider.setThemeMode(value);
                    Navigator.of(ctx).pop();
                  }
                },
              ),
            ],
          ),
    );
  }

  void _showLanguageSelectionDialog(
    BuildContext context,
    LanguageProvider languageProvider,
    AppLocalizations localizations,
  ) {
    showDialog(
      context: context,
      builder:
          (ctx) => SimpleDialog(
            title: Text(localizations.translate('select language')),
            children: [
              RadioListTile<String>(
                title: Text(localizations.translate('en')),
                value: 'en',
                groupValue: languageProvider.currentLanguage,
                onChanged: (String? value) {
                  if (value != null) {
                    languageProvider.setLanguage(value);
                    Navigator.of(ctx).pop();
                  }
                },
              ),
              RadioListTile<String>(
                title: Text(localizations.translate('ar')),
                value: 'ar',
                groupValue: languageProvider.currentLanguage,
                onChanged: (String? value) {
                  if (value != null) {
                    languageProvider.setLanguage(value);
                    Navigator.of(ctx).pop();
                  }
                },
              ),
            ],
          ),
    );
  }
}
