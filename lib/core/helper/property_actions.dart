import 'package:url_launcher/url_launcher.dart';

class PropertyActions {
  static Future<void> makeCall(String phone) async {
    final Uri url = Uri.parse('tel:$phone');
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  static Future<void> sendWhatsApp(String whatsapp) async {
    final Uri url = Uri.parse('https://wa.me/$whatsapp');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  static Future<void> sendEmail(String title) async {
    final Uri url = Uri.parse(
      'mailto:support@bayut.com?subject=استفسار عن عقار: $title',
    );
    if (await canLaunchUrl(url)) await launchUrl(url);
  }
}
