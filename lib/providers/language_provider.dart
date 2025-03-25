import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  String _currentLanguage = 'ar'; // Default to Arabic
  final String _languageKey = 'language_code';

  String get currentLanguage => _currentLanguage;

  LanguageProvider() {
    loadLanguage();
  }

  Future<void> loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentLanguage = prefs.getString(_languageKey) ?? 'ar';
      notifyListeners();
    } catch (e) {
      // Default to Arabic if there's an error
      _currentLanguage = 'en';
    }
  }

  Future<void> setLanguage(String languageCode) async {
    if (languageCode != _currentLanguage) {
      _currentLanguage = languageCode;
      notifyListeners();
      
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_languageKey, languageCode);
      } catch (e) {
        // Handle error
        print('Error saving language preference: $e');
      }
    }
  }

  // تبديل اللغة بين العربية والإنجليزية
  Future<void> toggleLanguage() async {
    final newLanguage = _currentLanguage == 'ar' ? 'en' : 'ar';
    await setLanguage(newLanguage);
  }
}
