import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/my_properties/presentation/manager/listing_limit_view_model.dart';

class LimitReachedBottomSheet extends StatelessWidget {
  final VoidCallback onPayAndPublish;
  final bool isProcessing;

  const LimitReachedBottomSheet({
    super.key,
    required this.onPayAndPublish,
    this.isProcessing = false,
  });

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(bottom: 20.h),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Lottie Animation (Placeholder if not available)
          SizedBox(
            height: 150.h,
            child: Icon(
              Icons.rocket_launch_rounded,
              size: 80.sp,
              color: AppColors.primary,
            ),
            // child: Lottie.asset('assets/lottie/limit_rocket.json', height: 150.h),
          ),

          SizedBox(height: 16.h),

          Text(
            local.translate(LangKeys.dailyLimitReached),
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 12.h),

          Text(
            local.translate(LangKeys.dailyLimitReachedDesc),
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 24.h),

          // Timer Section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(color: AppColors.primary.withOpacity(0.1)),
            ),
            child: Consumer<ListingLimitViewModel>(
              builder: (context, vm, child) {
                return Column(
                  children: [
                    Text(
                      local.translate(LangKeys.nextFreeListingIn),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      vm.formattedRemainingTime,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          SizedBox(height: 24.h),

          Text(
            local.translate(LangKeys.publishNowPersuasive),
            style: TextStyle(
              fontSize: 13.sp,
              fontStyle: FontStyle.italic,
              color: Colors.blueGrey,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 24.h),

          // Action Buttons
          SizedBox(
            width: double.infinity,
            height: 56.h,
            child: ElevatedButton(
              onPressed: isProcessing ? null : onPayAndPublish,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 4,
                shadowColor: AppColors.primary.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: isProcessing
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      local.translate(LangKeys.payAndPublish),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),

          SizedBox(height: 12.h),

          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              local.translate(LangKeys.cancelAction),
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),

          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}

extension on EdgeInsets {
  EdgeInsets bottom(double h) => copyWith(bottom: h);
}
