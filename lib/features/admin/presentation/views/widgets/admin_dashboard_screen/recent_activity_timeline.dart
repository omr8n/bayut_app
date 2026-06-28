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
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
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
            icon: Icons.pending_actions_rounded,
            color: Colors.deepPurpleAccent, // Distinct color for pending tasks
            title: local.pending_approval,
            desc: local.properties_need_review,
            count: stats.pendingProperties,
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
          ),
          _buildActivityItem(
            icon: Icons.vpn_key_rounded,
            color: Colors.cyan, // Distinct color for rent
            title: local.rent_transactions,
            desc: local.rented_status_desc,
            count: stats.rentedPropertiesToday,
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
          Center(
            child: Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: color.withOpacity(0.05),
                shape: BoxShape.circle,
                border: Border.all(color: color.withOpacity(0.2)),
              ),
              child: Center(
                child: Text(
                  '$count',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 11.sp,
                  ),
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
                  fontSize: 14.sp,
                  color: Colors.black87,
                ),
              ),
              Text(
                desc,
                style: TextStyle(color: Colors.grey.shade400, fontSize: 11.sp),
              ),
            ],
          ),
          SizedBox(width: 16.w),
          // 3. Line and Icon (on the right)
          Column(
            children: [
              if (!isFirst)
                Container(
                  width: 1.5,
                  height: 15.h,
                  color: Colors.grey.shade100,
                ),
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 18.sp),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 1.5, color: Colors.grey.shade100),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
