import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pcland_store/core/app_localizations.dart';
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
      appBar: AppBar(
        title: Text(localizations.translate('settings')),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // Show help dialog
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(localizations.translate('help')),
                  content: Text(localizations.translate('help_description')),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text(localizations.translate('close')),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
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
                    backgroundImage: userProvider.user!.profileImage != null
                        ? NetworkImage(userProvider.user!.profileImage!)
                        : null,
                    child: userProvider.user!.profileImage == null
                        ? Text(
                            userProvider.user!.name.substring(0, 1).toUpperCase(),
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
                      fontSize: 16,
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
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                  ),
                  isThreeLine: true,
                ),
              ),
            ),
          if (userProvider.isLoggedIn) const SizedBox(height: 16),

          // Account Settings Section
          if (userProvider.isLoggedIn)
            _buildSectionHeader(context, localizations.translate('account settings')),
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
                      // Navigate to orders screen
                    },
                    child: ListTile(
                      leading: const Icon(Icons.shopping_bag_outlined),
                      title: Text(localizations.translate('my orders')),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  ),
                  const Divider(height: 1),
                  InkWell(
                    onTap: () {
                      // Navigate to addresses screen
                    },
                    child: ListTile(
                      leading: const Icon(Icons.location_on_outlined),
                      title: Text(localizations.translate('addresses')),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.notifications_outlined),
                    title: Text(localizations.translate('notifications')),
                    trailing: Switch(
                      value: true, // Get from provider
                      onChanged: (value) {
                        // Request notification permissions
                        if (value) {
                          _requestNotificationPermissions(context);
                        }
                        // Update notification settings
                      },
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),
                    onTap: () {
                      // Toggle notification switch when tapping the entire tile
                      // This would need a provider to manage the notification state
                    },
                  ),
                ],
              ),
            ),
          if (userProvider.isLoggedIn) const SizedBox(height: 16),

          // App Settings Section
          _buildSectionHeader(context, localizations.translate('app settings')),
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
                    // Show theme selection dialog
                    _showThemeSelectionDialog(context, themeProvider, localizations);
                  },
                  child: ListTile(
                    leading: Icon(
                      isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    ),
                    title: Text(localizations.translate('theme')),
                    trailing: DropdownButton<ThemeMode>(
                      value: themeProvider.themeMode,
                      underline: Container(),
                      onChanged: (ThemeMode? newThemeMode) {
                        if (newThemeMode != null) {
                          themeProvider.setThemeMode(newThemeMode);
                        }
                      },
                      items: [
                        DropdownMenuItem(
                          value: ThemeMode.system,
                          child: Text(localizations.translate('system')),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.light,
                          child: Text(localizations.translate('light')),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.dark,
                          child: Text(localizations.translate('dark')),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 1),
                // Language Settings
                InkWell(
                  onTap: () {
                    // Show language selection dialog
                    _showLanguageSelectionDialog(context, languageProvider, localizations);
                  },
                  child: ListTile(
                    leading: const Icon(Icons.language),
                    title: Text(localizations.translate('language')),
                    trailing: DropdownButton<String>(
                      value: languageProvider.currentLanguage,
                      underline: Container(),
                      onChanged: (String? newLanguage) {
                        if (newLanguage != null) {
                          languageProvider.setLanguage(newLanguage);
                        }
                      },
                      items: [
                        DropdownMenuItem(
                          value: 'en',
                          child: Text(localizations.isArabic ? 'الإنجليزية' : 'English'),
                        ),
                        DropdownMenuItem(
                          value: 'ar',
                          child: Text(localizations.isArabic ? 'العربية' : 'Arabic'),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 1),
                // Font Size
                InkWell(
                  onTap: () {
                    // Show font size selection dialog
                  },
                  child: ListTile(
                    leading: const Icon(Icons.format_size),
                    title: Text(localizations.translate('font size')),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            // Decrease font size
                          },
                        ),
                        const Text('Normal'), // Get from provider
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            // Increase font size
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Support & About Section
          _buildSectionHeader(context, localizations.translate('support and about')),
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
                      builder: (ctx) => AlertDialog(
                        title: Text(localizations.translate('about')),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.computer,
                                size: 30,
                                color: Theme.of(context).colorScheme.primary,
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
                            Text(localizations.translate('about_description')),
                            const SizedBox(height: 16),
                            const Divider(),
                            const SizedBox(height: 16),
                            Text(
                              localizations.translate('special thanks'),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(localizations.translate('thanks to medaad and 1000 programmer initiative')),
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
                  onTap: () async {
                    final Uri emailLaunchUri = Uri(
                      scheme: 'mailto',
                      path: 'pc_land_support@gmail.com',
                      queryParameters: {
                        'subject': 'PCLand Store Support',
                      },
                    );
                    
                    if (await url_launcher.canLaunchUrl(emailLaunchUri)) {
                      await url_launcher.launchUrl(emailLaunchUri);
                    }
                  },
                  child: ListTile(
                    leading: const Icon(Icons.mail_outline),
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
            color: userProvider.isLoggedIn 
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
                    builder: (ctx) => AlertDialog(
                      title: Text(localizations.translate('logout')),
                      content: Text(localizations.translate('logout_confirm')),
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
              child: userProvider.isLoggedIn
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
          
          // App Version
          Center(
            child: Text(
              '${localizations.translate('version')} 1.0.0',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
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

  void _requestNotificationPermissions(BuildContext context) async {
    // Here you would implement the code to request notification permissions
    // This is just a placeholder
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context).translate('notifications')),
        content: Text(AppLocalizations.of(context).translate('notification_permission_request')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(AppLocalizations.of(context).translate('deny')),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(AppLocalizations.of(context).translate('allow')),
          ),
        ],
      ),
    );
  }

  void _showThemeSelectionDialog(BuildContext context, ThemeProvider themeProvider, AppLocalizations localizations) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
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

  void _showLanguageSelectionDialog(BuildContext context, LanguageProvider languageProvider, AppLocalizations localizations) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(localizations.translate('select language')),
        children: [
          RadioListTile<String>(
            title: Text(localizations.isArabic ? 'الإنجليزية' : 'English'),
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
            title: Text(localizations.isArabic ? 'العربية' : 'Arabic'),
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
