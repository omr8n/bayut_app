import 'package:flutter/material.dart';

class AppColors {
  // --- الأساسية (التي لا تتغير) ---
  static const Color primary = Color(0xFF0D47A1); // أزرق حيوي
  static const Color secondary = Color(0xFFF57C00); // برتقالي للأكشنز والمميز
  static const Color accent = Color(0xFF00B4D8);

  // --- ألوان الوضع الداكن (مستوحاة من الصور) ---
  static const Color darkBackground = Color(
    0xFF0A1220,
  ); // الكحلي العميق للخلفية
  static const Color darkCard = Color(0xFF162031); // كحلي أفتح قليلاً للبطاقات
  static const Color darkSurface = Color(0xFF1E293B); // للأسطح الثانوية
  static const Color darkInput = Color(0xFF162031); // حقول الإدخال

  // --- ألوان النصوص ---
  static const Color textPrimary = Color(0xFF1A1C1E);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textLight = Color(0xFFB2BEC3);

  static const Color textSecondaryDark = Color(
    0xFF90A4AE,
  ); // رمادي مزرق للنصوص الثانوية

  static const Color textPrimaryLight = Color(0xFF1A1C1E);
  static const Color textSecondaryLight = Color(0xFF636E72);

  // --- ألوان الحالة (حيوية لتناسب الوضع الداكن) ---
  static const Color success = Color(0xFF00C853);
  static const Color warning = Color(0xFFFFAB00);
  static const Color error = Color(0xFFD50000);
  static const Color info = Color(0xFF2979FF);

  // --- ألوان النوع (Sale / Rent / Featured) ---
  static const Color featured = Color(0xFFFFD700);
  static const Color forSale = primary;
  static const Color forRent = secondary;

  // --- ألوان خاصة مستخرجة من الصور ---
  static const Color featuredGold = Color(0xFFFFD700);
  static const Color trendOrange = Color(0xFFFF6D00);
  static const Color navyIconBg = Color(
    0xFF1A237E,
  ); // خلفية الأيقونات في الوضع الداكن

  // Gradients
  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF0A1220), Color(0xFF162031)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF1976D2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ألوان بيوت الإمارات (الأخضر)
  static const Color bayutGreen = Color(0xFF005F5F);
  static const Color bayutGreenLight = Color(0xFFE8F3F3);

  // ألوان الخلفية الفاتحة (للوضع النهاري)
  static const Color background = Color(0xFFF8F9FA);
  static const Color cardBackground = Colors.white;
}
