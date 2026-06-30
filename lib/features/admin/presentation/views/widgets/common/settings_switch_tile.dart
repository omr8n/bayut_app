import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/core/utils/colors.dart';

class SettingsSwitchTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget icon;
  final Color iconBackgroundColor;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showDivider;

  const SettingsSwitchTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.iconBackgroundColor,
    required this.value,
    required this.onChanged,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChanged(!value),
        splashColor: iconBackgroundColor.withValues(alpha: 0.08),
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

                  // Interactive Switch
                  Transform.scale(
                    scale: 0.8,
                    child: Switch.adaptive(
                      value: value,
                      onChanged: onChanged,
                      activeThumbColor: AppColors.primary,
                      activeTrackColor: AppColors.primary.withValues(
                        alpha: 0.2,
                      ),
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.grey.shade200,
                    ),
                  ),
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
