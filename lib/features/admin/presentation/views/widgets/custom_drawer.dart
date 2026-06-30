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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: Theme.of(context).brightness == Brightness.dark ? AppColors.darkGradient : AppColors.primaryGradient,
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
            leading: Icon(Icons.dashboard, color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : null),
            title: Text(local.home, style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : null)),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.people, color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : null),
            title: Text(local.manage_users, style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : null)),
            onTap: () {
              Navigator.pop(context);
              context.pushNamed(AppRoutes.adminUsers);
            },
          ),
          ListTile(
            leading: Icon(Icons.home_work, color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : null),
            title: Text(local.manage_properties, style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : null)),
            onTap: () {
              Navigator.pop(context);
              context.pushNamed(AppRoutes.adminProperties);
            },
          ),
          ListTile(
            leading: Icon(Icons.warning, color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : null),
            title: Text(local.notif_type_report, style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : null)),
            onTap: () {
              Navigator.pop(context);
              context.pushNamed(AppRoutes.adminReports);
            },
          ),
          ListTile(
            leading: Icon(Icons.account_balance_wallet_rounded, color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : null),
            title: Text(local.financial_wallet, style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : null)),
            onTap: () {
              Navigator.pop(context);
              context.pushNamed(AppRoutes.adminFinancials);
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications, color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : null),
            title: Text(local.notifications, style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : null)),
            onTap: () {
              Navigator.pop(context);
              context.pushNamed(AppRoutes.adminNotifications);
            },
          ),
          Divider(color: Theme.of(context).dividerColor),
          ListTile(
            leading: Icon(Icons.settings, color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : null),
            title: Text(local.settings, style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : null)),
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
