import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_cubit.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'admin_property_actions.dart'; // 🔥 Using new actions

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
            color: Colors.black.withOpacity(
              Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.04,
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
                Text(
                  property.sellerName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.blue.shade900,
                  ),
                ),
                const Spacer(),
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
          const Divider(height: 1, indent: 12, endIndent: 12),

          // 2. Content (Two-column system: Text & Image)
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Side: Texts
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        property.title,
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
                          Text(
                            "${property.city} ، ${property.governorate}",
                            style: TextStyle(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.textSecondaryDark
                                  : Colors.grey,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        "${property.currency} ${property.price}",
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : const Color(0xFF1E4C9A), // Royal Blue
                          fontWeight: FontWeight.w900,
                          fontSize: 16.sp,
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
                SizedBox(width: 16.w),
                // Right Side: Image with Star Badge
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: CachedNetworkImage(
                        imageUrl: property.images.isNotEmpty
                            ? property.images[0]
                            : '',
                        width: 100.w,
                        height: 100.w,
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
                      Positioned(
                        top: 8.h,
                        left: 8.w,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 14.sp,
                          ),
                        ),
                      ),
                  ],
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
                  () => _contactOwner(property.whatsapp),
                  tooltip: local.whatsapp,
                ),
                _buildCircularAction(
                  Icons.open_in_full_rounded,
                  Colors.blue,
                  () {},
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
            color: color.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20.sp),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(local.permanent_delete),
        content: Text(local.delete_property_confirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(local.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              adminCubit.deleteProperty(property.id, property.sellerId);
              Navigator.pop(dialogContext);
            },
            child: Text(local.confirm_delete),
          ),
        ],
      ),
    );
  }

  void _showStatusDialog(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          property.isApproved ? local.disable_property : local.approve_property,
        ),
        content: Text(
          property.isApproved
              ? local.hide_property_confirm
              : local.show_property_confirm,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(local.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: property.isApproved
                  ? Colors.orange
                  : Colors.green,
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
            ),
          ),
        ],
      ),
    );
  }

  void _showPremiumReviewDialog(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    // We use the Method in Actions to ensure consistency
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          local.review_premium_request,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              local.selected_plan_pro,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SizedBox(height: 12.h),
            Text(
              local.mock_payment_confirmed,
              style: const TextStyle(color: Colors.black87, fontSize: 13),
            ),
            SizedBox(height: 20.h),
            Text(
              local.premium_duration_days,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: TextEditingController(text: '30'),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
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
                    days: 30,
                    amount: 750000,
                    sellerName: property.sellerName,
                  );
                  Navigator.pop(dialogContext);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.grey.shade200),
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

  void _contactOwner(String phone) async {
    final url = "https://wa.me/$phone";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
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
        color: Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.orange.withOpacity(0.1)),
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
        color: Colors.orange.withOpacity(0.03),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              local.high_activity,
              style: TextStyle(
                color: Colors.orange.shade700,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
          Text(
            local.trend_rank_label.replaceFirst('{rank}', '$trendRank'),
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
