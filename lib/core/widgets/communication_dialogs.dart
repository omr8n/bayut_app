import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../language/app_localizations.dart';
import '../language/lang_keys.dart';

class CommunicationDialogs {
  static void showWhatsAppFallback(BuildContext context,
      {required VoidCallback onCallPressed}) {
    final loc = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with Title and Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (loc.isEnLocale)
                    Icon(Icons.info_outline,
                        color: Colors.orange, size: 28.sp),
                  if (loc.isEnLocale) SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      loc.translate(LangKeys.whatsappFallbackTitle),
                      textAlign: loc.isEnLocale ? TextAlign.start : TextAlign.end,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF333333),
                      ),
                    ),
                  ),
                  if (!loc.isEnLocale) SizedBox(width: 10.w),
                  if (!loc.isEnLocale)
                    Icon(Icons.info_outline,
                        color: Colors.orange, size: 28.sp),
                ],
              ),
              SizedBox(height: 16.h),
              // Message
              Text(
                loc.translate(LangKeys.whatsappFallbackMessage),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: Colors.grey[600],
                  height: 1.6,
                ),
              ),
              SizedBox(height: 30.h),
              // Actions
              Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        loc.translate(LangKeys.cancel),
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Call Now Button
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        onCallPressed();
                      },
                      icon: Icon(Icons.phone, size: 20.sp),
                      label: Text(
                        loc.translate(LangKeys.callNow),
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1ABC9C),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
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
