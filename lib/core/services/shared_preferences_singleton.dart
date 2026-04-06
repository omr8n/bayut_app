import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static late SharedPreferences _instance;

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _instance = await SharedPreferences.getInstance();
  }

  static void setBool(String key, bool value) {
    _instance.setBool(key, value);
  }

  static bool getBool(String key) {
    return _instance.getBool(key) ?? false;
  }

  static Future<void> setString(String key, String value) async {
    await _instance.setString(key, value);
  }

  static String getString(String key) {
    return _instance.getString(key) ?? "";
  }

  // 🔥 إضافة دعم القوائم (لسجل البحث)
  static Future<void> setStringList(String key, List<String> value) async {
    await _instance.setStringList(key, value);
  }

  static List<String>? getStringList(String key) {
    return _instance.getStringList(key);
  }

  static Future<bool> setint(String key, int value) {
    return _instance.setInt(key, value);
  }

  static Object remove(String key) {
    return _instance.remove(key);
  }

  static int getint(String key) { // تصحيح نوع الإرجاع
    return _instance.getInt(key) ?? 0;
  }
}
