import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:test_graduation/features/my_properties/presentation/manager/my_properties_cubit.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/dashboard_widgets/promotion_sheet.dart';

class MyPropertyItem extends StatelessWidget {
  const MyPropertyItem({super.key, required this.property, this.onSold});

  final PropertyEntity property;
  final VoidCallback? onSold;

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###');
    final locale = AppLocalizations.of(context)!;
    final String displayImage = property.media.isNotEmpty
        ? property.media[0]
        : (property.images.isNotEmpty ? property.images[0] : '');

    return Directionality(
      textDirection: locale.isEnLocale
          ? ui.TextDirection.ltr
          : ui.TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.only(bottom: 20.h, left: 16.w, right: 16.w),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            InkWell(
              onTap: () => GoRouter.of(
                context,
              ).push(AppRoutes.propertyDashboard, extra: property),
              borderRadius: BorderRadius.circular(24.r),
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Property Image
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18.r),
                                child: displayImage.isNotEmpty
                                    ? Image.network(
                                        displayImage,
                                        width: 115.w,
                                        height: 115.w,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            _buildPlaceholder(),
                                      )
                                    : _buildPlaceholder(),
                              ),
                            ),
                            Positioned(
                              top: 6.h,
                              right: 6.w,
                              child: _buildStatusChip(context),
                            ),
                          ],
                        ),
                        SizedBox(width: 16.w),
                        // 2. Property Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                property.title,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.sp,
                                  color: Colors.black87,
                                  letterSpacing: -0.5,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                '${numberFormat.format(property.price)} ${locale.translate(property.currency.trim().toLowerCase())}',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18.sp,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_rounded,
                                    size: 14.sp,
                                    color: Colors.grey.shade400,
                                  ),
                                  SizedBox(width: 4.w),
                                  Expanded(
                                    child: Text(
                                      '${locale.translate(property.governorate)} - ${property.city}',
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today_rounded,
                                        size: 13.sp,
                                        color: Colors.grey.shade400,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        DateFormat(
                                          'yyyy/MM/dd',
                                        ).format(property.createdAt),
                                        style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  _buildViewsBadge(context),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      height: 1,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.grey.withOpacity(0.0),
                            Colors.grey.withOpacity(0.2),
                            Colors.grey.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    // 3. Action Buttons
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildActionItem(
                            context,
                            Icons.edit_note_rounded,
                            locale.translate(LangKeys.editAction),
                            const Color(0xFF2196F3),
                            () => GoRouter.of(context).push(
                              AppRoutes.addPropertyScreen,
                              extra: property,
                            ),
                          ),
                          _buildPremiumActionStatus(context),
                          _buildActionItem(
                            context,
                            Icons.check_circle_outline_rounded,
                            locale.translate(LangKeys.sold),
                            const Color(0xFF00BFA5),
                            () => _showSoldConfirmDialog(
                              context,
                              context.read<MyPropertiesCubit>(),
                            ),
                          ),
                          _buildActionItem(
                            context,
                            Icons.insights_rounded,
                            locale.translate(LangKeys.activityHistory),
                            Colors.grey.shade700,
                            () => GoRouter.of(context).push(
                              AppRoutes.propertyDashboard,
                              extra: property,
                            ),
                          ),
                          _buildActionItem(
                            context,
                            Icons.hourglass_top_rounded,
                            locale.translate(LangKeys.underInstallment),
                            const Color(0xFFFF9100),
                            () => context
                                .read<MyPropertiesCubit>()
                                .updatePropertyStatus(
                                  property,
                                  property.status ==
                                          PropertyStatus.underInstallment
                                      ? PropertyStatus.active
                                      : PropertyStatus.underInstallment,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Delete Button
            Positioned(
              top: -6.h,
              right: locale.isEnLocale ? -6.w : null,
              left: locale.isEnLocale ? null : -6.w,
              child: GestureDetector(
                onTap: () => _showDeleteConfirmDialog(
                  context,
                  context.read<MyPropertiesCubit>(),
                ),
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF5252),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewsBadge(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.remove_red_eye_rounded,
            size: 14.sp,
            color: AppColors.primary,
          ),
          SizedBox(width: 5.w),
          Text(
            '${property.views}',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    String label = property.status.localizedName(context);
    Color color = AppColors.primary;
    if (property.status == PropertyStatus.sold) color = const Color(0xFFFF5252);
    if (property.status == PropertyStatus.underInstallment) {
      color = const Color(0xFFFF9100);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildPremiumActionStatus(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    switch (property.premiumStatus) {
      case PremiumStatus.pending:
        return _buildActionItem(
          context,
          Icons.pending_actions_rounded,
          locale.translate(LangKeys.promotionPending),
          const Color(0xFF1565C0),
          () {},
        );
      case PremiumStatus.active:
        return _buildActionItem(
          context,
          Icons.stars_rounded,
          locale.translate(LangKeys.featuredPropertyLabel),
          const Color(0xFFFFB300),
          null,
        );
      case PremiumStatus.rejected:
        return _buildActionItem(
          context,
          Icons.new_releases_rounded,
          locale.translate(LangKeys.promotionRejected),
          Colors.redAccent,
          () => _showPromotionDialog(context),
        );
      default:
        return _buildActionItem(
          context,
          Icons.auto_awesome_rounded,
          locale.translate(LangKeys.promotionRequest),
          const Color(0xFF673AB7),
          () => _showPromotionDialog(context),
        );
    }
  }

  Widget _buildActionItem(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback? onTap,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              border: Border.all(color: color.withOpacity(0.15)),
              borderRadius: BorderRadius.circular(12.r),
              color: color.withOpacity(0.05),
            ),
            child: Opacity(
              opacity: onTap == null ? 0.6 : 1.0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: color, size: 16.sp),
                  SizedBox(width: 6.w),
                  Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showPromotionDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PromotionSheet(property: property),
    );
  }

  void _showSoldConfirmDialog(BuildContext context, MyPropertiesCubit cubit) {
    final locale = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          locale.translate(LangKeys.updateStatusTitle),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(locale.translate(LangKeys.soldStatusDesc)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              locale.translate(LangKeys.cancelAction),
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF00BFA5),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: TextButton(
              onPressed: () {
                cubit.updatePropertyStatus(property, PropertyStatus.sold);
                if (onSold != null) onSold!();
                Navigator.pop(dialogContext);
              },
              child: Text(
                locale.translate(LangKeys.confirmAction),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, MyPropertiesCubit cubit) {
    final locale = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          locale.translate(LangKeys.deleteProperty),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(locale.translate(LangKeys.deleteConfirmation)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              locale.translate(LangKeys.cancelAction),
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFF5252),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: TextButton(
              onPressed: () {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) cubit.deleteProperty(property.id, user.uid);
                Navigator.pop(dialogContext);
              },
              child: Text(
                locale.translate(LangKeys.delete),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 115.w,
      height: 115.w,
      color: Colors.grey.shade50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_rounded,
            color: Colors.grey.shade300,
            size: 32.sp,
          ),
        ],
      ),
    );
  }
}
