import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/widgets/custom_primary_button.dart';

class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.imagePath,
    this.title,
  });

  final String message;
  final String? title;
  final VoidCallback? onRetry;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image/Icon Section
            if (imagePath != null)
              Image.asset(
                imagePath!,
                height: 180.h,
                width: 180.w,
              )
            else
              Icon(
                Icons.wifi_off_rounded,
                size: 120.sp,
                color: Colors.grey.shade300,
              ),
            
            SizedBox(height: 32.h),

            // Title
            Text(
              title ?? 'لا يوجد اتصال بالإنترنت',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            SizedBox(height: 16.h),

            // Message/Description
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),

            if (onRetry != null) ...[
              SizedBox(height: 48.h),
              SizedBox(
                width: double.infinity,
                child: CustomPriamryButton(
                  title: 'إعادة المحاولة',
                  onPressed: onRetry,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
