import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test_graduation/core/services/firebase_auth_service.dart';

class SecureStorage {
  // ✅ ثابت - بدون init كل مرة
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static bool _isLoggedIn = false;

  /// 🔥 تهيئة الحالة (تعتمد على Firebase فقط)
  static Future<void> init() async {
    final firebaseAuth = FirebaseAuthService();

    // Firebase هو المصدر الحقيقي
    _isLoggedIn = firebaseAuth.isLoggedIn;

    log("SecureStorage Init: isLoggedIn=$_isLoggedIn");
  }

  /// 🔥 getter سريع
  static bool get isLoggedIn => _isLoggedIn;

  /// ✅ تخزين Boolean
  static Future<void> setBool(String key, bool value) async {
    await _storage.write(key: key, value: value.toString());

    if (key == 'isLoggedIn') {
      _isLoggedIn = value;
      log("SecureStorage: isLoggedIn updated to $value");
    }
  }

  /// ✅ تخزين String
  static Future<void> setString(String key, String value) async {
    await _storage.write(key: key, value: value);
    log("SecureStorage: String saved for key $key");
  }

  /// ✅ قراءة String
  static Future<String> getString(String key) async {
    return await _storage.read(key: key) ?? "";
  }

  /// 🔥 تسجيل الخروج (مهم جداً)
  static Future<void> clearAll() async {
    _isLoggedIn = false; // تحديث القيمة في الذاكرة فوراً
    await _storage.deleteAll();
    log("SecureStorage: All data cleared and _isLoggedIn set to false");
  }
}
