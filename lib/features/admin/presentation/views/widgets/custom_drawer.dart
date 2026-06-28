import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/utils/colors.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.admin_panel_settings, size: 60, color: Colors.white),
                const SizedBox(height: 12),
                Text(
                  local.admin_dashboard_label,
                  style: const TextStyle(
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
            title: Text(local.home),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: Text(local.manage_users),
            onTap: () {
              Navigator.pop(context);
              context.pushNamed(AppRoutes.adminUsers);
            },
          ),
          ListTile(
            leading: const Icon(Icons.home_work),
            title: Text(local.manage_properties),
            onTap: () {
              Navigator.pop(context);
              context.pushNamed(AppRoutes.adminProperties);
            },
          ),
          ListTile(
            leading: const Icon(Icons.warning),
            title: Text(local.notif_type_report),
            onTap: () {
              Navigator.pop(context);
              context.pushNamed(AppRoutes.adminReports);
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet_rounded),
            title: Text(local.financial_wallet),
            onTap: () {
              Navigator.pop(context);
              context.pushNamed(AppRoutes.adminFinancials);
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: Text(local.notifications),
            onTap: () {
              Navigator.pop(context);
              context.pushNamed(AppRoutes.adminNotifications);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(local.settings),
            onTap: () {
              Navigator.pop(context);
              context.pushNamed(AppRoutes.adminSettings);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: Text(
              local.log_out,
              style: const TextStyle(color: AppColors.error),
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
