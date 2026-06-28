import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/settings_section.dart';
import '../common/settings_tile.dart';

class PropertyDataSettingsTab extends StatelessWidget {
  const PropertyDataSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        children: [
          SettingsSection(
            title: 'تخصيص بيانات العقار',
            children: [
              SettingsTile(
                title: 'أنواع العقارات',
                subtitle: '5 تصنيف',
                icon: const Icon(Icons.category_outlined),
                iconBackgroundColor: const Color(0xFF2D3142),
                trailing: Icon(Icons.arrow_back_ios_new, size: 12.sp, color: const Color(0xFF9EA3AE)),
              ),
              SettingsTile(
                title: 'مرافق العقار (Facilities)',
                subtitle: '0 مرفق متاح',
                icon: const Icon(Icons.pool_rounded),
                iconBackgroundColor: const Color(0xFF2D3142),
                trailing: Icon(Icons.arrow_back_ios_new, size: 12.sp, color: const Color(0xFF9EA3AE)),
              ),
              SettingsTile(
                title: 'أنواع الإكساء',
                subtitle: '0 نوع إكساء',
                icon: const Icon(Icons.format_paint_outlined),
                iconBackgroundColor: const Color(0xFF2D3142),
                trailing: Icon(Icons.arrow_back_ios_new, size: 12.sp, color: const Color(0xFF9EA3AE)),
              ),
              SettingsTile(
                title: 'أنواع الملكية',
                subtitle: '0 نوع ملكية',
                icon: const Icon(Icons.assignment_outlined),
                iconBackgroundColor: const Color(0xFF2D3142),
                trailing: Icon(Icons.arrow_back_ios_new, size: 12.sp, color: const Color(0xFF9EA3AE)),
              ),
              SettingsTile(
                title: 'اتجاهات العقار',
                subtitle: '0 اتجاه',
                icon: const Icon(Icons.explore_outlined),
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
