import 'package:flutter/material.dart';

class AppColors {
  // الألوان الأساسية الأصلية لتطبيقك
  static const Color primary = Color(0xFF0E4C8C);
  static const Color secondary = Color(0xFFFF6B35);
  static const Color accent = Color(0xFF00B4D8);

  // ألوان بيوت الإمارات (الأخضر) - تمت إضافتها للـ Onboarding التفاعلي
  static const Color bayutGreen = Color(0xFF005F5F);
  static const Color bayutGreenLight = Color(0xFFE8F3F3);

  // ألوان الخلفية
  static const Color background = Color(0xFFF8F9FA);
  static const Color cardBackground = Colors.white;
  static const Color darkBackground = Color(0xFF1A1A2E);
  static const Color greyBackground = Color(0xFFF7F7F7);

  // ألوان النصوص
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textLight = Color(0xFFB2BEC3);

  // ألوان الحالة
  static const Color success = Color(0xFF00B894);
  static const Color warning = Color(0xFFFDCB6E);
  static const Color error = Color(0xFFD63031);
  static const Color info = Color(0xFF0984E3);

  // ألوان خاصة
  static const Color forSale = Color(0xFF00B894);
  static const Color forRent = Color(0xFF0984E3);
  static const Color featured = Color(0xFFFFD700);

  // ألوان مساعدة للـ Onboarding (تم استخدامها في الكود السابق)
  static const Color primaryLight = Color(0xFFE7F0F8);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF1E3A8A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
