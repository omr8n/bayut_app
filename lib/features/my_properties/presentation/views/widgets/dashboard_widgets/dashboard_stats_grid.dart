import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:test_graduation/features/my_properties/presentation/manager/my_properties_cubit.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/dashboard_widgets/promotion_sheet.dart';

class DashboardStatsGrid extends StatelessWidget {
  final PropertyEntity property;

  const DashboardStatsGrid({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.4,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        // 1. كرت المشاهدات
        _StatCard(
          title: locale.translate(LangKeys.totalViews),
          value: '${property.views}',
          icon: Icons.visibility_rounded,
          color: const Color(0xFF1E4C9A),
        ),
        // 2. كرت الحالة الحالية
        _StatCard(
          title: locale.translate(LangKeys.currentStatus),
          value: property.status.localizedName(context),
          icon: Icons.info_outline_rounded,
          color: _getStatusColor(property.status),
        ),
        // 3. كرت حالة التميز (متغير الألوان)
        _buildPremiumStatCard(context),
        // 4. كرت نوع العقار
        _StatCard(
          title: locale.translate(LangKeys.propertyType),
          value: property.type.localizedName(context),
          icon: Icons.home_work_rounded,
          color: const Color(0xFF1E4C9A),
        ),
      ],
    );
  }

  Widget _buildPremiumStatCard(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    switch (property.premiumStatus) {
      case PremiumStatus.pending:
        return _StatCard(
          title: locale.translate(LangKeys.featuredStatus),
          value: locale.translate(LangKeys.promotionPending),
          icon: Icons.access_time_filled_rounded,
          color: const Color(0xFF1E4C9A),
        );
      case PremiumStatus.active:
        return _StatCard(
          title: locale.translate(LangKeys.featuredStatus),
          value: locale.translate(LangKeys.featuredPropertyLabel),
          icon: Icons.stars_rounded,
          color: Colors.orange.shade700,
        );
      case PremiumStatus.rejected:
        return _StatCard(
          title: locale.translate(LangKeys.featuredStatus),
          value: locale.translate(LangKeys.promotionRejected),
          icon: Icons.error_outline_rounded,
          color: Colors.redAccent,
          isError: true,
          onTap: () => _showPromotionSheet(context),
        );
      default:
        return _StatCard(
          title: locale.translate(LangKeys.featuredStatus),
          value: locale.translate(LangKeys.promotionRequest),
          icon: Icons.rocket_launch_rounded,
          color: const Color(0xFFD4AF37), // Golden color for request
          isPremiumAction: true,
          onTap: () => _showPromotionSheet(context),
        );
    }
  }

  void _showPromotionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PromotionSheet(property: property),
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

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final bool isPremiumAction;
  final bool isError;
  final VoidCallback? onTap;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.isPremiumAction = false,
    this.isError = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isError
              ? color.withOpacity(0.05)
              : (isDark ? AppColors.darkSurface : Colors.white),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isError
                ? color.withOpacity(0.2)
                : (isDark ? Colors.white10 : Colors.grey.shade100),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.05 : 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24.sp),
                if (isError || isPremiumAction)
                  Icon(
                    locale.isEnLocale
                        ? Icons.arrow_forward_ios_rounded
                        : Icons.arrow_back_ios_rounded,
                    size: 14.sp,
                    color: color,
                  ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              value,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: isError || isPremiumAction ? color : (isDark ? Colors.white : Colors.black87),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              title,
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 10.sp, color: isDark ? AppColors.textSecondaryDark : Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
