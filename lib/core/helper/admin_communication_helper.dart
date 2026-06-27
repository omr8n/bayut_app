import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminCommunicationHelper {
  /// يقوم بفتح محادثة واتساب احترافية مع الإدارة باستخدام المنطق العالمي (World-class logic)
  /// يعود بـ true إذا نجحت العملية، و false إذا فشلت
  static Future<bool> contactAdminViaWhatsApp({required String rawNumber}) async {
    if (rawNumber.trim().isEmpty) return false;

    // 1. تنظيف الرقم
    String phoneNumber = rawNumber.trim().replaceAll(RegExp(r'\s+|-|\+'), '');

    // 2. تطبيق منطق الأرقام السورية
    if (phoneNumber.startsWith('09')) {
      phoneNumber = '963${phoneNumber.substring(1)}';
    }

    // 3. محاولة فتح الرابط
    final Uri whatsappUrl = Uri.parse('https://api.whatsapp.com/send?phone=$phoneNumber');

    try {
      final bool launched = await launchUrl(
        whatsappUrl,
        mode: LaunchMode.externalApplication,
      );
      return launched;
    } catch (e) {
      debugPrint('AdminCommunication: Critical error: $e');
      return false;
    }
  }
}
