import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'home_header_widgets/logo_section.dart';
import 'home_header_widgets/user_actions_section.dart';

/// [HomeHeader] follows SRP (Single Responsibility Principle)
/// by delegating its parts to specialized widgets.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 جعلنا الهيدر Widget عادياً ليكون مرناً وقابلاً لإعادة الاستخدام في أي مكان
    return Padding(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        // 🔥 استخدام المسافة العلوية للنظام لضمان عدم التداخل مع شريط الحالة
        top: MediaQuery.of(context).padding.top + 8.h,
        bottom: 8.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LogoSection(),
          UserActionsSection(),
        ],
      ),
    );
  }
}
