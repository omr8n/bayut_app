import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

class DashboardActivityTimeline extends StatelessWidget {
  final PropertyEntity property;

  const DashboardActivityTimeline({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final history = property.statusHistory.reversed.toList();
    final locale = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade100,
        ),
      ),
      child: history.isEmpty
          ? Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Text(
                  locale.translate(LangKeys.noResults),
                  style: TextStyle(
                    color: isDark ? AppColors.textSecondaryDark : Colors.grey,
                  ),
                ),
              ),
            )
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: history.length,
              separatorBuilder: (_, __) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                final item = history[index];
                final status = PropertyStatus.values.firstWhere(
                  (e) => e.name == item['status'],
                  orElse: () => PropertyStatus.active,
                );

                DateTime date;
                final ts = item['timestamp'];
                if (ts is Timestamp) {
                  date = ts.toDate();
                } else if (ts is String) {
                  date = DateTime.tryParse(ts) ?? DateTime.now();
                } else {
                  date = DateTime.now();
                }

                return Row(
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        color: _getStatusColor(status),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _getStatusColor(
                              status,
                            ).withValues(alpha: 0.4),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            status.localizedName(context),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          if (item['reason'] != null &&
                              item['reason'].toString().isNotEmpty)
                            Text(
                              item['reason'].toString(),
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : Colors.grey.shade600,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Text(
                      DateFormat('HH:mm  yyyy/MM/dd').format(date),
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : Colors.grey.shade500,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  Color _getStatusColor(PropertyStatus status) {
    switch (status) {
      case PropertyStatus.active:
        return const Color(0xFF1E4C9A);
      case PropertyStatus.sold:
        return Colors.redAccent;
      case PropertyStatus.rented:
        return Colors.purple;
      case PropertyStatus.underInstallment:
        return Colors.orange.shade800;
    }
  }
}
