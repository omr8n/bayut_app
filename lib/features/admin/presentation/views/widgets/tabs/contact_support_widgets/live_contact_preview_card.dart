import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/models/app_config_model.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class LiveContactPreviewCard extends StatelessWidget {
  final AppConfigModel config;

  const LiveContactPreviewCard({super.key, required this.config});

  Future<void> _handleAction(
    BuildContext context,
    String? value,
    String type,
  ) async {
    if (value == null || value.trim().isEmpty) {
      _showComingSoonAlert(context);
      return;
    }

    Uri? uri;
    LaunchMode mode = LaunchMode.externalApplication;

    switch (type) {
      case 'email':
        uri = Uri.parse('mailto:$value');
        break;
      case 'phone':
        uri = Uri.parse('tel:$value');
        break;
      case 'whatsapp':
        // WhatsApp needs country code. If starts with 09, replace with 9639
        String cleanNumber = value.replaceAll(RegExp(r'[^0-9]'), '');
        if (cleanNumber.startsWith('09')) {
          cleanNumber = '963${cleanNumber.substring(1)}';
        } else if (cleanNumber.startsWith('9')) {
          cleanNumber = '963$cleanNumber';
        }
        uri = Uri.parse('https://wa.me/$cleanNumber');
        break;
      case 'facebook':
      case 'instagram':
        uri = Uri.parse(value);
        break;
    }

    if (uri != null) {
      try {
        final canLaunch = await canLaunchUrl(uri);
        if (canLaunch) {
          await launchUrl(uri, mode: mode);
        } else {
          _showComingSoonAlert(context);
        }
      } catch (e) {
        _showComingSoonAlert(context);
      }
    }
  }

  void _showComingSoonAlert(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.rocket_launch_rounded, color: Colors.white),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                locale.translate(LangKeys.linkComingSoon),
                style: const TextStyle(fontFamily: 'Cairo'),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        margin: EdgeInsets.all(16.w),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: .05)
              : const Color(0xFFF0F0F0),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.remove_red_eye_outlined,
                size: 20.sp,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
              SizedBox(width: 10.w),
              Text(
                local.isEnLocale ? "Live Preview" : "معاينة مباشرة",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                  fontFamily: 'Cairo',
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      local.isEnLocale ? "Active" : "نشط",
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          _buildPreviewItem(
            context: context,
            icon: Icons.email_rounded,
            title: local.translate(LangKeys.supportEmailLabel),
            value: config.contactEmail.isEmpty ? "---" : config.contactEmail,
            color: const Color(0xFF5C6BC0),
            onTap: () => _handleAction(context, config.contactEmail, 'email'),
          ),
          SizedBox(height: 12.h),
          _buildPreviewItem(
            context: context,
            icon: Icons.phone_android_rounded,
            title: local.translate(LangKeys.supportPhoneLabel),
            value: config.contactPhone.isEmpty ? "---" : config.contactPhone,
            color: const Color(0xFF42A5F5),
            onTap: () => _handleAction(context, config.contactPhone, 'phone'),
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialIcon(
                icon: Icons.chat_bubble_rounded,
                color: Colors.green,
                onTap: () =>
                    _handleAction(context, config.whatsappNumber, 'whatsapp'),
              ),
              SizedBox(width: 20.w),
              _buildSocialIcon(
                icon: Icons.camera_alt_rounded,
                color: const Color(0xFFE4405F),
                onTap: () =>
                    _handleAction(context, config.instagramUrl, 'instagram'),
              ),
              SizedBox(width: 20.w),
              _buildSocialIcon(
                icon: Icons.facebook,
                color: const Color(0xFF1877F2),
                onTap: () =>
                    _handleAction(context, config.facebookUrl, 'facebook'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.03)
              : const Color(0xFFFBFBFE),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : const Color(0xFFF0F0F0),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: color, size: 18.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: isDark ? Colors.white60 : Colors.grey.shade500,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF2C3E50),
                      fontFamily: 'Cairo',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 10.sp,
              color: isDark ? Colors.white24 : Colors.grey.shade300,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50.r),
      child: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
        ),
        child: Center(
          child: Icon(icon, color: color, size: 20.sp),
        ),
      ),
    );
  }
}
