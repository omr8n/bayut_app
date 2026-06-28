import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../language/app_localizations.dart';
import '../language/lang_keys.dart';
import '../utils/colors.dart';

class CommunicationDialogs {
  static void showWhatsAppFallback(BuildContext context, {required VoidCallback onCallPressed}) {
    final loc = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                   Icon(Icons.info_outline, color: Colors.orange, size: 28.sp),
                   SizedBox(width: 12.w),
                   Text(
                    loc.translate(LangKeys.whatsappFallbackTitle),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Text(
                loc.translate(LangKeys.whatsappFallbackMessage),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      loc.translate(LangKeys.cancel),
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      onCallPressed();
                    },
                    icon: Icon(Icons.phone, size: 18.sp),
                    label: Text(loc.translate(LangKeys.callNow)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
