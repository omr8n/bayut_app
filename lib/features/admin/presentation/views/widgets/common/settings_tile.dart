import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                // Icon with Background
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: iconBackgroundColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: IconTheme(
                      data: IconThemeData(
                        color: iconBackgroundColor,
                        size: 20.w,
                      ),
                      child: icon,
                    ),
                  ),
                ),

                SizedBox(width: 12.w),

                // Title and Subtitle
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2D3142),
                        ),
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: 4.h),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: const Color(0xFF9EA3AE),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const Spacer(),

                // Trailing or Value for Navigation Items
                if (trailing != null) trailing!,
              ],
            ),
          ),
          if (showDivider)
            Padding(
              padding: EdgeInsetsDirectional.only(start: 68.w, end: 16.w),
              child: Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey.withOpacity(0.2),
              ),
            ),
        ],
      ),
    );
  }
}
