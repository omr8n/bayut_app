import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_cubit.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';

class AdminPropertyCard extends StatelessWidget {
  final PropertyEntity property;
  final AdminCubit adminCubit;
  final int? trendRank; // 🔥 Trend Rank

  const AdminPropertyCard({
    super.key,
    required this.property,
    required this.adminCubit,
    this.trendRank,
  });

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: Theme.of(context).brightness == Brightness.dark
                  ? 0.2
                  : 0.04,
            ),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // 1. Header (Seller Name + Status Badges)
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                Icon(
                  Icons.person_outline_rounded,
                  color: Colors.blue.shade800,
                  size: 18.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  flex: 2,
                  child: Text(
                    property.sellerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.blue.shade900,
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: false, // Changed to false to handle RTL correctly
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (trendRank != null)
                          _statusBadge(
                            local.trend_label,
                            const Color(0xFFFFF3E0),
                            const Color(0xFFFF9800),
                          ),
                        if (trendRank != null) SizedBox(width: 6.w),
                        if (property.premiumStatus == PremiumStatus.pending)
                          _statusBadge(
                            local.premium_requests,
                            const Color(0xFFE3F2FD),
                            const Color(0xFF2196F3),
                          ),
                        if (property.premiumStatus == PremiumStatus.pending)
                          SizedBox(width: 6.w),
                        _statusBadge(
                          local.approved_label,
                          const Color(0xFFE8F5E9),
                          const Color(0xFF4CAF50),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, indent: 12, endIndent: 12),

          // 2. Content (Two-column system: Text & Image)
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              // يتبع اتجاه اللغة؛ في العربي تكون الصورة على اليمين كما طلب المستخدم
              children: [
                // Image with Star Badge
                Stack(
                  alignment: AlignmentDirectional
                      .topStart, // Consistent with Directionality
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: CachedNetworkImage(
                        imageUrl: property.images.isNotEmpty
                            ? property.images[0]
                            : '',
                        width:
                            90.w, // Slightly smaller to give more room to text
                        height: 90.w,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Container(color: Colors.grey.shade100),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey.shade100,
                          child: const Icon(
                            Icons.image_not_supported_rounded,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    if (property.isFeatured ||
                        property.premiumStatus == PremiumStatus.active)
                      PositionedDirectional(
                        // Uses start/end instead of left/right
                        top: 6.h,
                        start: 6.w,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 12.sp,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(width: 12.w), // Smaller spacing
                // Left Side in RTL: Texts (Flexible area)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        property.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 14.sp,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? AppColors.textSecondaryDark
                                : Colors.grey,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              "${property.city} ، ${property.governorate}",
                              maxLines: 1,
                              overflow: TextOverflow
                                  .visible, // Changed to allow soft wrap if needed or just visible
                              style: TextStyle(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? AppColors.textSecondaryDark
                                    : Colors.grey,
                                fontSize:
                                    11.sp, // Slightly smaller for better fit
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "${property.currency} ${property.price}",
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : const Color(0xFF1E4C9A), // Royal Blue
                            fontWeight: FontWeight.w900,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Icon(
                            Icons.visibility_rounded,
                            size: 14.sp,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? AppColors.textSecondaryDark
                                : Colors.grey,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "${property.views}",
                            style: TextStyle(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.textSecondaryDark
                                  : Colors.grey,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 3. Special Status Banners (Featured / Trend)
          if (property.premiumStatus == PremiumStatus.active &&
              property.premiumExpiryDate != null)
            _buildCountdownBanner(context),

          if (trendRank != null) _buildTrendBanner(context),

          // 4. Date Bar
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.darkSurface
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_month_outlined,
                  size: 14,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.textSecondaryDark
                      : Colors.grey,
                ),
                SizedBox(width: 8.w),
                Text(
                  "${local.last_update.replaceFirst('{date}', DateFormat('d MMMM yyyy - hh:mm a', local.locale.languageCode).format(property.createdAt))}",
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.textSecondaryDark
                        : Colors.grey,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          const Divider(height: 1),

          // 5. Bottom Buttons
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircularAction(
                  Icons.delete_sweep_rounded,
                  Colors.redAccent,
                  () => _showDeleteDialog(context),
                  tooltip: local.delete,
                ),
                _buildCircularAction(
                  property.isApproved
                      ? Icons.check_circle_rounded
                      : Icons.cancel_rounded,
                  property.isApproved ? Colors.green : Colors.red,
                  () => _showStatusDialog(context),
                  tooltip: local.status,
                ),
                _buildCircularAction(
                  Icons.stars_rounded,
                  property.premiumStatus == PremiumStatus.pending
                      ? Colors.orange
                      : (property.isFeatured
                            ? Colors.blue
                            : Colors.grey.shade400),
                  () {
                    if (property.premiumStatus == PremiumStatus.pending) {
                      _showPremiumReviewDialog(context);
                    } else {
                      adminCubit.togglePropertyFeatured(
                        property.id,
                        !property.isFeatured,
                        property.sellerId,
                      );
                    }
                  },
                  tooltip: local.featured_label,
                ),
                _buildCircularAction(
                  Icons.chat_bubble_rounded,
                  Colors.green.shade600,
                  () => _contactOwner(context, property.whatsapp),
                  tooltip: local.whatsapp,
                ),
                _buildCircularAction(
                  Icons.open_in_full_rounded,
                  Colors.blue,
                  () {
                    context.push(
                      AppRoutes.propertyDetailsScreen,
                      extra: property,
                    );
                  },
                  tooltip: local.view_all,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularAction(
    IconData icon,
    Color color,
    VoidCallback onTap, {
    String? tooltip,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Tooltip(
        message: tooltip ?? '',
        child: Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20.sp),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          local.translate('permanent_delete'),
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          local.delete_property_confirm,
          style: TextStyle(
            color: isDark ? Colors.grey.shade400 : Colors.black54,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              local.cancel,
              style: const TextStyle(color: Colors.blue),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            onPressed: () {
              adminCubit.deleteProperty(property.id, property.sellerId);
              Navigator.pop(dialogContext);
            },
            child: Text(
              local.confirm_delete,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showStatusDialog(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          property.isApproved ? local.disable_property : local.approve_property,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          property.isApproved
              ? local.hide_property_confirm
              : local.show_property_confirm,
          style: TextStyle(
            color: isDark ? Colors.grey.shade400 : Colors.black54,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              local.cancel,
              style: const TextStyle(color: Colors.blue),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: property.isApproved
                  ? Colors.orangeAccent
                  : Colors.green.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            onPressed: () {
              adminCubit.togglePropertyApproval(
                property.id,
                !property.isApproved,
                property.sellerId,
              );
              Navigator.pop(dialogContext);
            },
            child: Text(
              property.isApproved
                  ? local.disable_now
                  : local.approve_and_publish,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPremiumReviewDialog(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          local.review_premium_request,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.blue, size: 20),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    "مراجعة طلب التميز الذكي",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              "سيقوم النظام تلقائياً بتفعيل المدة والمبلغ المطلوبين من قبل المستخدم وتنزيلها في المحفظة المالية.",
              style: TextStyle(
                color: isDark ? Colors.grey.shade300 : Colors.black87,
                fontSize: 13.sp,
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.person_pin_circle_outlined,
                    color: Colors.blue.shade400,
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    property.sellerName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        actions: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  adminCubit.handlePremiumRequest(
                    propertyId: property.id,
                    sellerId: property.sellerId,
                    isApproved: false,
                  );
                  Navigator.pop(dialogContext);
                },
                child: Text(
                  local.reject_request,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  adminCubit.handlePremiumRequest(
                    propertyId: property.id,
                    sellerId: property.sellerId,
                    isApproved: true,
                    sellerName: property.sellerName,
                  );
                  Navigator.pop(dialogContext);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.blue.shade100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  local.approve_and_activate,
                  style: const TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _contactOwner(BuildContext context, String phone) async {
    final url = "https://wa.me/$phone";

    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {
        _showContactErrorAlert(context, phone);
      }
    } catch (e) {
      _showContactErrorAlert(context, phone);
    }
  }

  void _showContactErrorAlert(BuildContext context, String phone) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("تعذر فتح واتساب"),
        content: Text(
          "لم نتمكن من فتح تطبيق واتساب تلقائياً. يمكنك الاتصال بالرقم مباشرة:\n\n$phone",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("إغلاق"),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              final telUrl = "tel:$phone";
              if (await canLaunchUrl(Uri.parse(telUrl))) {
                await launchUrl(Uri.parse(telUrl));
              }
              if (dialogContext.mounted) Navigator.pop(dialogContext);
            },
            icon: const Icon(Icons.phone),
            label: const Text("اتصال"),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String label, Color bgColor, Color textColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCountdownBanner(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final remaining = property.premiumExpiryDate!.difference(DateTime.now());
    final days = remaining.inDays;
    final hours = remaining.inHours % 24;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  local.remaining_time
                      .replaceFirst('{days}', '$days')
                      .replaceFirst('{hours}', '$hours'),
                  style: TextStyle(
                    color: Colors.orange.shade900,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                local.premium_end,
                style: TextStyle(
                  color: Colors.orange.shade300,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                DateFormat(
                  'd MMMM yyyy - hh:mm a',
                  local.locale.languageCode,
                ).format(property.premiumExpiryDate!),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.sp),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          LinearProgressIndicator(
            value: (remaining.inSeconds / (30 * 24 * 60 * 60)).clamp(0, 1),
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange.shade300),
            minHeight: 4.h,
          ),
        ],
      ),
    );
  }

  Widget _buildTrendBanner(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Container(
      margin: EdgeInsetsDirectional.only(start: 16.w, end: 16.w, bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              local.translate(LangKeys.highActivity),
              style: TextStyle(
                color: Colors.orange.shade700,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
          Text(
            local
                .translate(LangKeys.trendRank)
                .replaceFirst('{rank}', '$trendRank'),
            style: TextStyle(
              color: Colors.orange.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(width: 8.w),
          Icon(
            Icons.trending_up_rounded,
            color: Colors.orange.shade700,
            size: 18.sp,
          ),
        ],
      ),
    );
  }
}
