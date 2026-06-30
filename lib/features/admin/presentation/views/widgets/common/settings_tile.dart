import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/utils/colors.dart';

class SettingsTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget icon;
  final Color iconBackgroundColor;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;

  const SettingsTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.iconBackgroundColor,
    this.trailing,
    this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: iconBackgroundColor.withValues(alpha: .08),
        highlightColor: iconBackgroundColor.withValues(alpha: 0.04),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Row(
                children: [
                  // Icon with Soft Gradient Background
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          iconBackgroundColor.withValues(alpha: 0.12),
                          iconBackgroundColor.withValues(alpha: 0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Center(
                      child: IconTheme(
                        data: IconThemeData(
                          color: iconBackgroundColor,
                          size: 22.w,
                        ),
                        child: icon,
                      ),
                    ),
                  ),

                  SizedBox(width: 16.w),

                  // Title and Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : const Color(0xFF1A1A1A),
                            fontFamily: 'Cairo',
                          ),
                        ),
                        if (subtitle != null) ...[
                          SizedBox(height: 2.h),
                          Text(
                            subtitle!,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.textSecondaryDark
                                  : const Color(0xFF7F8C8D),
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Trailing
                  if (trailing != null) ...[
                    trailing!,
                  ] else if (onTap != null) ...[
                    Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 10.sp,
                        color: const Color(0xFFBDC3C7),
                        textDirection: local.isEnLocale
                            ? TextDirection.ltr
                            : TextDirection.rtl,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (showDivider)
              Padding(
                padding: EdgeInsetsDirectional.only(start: 76.w, end: 16.w),
                child: Divider(
                  height: 1,
                  thickness: 0.8,
                  color: const Color(0xFFF1F1F1),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
