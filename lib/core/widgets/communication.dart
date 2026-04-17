import 'package:flutter/material.dart';

import 'package:test_graduation/core/widgets/action_button.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/colors.dart';

class CommunicationButtons extends StatelessWidget {
  final PropertyEntity property;
  const CommunicationButtons({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    Future<void> makeCall() async {
      final Uri url = Uri.parse('tel:${property.phone}');
      if (await canLaunchUrl(url)) await launchUrl(url);
    }

    Future<void> sendWhatsApp() async {
      // تنظيف الرقم من أي فراغات أو رموز زائدة
      String phoneNumber = property.whatsapp.trim().replaceAll(
        RegExp(r'\s+|-'),
        '',
      );

      // إذا كان الرقم يبدأ بـ 09، نحوله للصيغة الدولية 9639
      if (phoneNumber.startsWith('09')) {
        phoneNumber = '963${phoneNumber.substring(1)}';
      }

      // نستخدم رابط api.whatsapp.com لأنه أحياناً wa.me بيفشل ببعض المتصفحات أو الأجهزة
      final Uri url = Uri.parse(
        'https://api.whatsapp.com/send?phone=$phoneNumber',
      );

      try {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } catch (e) {
        debugPrint('Could not launch WhatsApp: $e');
      }
    }

    Future<void> _sendEmail() async {
      // 1. نأخذ الإيميل من العقار
      // 2. إذا كان فارغاً، نستخدم إيميل افتراضي للدعم أو نطلب من المستخدم تحديث بيانات العقار
      String? email = property.email;

      // ملاحظة: بما أن الإيميل أضيف حديثاً للكود، العقارات القديمة ستحتاج لإيميل افتراضي
      if (email == null || email.isEmpty) {
        // يمكنك وضع إيميل الشركة هنا كخيار بديل للعقارات القديمة
        email = "support@syria-realestate.com";
      }

      final String subject = Uri.encodeComponent(
        'استفسار عن عقار: ${property.title}',
      );
      final Uri url = Uri.parse('mailto:$email?subject=$subject');

      try {
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          await launchUrl(url);
        }
      } catch (e) {
        debugPrint('Could not launch Email: $e');
      }
    }

    return Row(
      children: [
        ActionButton(
          label: 'واتساب',
          icon: Icons.chat_bubble_outline,
          color: const Color(0xFF25D366),
          onTap: sendWhatsApp,
        ),
        ActionButton(
          label: 'اتصال',
          icon: Icons.phone_outlined,
          color: AppColors.success,
          onTap: makeCall,
        ),
        ActionButton(
          label: 'الإيميل',
          icon: Icons.email_outlined,
          color: Colors.blue,
          onTap: _sendEmail,
        ),
      ],
    );
  }
}
