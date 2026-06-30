import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/utils/service_locator.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_settings_cubit/admin_settings_cubit.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_settings_cubit/admin_settings_state.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactView extends StatelessWidget {
  const ContactView({super.key});

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

    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: mode);
    } else {
      _showComingSoonAlert(context);
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
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showAlert(BuildContext context, String type) {
    final local = AppLocalizations.of(context)!;
    String message = local.isEnLocale
        ? "This account is not currently available."
        : "هذا الحساب غير متوفر حالياً.";

    if (type == 'whatsapp')
      message = local.translate(LangKeys.whatsappFallbackMessage);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) => getIt<AdminSettingsCubit>()..getSettings(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FB),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            localizations.translate(LangKeys.contactUsFollowUs),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<AdminSettingsCubit, AdminSettingsState>(
          builder: (context, state) {
            if (state is AdminSettingsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            String email = '';
            String phone = '';
            String whatsapp = '';
            String facebook = '';
            String instagram = '';

            if (state is AdminSettingsLoaded) {
              email = state.config.contactEmail;
              phone = state.config.contactPhone;
              whatsapp = state.config.whatsappNumber;
              facebook = state.config.facebookUrl;
              instagram = state.config.instagramUrl;
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  Text(
                    localizations.translate(LangKeys.contactUsHelpText),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32.h),

                  // 1. Email Section
                  _buildPrimaryContact(
                    context: context,
                    icon: Icons.email_outlined,
                    title: localizations.translate(LangKeys.supportEmail),
                    value: email,
                    color: const Color(0xFF5C6BC0),
                    onTap: () => _handleAction(context, email, 'email'),
                  ),
                  SizedBox(height: 16.h),

                  // 2. Phone Section
                  _buildPrimaryContact(
                    context: context,
                    icon: Icons.phone_android_outlined,
                    title: localizations.translate(LangKeys.supportPhoneLabel),
                    value: phone,
                    color: const Color(0xFF42A5F5),
                    onTap: () => _handleAction(context, phone, 'phone'),
                  ),

                  SizedBox(height: 48.h),
                  const Divider(),
                  SizedBox(height: 32.h),

                  Text(
                    localizations.translate(LangKeys.followUsSocial),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // 3. Social Circles Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialCircle(
                        icon: Icons.facebook,
                        color: const Color(0xFF1877F2),
                        onTap: () =>
                            _handleAction(context, facebook, 'facebook'),
                      ),
                      SizedBox(width: 20.w),
                      _buildSocialCircle(
                        icon: Icons.camera_alt_outlined,
                        color: const Color(0xFFE4405F),
                        onTap: () =>
                            _handleAction(context, instagram, 'instagram'),
                      ),
                      SizedBox(width: 20.w),
                      _buildSocialCircle(
                        icon: Icons.chat_bubble_outline_rounded,
                        color: Colors.green,
                        onTap: () =>
                            _handleAction(context, whatsapp, 'whatsapp'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPrimaryContact({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: color, size: 24.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    value.isEmpty
                        ? (AppLocalizations.of(context)!.isEnLocale
                              ? "Not available"
                              : "غير متوفر")
                        : value,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14.sp,
              color: Colors.grey.shade300,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialCircle({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50.r),
      child: Container(
        width: 60.w,
        height: 60.w,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
        ),
        child: Center(
          child: Icon(icon, color: color, size: 28.sp),
        ),
      ),
    );
  }
}
