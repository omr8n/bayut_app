import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/utils/colors.dart';

class LogoSection extends StatelessWidget {
  const LogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 2,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            const _LogoIcon(),
            SizedBox(width: 12.w),
            const _LogoText(),
          ],
        ),
      ),
    );
  }
}

class _LogoIcon extends StatelessWidget {
  const _LogoIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Icon(
        Icons.home_work_rounded,
        color: AppColors.primary,
        size: 26.sp,
      ),
    );
  }
}

class _LogoText extends StatelessWidget {
  const _LogoText();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.translate(LangKeys.appName).toUpperCase(),
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: localizations.isEnLocale ? 1.5 : 0,
            color: AppColors.primary,
            height: 1.2,
          ),
        ),
        Text(
          localizations.translate(LangKeys.syrianRealEstate),
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
            letterSpacing: localizations.isEnLocale ? 1 : 0,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
