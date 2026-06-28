import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/settings_section.dart';
import '../common/settings_tile.dart';

class MarketSettingsTab extends StatelessWidget {
  const MarketSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        children: [
          SettingsSection(
            title: 'محرك الأسعار والعمولات',
            children: [
              SettingsTile(
                title: 'العملة الأساسية',
                icon: const Icon(Icons.monetization_on_outlined),
                iconBackgroundColor: const Color(0xFF1E3A8A),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back_ios_new, size: 12.sp, color: const Color(0xFF9EA3AE)),
                    SizedBox(width: 8.w),
                    Text(
                      'SYP',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF1E3A8A),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SettingsTile(
                title: 'سعر التمييز (SYP)',
                icon: const Icon(Icons.account_balance_wallet_outlined),
                iconBackgroundColor: const Color(0xFF3B82F6),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back_ios_new, size: 12.sp, color: const Color(0xFF9EA3AE)),
                    SizedBox(width: 8.w),
                    Text(
                      '500.0',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF1E3A8A),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SettingsTile(
                title: 'نسبة العمولة (%)',
                icon: const Icon(Icons.percent_rounded),
                iconBackgroundColor: const Color(0xFF60A5FA),
                showDivider: false,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back_ios_new, size: 12.sp, color: const Color(0xFF9EA3AE)),
                    SizedBox(width: 8.w),
                    Text(
                      '2.5%',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF1E3A8A),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SettingsSection(
            title: 'حدود الميديا',
            children: [
              SettingsTile(
                title: 'الحد الأقصى للصور',
                icon: const Icon(Icons.image_outlined),
                iconBackgroundColor: const Color(0xFF93C5FD),
                showDivider: false,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back_ios_new, size: 12.sp, color: const Color(0xFF9EA3AE)),
                    SizedBox(width: 8.w),
                    Text(
                      '10 صور',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF3B82F6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
