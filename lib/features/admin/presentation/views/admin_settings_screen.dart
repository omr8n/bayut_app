import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'widgets/tabs/platform_settings_tab.dart';
import 'widgets/tabs/market_settings_tab.dart';
import 'widgets/tabs/geography_settings_tab.dart';
import 'widgets/tabs/property_data_settings_tab.dart';
import 'widgets/tabs/legal_contact_settings_tab.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 5,
      initialIndex: 4, // Starting from "Platform" (Right-most in RTL)
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            local.admin_system_engine,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: const Color(0xFF3B82F6),
            indicatorWeight: 3,
            labelColor: const Color(0xFF3B82F6),
            unselectedLabelColor: const Color(0xFF9EA3AE),
            labelStyle: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.normal,
            ),
            tabs: [
               Tab(
                text: local.legal_and_contact,
                icon: const Icon(Icons.gavel_rounded),
              ),
              Tab(
                text: local.property_data,
                icon: const Icon(Icons.home_work_outlined),
              ),
              Tab(
                text: local.geography,
                icon: const Icon(Icons.public_rounded),
              ),
              Tab(
                text: local.market,
                icon: const Icon(Icons.shopping_bag_outlined),
              ),
              Tab(
                text: local.platform,
                icon: const Icon(Icons.tune_rounded),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            LegalContactSettingsTab(),
            PropertyDataSettingsTab(),
            GeographySettingsTab(),
            MarketSettingsTab(),
            PlatformSettingsTab(),
          ],
        ),
      ),
    );
  }
}
