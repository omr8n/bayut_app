import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/settings_section.dart';
import '../common/settings_tile.dart';

class PlatformSettingsTab extends StatelessWidget {
  const PlatformSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        children: [
          SettingsSection(
            title: 'التحكم الأساسي',
            children: [
              SettingsTile(
                title: 'وضع الصيانة',
                subtitle: 'إيقاف وصول المستخدمين مؤقتاً',
                icon: const Icon(Icons.build_rounded),
                iconBackgroundColor: const Color(0xFFF59E0B),
                trailing: Switch.adaptive(
                  value: false,
                  onChanged: (val) {},
                  activeColor: const Color(0xFF1E3A8A),
                ),
              ),
              SettingsTile(
                title: 'الموافقة اليدوية',
                subtitle: 'مراجعة العقارات قبل النشر',
                icon: const Icon(Icons.verified_user_outlined),
                iconBackgroundColor: const Color(0xFF1E3A8A),
                trailing: Switch.adaptive(
                  value: true,
                  onChanged: (val) {},
                  activeColor: const Color(0xFF1E3A8A),
                ),
              ),
              SettingsTile(
                title: 'الإشعارات العامة',
                subtitle: 'تفعيل التنبيهات الجماعية',
                icon: const Icon(Icons.notifications_none_rounded),
                iconBackgroundColor: const Color(0xFF3B82F6),
                showDivider: false,
                trailing: Switch.adaptive(
                  value: false,
                  onChanged: (val) {},
                  activeColor: const Color(0xFF1E3A8A),
                ),
              ),
            ],
          ),
          SettingsSection(
            title: 'هوية المنصة',
            children: [
              SettingsTile(
                title: 'اسم التطبيق',
                icon: const Icon(Icons.aspect_ratio_rounded),
                iconBackgroundColor: const Color(0xFF1E3A8A),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back_ios_new, size: 12.sp, color: const Color(0xFF9EA3AE)),
                    SizedBox(width: 8.w),
                    Text(
                      'بيوت سوريا',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF3B82F6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SettingsTile(
                title: 'إصدار النظام',
                icon: const Icon(Icons.info_outline_rounded),
                iconBackgroundColor: const Color(0xFF3B82F6),
                showDivider: false,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back_ios_new, size: 12.sp, color: const Color(0xFF9EA3AE)),
                    SizedBox(width: 8.w),
                    Text(
                      '1.0.0',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF9EA3AE),
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
