import 'package:flutter/material.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/my_properties/presentation/views/my_properties_view.dart';
import 'package:test_graduation/features/profile/presentation/views/contact_view.dart';
import 'package:test_graduation/features/profile/presentation/views/guide_view.dart';
import 'package:test_graduation/features/profile/presentation/views/settings_view.dart';
import 'package:test_graduation/features/profile/presentation/views/terms_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildMenuSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, bottom: 30, left: 20, right: 20),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: const Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white24,
            child: Text('O', style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 15),
          Text('Omran Abo Ali', style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
          Text('aboaliomrano@gmail.com', style: TextStyle(fontSize: 14, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          _buildMenuItem(Icons.home_work_outlined, 'عقاراتي', Colors.blue, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MyPropertiesScreen()))),
          _buildDivider(),
          _buildMenuItem(Icons.settings_outlined, 'الإعدادات', Colors.orange, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsView()))),
          _buildDivider(),
          _buildNightModeSwitch(),
          _buildDivider(),
          _buildMenuItem(Icons.menu_book_outlined, 'دليل استخدام التطبيق', Colors.pink, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GuideView()))),
          _buildDivider(),
          _buildMenuItem(Icons.policy_outlined, 'شروط الاستخدام', Colors.teal, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TermsView()))),
          _buildDivider(),
          _buildMenuItem(Icons.star_outline, 'تقييم التطبيق', Colors.amber, () {}), // يفتح متجر التطبيقات
          _buildDivider(),
          _buildMenuItem(Icons.share_outlined, 'مشاركة التطبيق', Colors.lightBlue, () {}), // يفتح نافذة المشاركة
          _buildDivider(),
          _buildMenuItem(Icons.contact_support_outlined, 'اتصل بنا وتابعنا', Colors.cyan, () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactView()))),
          _buildDivider(),
          _buildMenuItem(Icons.logout, 'تسجيل الخروج', Colors.red, () {}, isLast: true),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, Color iconColor, VoidCallback onTap, {bool isLast = false}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
      shape: isLast ? const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))) : null,
    );
  }

  Widget _buildNightModeSwitch() {
    return SwitchListTile(
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.indigo.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: const Icon(Icons.dark_mode_outlined, color: Colors.indigo, size: 24),
      ),
      title: const Text('الوضع الليلي', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
      value: _isDarkMode,
      onChanged: (value) {
        setState(() => _isDarkMode = value);
        // يمكنك هنا تغيير الـ Theme للتطبيق
      },
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, indent: 70, endIndent: 20, color: Colors.grey.withOpacity(0.1));
  }
}
