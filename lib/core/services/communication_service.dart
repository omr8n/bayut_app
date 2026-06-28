import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';

abstract class CommunicationService {
  Future<bool> makeCall(String phone);
  Future<bool> sendWhatsApp(String phone, {String? message});
  Future<bool> sendEmail(String email, {String? subject, String? body});
}

class CommunicationServiceImpl implements CommunicationService {
  @override
  Future<bool> makeCall(String phone) async {
    final Uri url = Uri.parse('tel:$phone');
    try {
      if (await canLaunchUrl(url)) {
        return await launchUrl(url);
      }
    } catch (e) {
      debugPrint('Error making call: $e');
    }
    return false;
  }

  @override
  Future<bool> sendWhatsApp(String phone, {String? message}) async {
    // Clean phone number
    String cleanPhone = phone.trim().replaceAll(RegExp(r'\s+|-'), '');
    if (cleanPhone.startsWith('09')) {
      cleanPhone = '963${cleanPhone.substring(1)}';
    } else if (!cleanPhone.startsWith('+') && !cleanPhone.startsWith('963')) {
      // Default to Syria if no country code
      if (cleanPhone.length == 9) cleanPhone = '963$cleanPhone';
    }

    final String encodedMsg = message != null ? Uri.encodeComponent(message) : '';
    final Uri url = Uri.parse('https://api.whatsapp.com/send?phone=$cleanPhone&text=$encodedMsg');

    try {
      return await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Error sending WhatsApp: $e');
      return false;
    }
  }

  @override
  Future<bool> sendEmail(String email, {String? subject, String? body}) async {
    final String query = [
      if (subject != null) 'subject=${Uri.encodeComponent(subject)}',
      if (body != null) 'body=${Uri.encodeComponent(body)}',
    ].join('&');

    final Uri url = Uri.parse('mailto:$email?$query');
    try {
      if (await canLaunchUrl(url)) {
        return await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        return await launchUrl(url);
      }
    } catch (e) {
      debugPrint('Error sending email: $e');
      return false;
    }
  }
}
