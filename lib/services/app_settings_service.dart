import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsService {
  static const _keyDeveloperMode = 'developer_mode';
  static const _keyCurrency = 'currency';

  Future<bool> loadDeveloperMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyDeveloperMode) ?? false;
  }

  Future<String> loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyCurrency) ?? 'EUR';
  }

  Future<void> saveDeveloperMode(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDeveloperMode, enabled);
  }

  Future<void> saveCurrency(String currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCurrency, currency);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyDeveloperMode);
    await prefs.remove(_keyCurrency);
  }
}
