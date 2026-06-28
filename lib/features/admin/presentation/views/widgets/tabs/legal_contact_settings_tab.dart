import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/settings_section.dart';
import '../common/settings_tile.dart';

class LegalContactSettingsTab extends StatelessWidget {
  const LegalContactSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        children: [
          SettingsSection(
            title: 'التواصل والدعم',
            children: [
              SettingsTile(
                title: 'بريد الدعم',
                icon: const Icon(Icons.email_outlined),
                iconBackgroundColor: const Color(0xFF1E3A8A),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back_ios_new, size: 12.sp, color: const Color(0xFF9EA3AE)),
                    SizedBox(width: 8.w),
                    Text(
                      'support@bayut-syria.com',
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
                title: 'هاتف الدعم',
                icon: const Icon(Icons.phone_android_rounded),
                iconBackgroundColor: const Color(0xFF1E3A8A),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back_ios_new, size: 12.sp, color: const Color(0xFF9EA3AE)),
                    SizedBox(width: 8.w),
                    Text(
                      '+ 963000000',
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
                title: 'روابط التواصل الاجتماعي',
                subtitle: 'فيسبوك، واتساب، انستغرام',
                icon: const Icon(Icons.share_outlined),
                iconBackgroundColor: const Color(0xFF2D3142),
                showDivider: false,
                trailing: Icon(Icons.arrow_back_ios_new, size: 12.sp, color: const Color(0xFF9EA3AE)),
              ),
            ],
          ),
          SettingsSection(
            title: 'السياسات القانونية',
            children: [
              SettingsTile(
                title: 'شروط الاستخدام',
                subtitle: 'تعديل اتفاقية الاستخدام',
                icon: const Icon(Icons.gavel_rounded),
                iconBackgroundColor: const Color(0xFF2D3142),
                trailing: Icon(Icons.arrow_back_ios_new, size: 12.sp, color: const Color(0xFF9EA3AE)),
              ),
              SettingsTile(
                title: 'سياسة الخصوصية',
                subtitle: 'تعديل نص الخصوصية',
                icon: const Icon(Icons.verified_user_outlined),
                iconBackgroundColor: const Color(0xFF2D3142),
                showDivider: false,
                trailing: Icon(Icons.arrow_back_ios_new, size: 12.sp, color: const Color(0xFF9EA3AE)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
