import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TranslationService {
  static const String defaultLangCode = 'en';
  static const String defaultCountryCode = 'US';
  static const String altLangCode = 'he';
  static const String altCountryCode = 'IL';

  /// Fetches the saved locale from storage, defaults to English (US) if not found.
  Future<Locale> getSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('language_code') ?? defaultLangCode;
    final countryCode = prefs.getString('country_code') ?? defaultCountryCode;
    return Locale(langCode, countryCode);
  }

  /// Saves the provided locale to persistent storage.
  static Future<void> saveLocale(String langCode, String countryCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', langCode);
    await prefs.setString('country_code', countryCode);
  }

  /// Toggles the locale between English (US) and Hebrew (IL).
  static Future<void> changeLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final currentLangCode = prefs.getString('language_code') ?? defaultLangCode;

    if (currentLangCode == defaultLangCode) {
      // Switch to Hebrew
      await Get.updateLocale(Locale(altLangCode, altCountryCode));
      await saveLocale(altLangCode, altCountryCode);
    } else {
      // Switch to English
      await Get.updateLocale(Locale(defaultLangCode, defaultCountryCode));
      await saveLocale(defaultLangCode, defaultCountryCode);
    }
  }
}
