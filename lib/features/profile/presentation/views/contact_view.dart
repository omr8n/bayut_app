import 'package:flutter/material.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactView extends StatelessWidget {
  const ContactView({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(localizations.translate(LangKeys.contactUsFollowUs)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            localizations.translate(LangKeys.contactUsHelpText),
            style: const TextStyle(fontSize: 16, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          _buildContactOption(
            context: context,
            icon: Icons.email_outlined,
            title: localizations.translate(LangKeys.supportEmail),
            subtitle: 'support@baytesy.com',
            color: Colors.orange,
            onTap: () => _launchURL('mailto:support@baytesy.com'),
          ),
          _buildContactOption(
            context: context,
            icon: Icons.chat_bubble_outline,
            title: localizations.translate(LangKeys.customerServiceWhatsapp),
            subtitle: '+963 935 922 621',
            color: Colors.green,
            onTap: () => _launchURL('https://wa.me/963935922621'),
          ),
          const SizedBox(height: 30),
          const Divider(),
          const SizedBox(height: 20),
          Text(
            localizations.translate(LangKeys.followUsSocial),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSocialIcon(
                Icons.facebook,
                'https://facebook.com/baytesy',
                Colors.blue.shade800,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final localizations = AppLocalizations.of(context)!;
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: color, size: 30),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          textDirection: localizations.isEnLocale ? TextDirection.ltr : TextDirection.rtl,
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, String url, Color color) {
    return InkWell(
      onTap: () => _launchURL(url),
      borderRadius: BorderRadius.circular(50),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: CircleAvatar(
          radius: 30,
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color, size: 32),
        ),
      ),
    );
  }
}
