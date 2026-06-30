import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_cubit.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminPropertyActions extends StatelessWidget {
  const AdminPropertyActions({super.key, required this.property});

  final PropertyEntity property;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Premium Review Button (shown only if status is pending)
        if (property.premiumStatus == PremiumStatus.pending)
          _buildActionButton(
            context,
            Icons.stars_rounded,
            Colors.orange,
            () => _showPremiumReviewDialog(context, local),
            tooltip: local.review_premium_request_tooltip,
          ),
        const SizedBox(width: 8),

        // 1. Contact Owner Button
        _buildActionButton(
          context,
          Icons.chat,
          Colors.green,
          () => _contactOwner(property.whatsapp),
          tooltip: local.contact_owner_tooltip,
        ),
        const SizedBox(width: 8),

        // 2. Promotion Button
        _buildActionButton(
          context,
          Icons.star,
          property.isFeatured ? AppColors.featured : Colors.grey.shade400,
          () {
            context.read<AdminCubit>().togglePropertyFeatured(
              property.id,
              !property.isFeatured,
              property.sellerId,
            );
          },
          tooltip: property.isFeatured
              ? local.unfeature_property_tooltip
              : local.feature_property_tooltip,
        ),
        const SizedBox(width: 8),

        // 3. Status Button (Accept / Reject)
        _buildActionButton(
          context,
          property.isApproved ? Icons.check_circle : Icons.cancel,
          property.isApproved ? AppColors.success : AppColors.error,
          () => _showStatusDialog(context, local),
          tooltip: property.isApproved
              ? local.manage_approval_tooltip
              : local.review_request_tooltip,
        ),
        const SizedBox(width: 8),

        // 4. Delete Button (Spam/Severe violations only)
        _buildActionButton(
          context,
          Icons.delete_sweep,
          Colors.redAccent,
          () => _showDeleteDialog(context, local),
          tooltip: local.permanent_delete_tooltip,
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    Color color,
    VoidCallback onTap, {
    String? tooltip,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Tooltip(
        message: tooltip ?? '',
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }

  void _contactOwner(String phone) async {
    final url = "https://wa.me/$phone";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  void _showStatusDialog(BuildContext context, AppLocalizations local) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          property.isApproved
              ? local.disable_property_title
              : local.approve_property_title,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              property.isApproved
                  ? local.hide_property_msg
                  : local.show_property_msg,
            ),
            if (!property.isApproved) ...[
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: local.add_note_to_seller_hint,
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ],
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
              context.read<AdminCubit>().togglePropertyApproval(
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

  void _showPremiumReviewDialog(BuildContext context, AppLocalizations local) {
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
                  context.read<AdminCubit>().handlePremiumRequest(
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
                  context.read<AdminCubit>().handlePremiumRequest(
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

  void _showDeleteDialog(BuildContext context, AppLocalizations local) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(local.permanent_delete),
        content: Text(local.delete_property_confirm_msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(local.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<AdminCubit>().deleteProperty(
                property.id,
                property.sellerId,
              );
              Navigator.pop(dialogContext);
            },
            child: Text(local.confirm_delete),
          ),
        ],
      ),
    );
  }
}
