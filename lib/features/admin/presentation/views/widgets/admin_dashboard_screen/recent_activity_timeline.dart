import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/models/admin_stats_model.dart';

class RecentActivityTimeline extends StatelessWidget {
  final AdminStats stats;
  const RecentActivityTimeline({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildActivityItem(
            icon: Icons.person_add_alt_1_rounded,
            color: const Color(0xFFFFB74D), // Orange
            title: local.new_users,
            desc: local.joined_platform_today,
            count: stats.newUsersToday,
            isFirst: true,
          ),
          _buildActivityItem(
            icon: Icons.add_home_work_rounded,
            color: const Color(0xFF64B5F6), // Blue
            title: local.added_properties,
            desc: local.recently_listed_today,
            count: stats.newPropertiesToday,
          ),
          _buildActivityItem(
            icon: Icons.check_circle_rounded,
            color: const Color(0xFF81C784), // Green
            title: local.sales_transactions,
            desc: local.sold_properties,
            count: stats.soldPropertiesToday,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required Color color,
    required String title,
    required String desc,
    required int count,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Circle with Number (on the left)
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: color.withOpacity(0.03),
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.08)),
            ),
            child: Center(
              child: Text(
                '$count',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ),
          const Spacer(),
          // 2. Texts (in the middle)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                  color: const Color(0xFF1A1C1E),
                  fontFamily: 'Cairo',
                ),
              ),
              Text(
                desc,
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 11.sp,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          SizedBox(width: 20.w),
          // 3. Line and Icon (on the right)
          Column(
            children: [
              if (!isFirst)
                Container(
                  width: 1.2,
                  height: 12.h,
                  color: const Color(0xFFF0F0F0),
                ),
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20.sp),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 1.2, color: const Color(0xFFF0F0F0)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
