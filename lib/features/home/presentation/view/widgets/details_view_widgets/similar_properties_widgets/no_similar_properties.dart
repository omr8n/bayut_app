import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/utils/colors.dart';

class NoSimilarProperties extends StatelessWidget {
  const NoSimilarProperties({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.info_outline,
            color: isDark ? AppColors.textSecondaryDark : Colors.grey,
            size: 32.sp,
          ),
          SizedBox(height: 8.h),
          Text(
            localizations.translate(LangKeys.noSimilarProperties),
            style: TextStyle(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : Colors.grey.shade600,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
