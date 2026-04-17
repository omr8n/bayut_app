import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/utils/colors.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.admin_panel_settings, size: 60, color: Colors.white),
                SizedBox(height: 12),
                Text(
                  'لوحة التحكم',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('الرئيسية'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('إدارة المستخدمين'),
            onTap: () {
              Navigator.pop(context);
              context.pushNamed(AppRoutes.adminUsers);
            },
          ),
          ListTile(
            leading: const Icon(Icons.home_work),
            title: const Text('إدارة العقارات'),
            onTap: () {
              Navigator.pop(context);
              context.pushNamed(AppRoutes.adminProperties);
            },
          ),
          ListTile(
            leading: const Icon(Icons.warning),
            title: const Text('الإبلاغات'),
            onTap: () {
              Navigator.pop(context);
              context.pushNamed(AppRoutes.adminReports);
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('الإشعارات'),
            onTap: () {
              Navigator.pop(context);
              context.pushNamed(AppRoutes.adminNotifications);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('الإعدادات'),
            onTap: () {
              Navigator.pop(context);
              context.pushNamed(AppRoutes.adminSettings);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: const Text(
              'تسجيل الخروج',
              style: TextStyle(color: AppColors.error),
            ),
            onTap: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
    );
  }
}
