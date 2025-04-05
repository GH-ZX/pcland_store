import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  Map<String, String> _localizedStrings = {};

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  // تعريف مندوب الترجمة الذي سيتم استخدامه في MaterialApp
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  // دالة تحميل ملف الترجمة من مجلد الأصول حسب رمز اللغة
  Future<bool> load() async {
    String jsonString = await rootBundle.loadString('assets/translations/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
    return true;
  }

  // دالة الترجمة الرئيسية التي تستخدم للحصول على النص المترجم
  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  // خاصية للتحقق ما إذا كانت اللغة الحالية هي العربية
  bool get isArabic => locale.languageCode == 'ar';
}

// كلاس مندوب الترجمة المسؤول عن إدارة عملية الترجمة
class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  // التحقق من أن اللغة مدعومة (العربية والإنجليزية فقط)
  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  // تحميل الترجمات للغة المحددة
  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  // تحديد ما إذا كان يجب إعادة تحميل الترجمات
  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
