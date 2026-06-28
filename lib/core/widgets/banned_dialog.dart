import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/language/app_localizations.dart';

class BannedDialog extends StatelessWidget {
  final String adminPhone;
  final VoidCallback onContinueAsGuest;

  const BannedDialog({
    super.key,
    required this.adminPhone,
    required this.onContinueAsGuest,
  });

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false, // يمنع إغلاق النافذة بالرجوع
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        elevation: 10,
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // أيقونة التنبيه الحمراء
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.redAccent,
                size: 60.sp,
              ),
              SizedBox(height: 16.h),

              // العنوان
              Text(
                locale.banned_dialog_title,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.redAccent,
                ),
              ),
              SizedBox(height: 20.h),

              // نص الرسالة كما في الصورة
              Text(
                locale.banned_dialog_content,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  height: 1.6,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 30.h),

              // زر التواصل عبر واتساب (الأخضر)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _contactAdmin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50), // لون واتساب كما في الصورة
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  icon: Icon(Icons.chat_bubble_outline_rounded, size: 20.sp),
                  label: Text(
                    locale.contact_admin_for_help,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),

              // رابط المتابعة كزائر (الأزرق)
              TextButton(
                onPressed: onContinueAsGuest,
                child: Text(
                  locale.continue_as_guest,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _contactAdmin() async {
    final url = "https://wa.me/$adminPhone";
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
