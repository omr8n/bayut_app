import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/widgets/custom_primary_button.dart';

class NoNetworkScreen extends StatelessWidget {
  const NoNetworkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            // أيقونة الواي فاي مع علامة التعجب (نفس الصورة)
            Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.wifi_rounded,
                  size: 150.sp,
                  color: Colors.grey.shade300,
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.priority_high_rounded,
                      color: Colors.white,
                      size: 30.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40.h),
            Text(
              'لا يوجد اتصال بالإنترنت',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'حدثت مشكلة في الاتصال بالإنترنت. الرجاء الضغط على إعادة المحاولة للاتصال مرة أخرى.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: CustomPriamryButton(
                title: 'إعادة المحاولة',
                onPressed: () {
                  // سيقوم النظام تلقائياً بالتحديث عند عودة الإنترنت
                },
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
