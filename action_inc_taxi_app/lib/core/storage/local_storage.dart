import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const _tokenKey = 'auth_token';
  static const _employeeIdKey = 'employee_id';
  static const _lastRouteKey = 'last_route';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<void> saveWasReloaded(bool wasReloaded) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('was_reloaded', wasReloaded);
  }

  static Future<bool> wasReloaded() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('was_reloaded');
  }

  static Future<void> clearWasReloaded() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('was_reloaded');
  }

  static Future<void> saveID(String employeeId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_employeeIdKey, employeeId);
  }

  static Future<void> saveLastRoute(String routeName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastRouteKey, routeName);
  }

  static Future<String?> getID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_employeeIdKey);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<String?> getLastRoute() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastRouteKey);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_employeeIdKey);
    await prefs.remove(_lastRouteKey);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_tokenKey) && prefs.containsKey(_employeeIdKey);
  }
}
