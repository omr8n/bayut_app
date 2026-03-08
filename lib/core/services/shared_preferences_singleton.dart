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

  static Future<bool> setint(String key, int value) {
    return _instance.setInt(key, value);
  }

  static Object getint(String key) {
    return _instance.getInt(key) ?? "";
  }
}
