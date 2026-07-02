import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

class DashboardStatusBanner extends StatelessWidget {
  final PropertyEntity property;
  final int? trendRank;

  const DashboardStatusBanner({
    super.key,
    required this.property,
    this.trendRank,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPremium = property.premiumStatus == PremiumStatus.active &&
        property.premiumExpiryDate != null;
    final bool isTrend = trendRank != null;

    if (!isPremium && !isTrend) return const SizedBox.shrink();

    return Column(
      children: [
        if (isTrend) ...[
          _buildTrendBanner(context),
          SizedBox(height: 12.h),
        ],
        if (isPremium) ...[
          _buildPremiumBanner(context),
          SizedBox(height: 12.h),
        ],
      ],
    );
  }

  Widget _buildTrendBanner(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final trendColor = const Color(0xFFFF6D00);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark
            ? trendColor.withValues(alpha: 0.05)
            : const Color(0xFFFFF9F0),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: trendColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "🔥 ${locale.translate(LangKeys.congratulationsTrend)}",
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? trendColor.withValues(alpha: 0.8) : const Color(0xFFE65100),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.trending_up_rounded,
                color: trendColor,
                size: 24.sp,
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locale.translate(LangKeys.currentRank).replaceFirst('{rank}', '$trendRank'),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? trendColor.withValues(alpha: 0.8) : const Color(0xFFE65100),
                      ),
                    ),
                    Text(
                      locale.translate(LangKeys.mostViewed),
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: isDark ? AppColors.textSecondaryDark : Colors.grey,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat('yyyy/MM/dd').format(DateTime.now().add(const Duration(days: 7))),
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white70 : Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      locale.translate(LangKeys.trendExpiryUntil).replaceAll(': {date}', ''),
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: isDark ? AppColors.textSecondaryDark : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumBanner(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final premiumColor = const Color(0xFF1E4C9A);

    final remaining = property.premiumExpiryDate!.difference(DateTime.now());
    final days = remaining.inDays;
    final hours = remaining.inHours % 24;

    // Assuming 30 days total for progress calculation if not available in entity
    const totalDurationSeconds = 30 * 24 * 60 * 60;
    final progress = (remaining.inSeconds / totalDurationSeconds).clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark
            ? premiumColor.withValues(alpha: 0.1)
            : const Color(0xFFF3F7FA),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: premiumColor.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "🏆 ${locale.translate(LangKeys.premiumStatusActiveLabel)}",
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : premiumColor,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.stars_rounded,
                color: premiumColor,
                size: 24.sp,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locale.translate(LangKeys.expiryDateLabel),
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: isDark ? AppColors.textSecondaryDark : Colors.grey,
                    ),
                  ),
                  Text(
                    DateFormat('yyyy/MM/dd - hh:mm a', locale.locale.languageCode)
                        .format(property.premiumExpiryDate!),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isDark
                      ? premiumColor.withValues(alpha: 0.2)
                      : premiumColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  locale.translate(LangKeys.remainingTime)
                      .replaceFirst('{days}', '$days')
                      .replaceFirst('{hours}', '$hours'),
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : premiumColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: isDark ? Colors.white10 : Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(premiumColor),
              minHeight: 8.h,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                locale.translate(LangKeys.planProMonth),
                style: TextStyle(
                  fontSize: 10.sp,
                  color: isDark ? AppColors.textSecondaryDark : Colors.grey,
                ),
              ),
              Icon(
                Icons.info_outline_rounded,
                size: 14.sp,
                color: isDark ? AppColors.textSecondaryDark : Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
