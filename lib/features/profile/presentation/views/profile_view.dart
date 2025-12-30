import 'package:flutter/material.dart';
import 'package:test_graduation/core/utils/colors.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

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
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: const Text(
              'O',
              style: TextStyle(
                fontSize: 40,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Omran Abo Ali',
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'aboaliomrano@gmail.com',
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(
            Icons.home_work_outlined,
            'عقاراتي',
            Colors.blue,
            () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            Icons.settings_outlined,
            'الإعدادات',
            Colors.orange,
            () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            Icons.dark_mode_outlined,
            'الوضع الليلي',
            Colors.indigo,
            () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            Icons.menu_book_outlined,
            'دليل استخدام التطبيق',
            Colors.pink,
            () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            Icons.policy_outlined,
            'شروط الاستخدام',
            Colors.teal,
            () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            Icons.star_outline,
            'تقييم التطبيق',
            Colors.amber,
            () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            Icons.share_outlined,
            'مشاركة التطبيق',
            Colors.lightBlue,
            () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            Icons.contact_support_outlined,
            'اتصل بنا وتابعنا',
            Colors.cyan,
            () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            Icons.logout,
            'تسجيل الخروج',
            Colors.red,
            () {},
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    Color iconColor,
    VoidCallback onTap, {
    bool isLast = false,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
      shape: isLast
          ? const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            )
          : null,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      indent: 20,
      endIndent: 20,
      color: Colors.grey.withOpacity(0.1),
    );
  }
}
