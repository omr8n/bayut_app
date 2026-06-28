import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/settings_section.dart';
import '../common/settings_tile.dart';

class GeographySettingsTab extends StatelessWidget {
  const GeographySettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        children: [
          SettingsSection(
            title: 'محرك النطاق الجغرافي',
            children: [
              SettingsTile(
                title: 'المحافظات المتاحة',
                subtitle: '0 محافظة مفعلة',
                icon: const Icon(Icons.map_outlined),
                iconBackgroundColor: const Color(0xFF2D3142),
                trailing: Icon(Icons.arrow_back_ios_new, size: 12.sp, color: const Color(0xFF9EA3AE)),
              ),
              SettingsTile(
                title: 'المدن والمناطق',
                subtitle: '5 مدينة مسجلة',
                icon: const Icon(Icons.location_city_rounded),
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
