import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  static const String _prefKey = 'selected_locale';

  Locale _locale = const Locale('id');

  Locale get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final code = prefs.getString(_prefKey);
      if (code != null && (code == 'id' || code == 'en')) {
        _locale = Locale(code);
        notifyListeners();
      }
    } catch (_) {
      // Fallback silently
    }
  }

  Future<void> setLocale(Locale newLocale) async {
    if (!['id', 'en'].contains(newLocale.languageCode)) return;
    if (_locale.languageCode == newLocale.languageCode) return;

    _locale = newLocale;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, newLocale.languageCode);
    } catch (_) {}
  }

  void toggleLocale() {
    if (_locale.languageCode == 'id') {
      setLocale(const Locale('en'));
    } else {
      setLocale(const Locale('id'));
    }
  }
}

