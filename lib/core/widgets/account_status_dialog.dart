import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/core/services/communication_service.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/utils/service_locator.dart';

class AccountStatusDialog extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color iconColor;
  final String? adminPhone;
  final String? actionText;
  final String? secondaryActionText;
  final VoidCallback onSecondaryAction;

  const AccountStatusDialog({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    required this.iconColor,
    this.adminPhone,
    this.actionText,
    this.secondaryActionText,
    required this.onSecondaryAction,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
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
              Icon(
                icon,
                color: iconColor,
                size: 60.sp,
              ),
              SizedBox(height: 16.h),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                  color: iconColor,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  height: 1.6,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 30.h),
              if (adminPhone != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _contactAdmin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    icon: Icon(Icons.chat_bubble_outline_rounded, size: 20.sp),
                    label: Text(
                      actionText ?? "تواصل مع الإدارة عبر واتساب",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 16.h),
              TextButton(
                onPressed: onSecondaryAction,
                child: Text(
                  secondaryActionText ?? "فهمت، متابعة التصفح كزائر",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w600,
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
    if (adminPhone == null) return;
    // استخدام الخدمة المركزية لضمان تنظيف الرقم (0935922621) وفتحه باحترافية
    await getIt<CommunicationService>().sendWhatsApp(
      adminPhone!,
      message: "مرحباً، أود الاستفسار بخصوص حالة حسابي.",
    );
  }
}
