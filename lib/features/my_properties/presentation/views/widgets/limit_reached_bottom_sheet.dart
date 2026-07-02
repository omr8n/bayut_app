import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:provider/provider.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/my_properties/presentation/manager/listing_limit_view_model.dart';

class LimitReachedBottomSheet extends StatefulWidget {
  final Function(int methodIndex) onPayAndPublish;
  final bool isProcessing;

  const LimitReachedBottomSheet({
    super.key,
    required this.onPayAndPublish,
    this.isProcessing = false,
  });

  @override
  State<LimitReachedBottomSheet> createState() => _LimitReachedBottomSheetState();
}

class _LimitReachedBottomSheetState extends State<LimitReachedBottomSheet> {
  int _selectedMethod = 0;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
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

          // Icon/Illustration
          SizedBox(
            height: 100.h,
            child: Icon(
              Icons.rocket_launch_rounded,
              size: 60.sp,
              color: AppColors.primary,
            ),
          ),

          SizedBox(height: 16.h),

          Text(
            local.translate(LangKeys.dailyLimitReached),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 8.h),

          Text(
            local.translate(LangKeys.dailyLimitReachedDesc),
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey[600],
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 20.h),

          // Timer Section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
            ),
            child: Consumer<ListingLimitViewModel>(
              builder: (context, vm, child) {
                return Column(
                  children: [
                    Text(
                      local.translate(LangKeys.nextFreeListingIn),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      vm.formattedRemainingTime,
                      style: TextStyle(
                        fontSize: 22.sp,
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

          SizedBox(height: 20.h),

          // Payment Methods Section (New)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              local.translate(LangKeys.confirmPayment),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          _buildMethodTile(0, local.translate(LangKeys.syrianBankCard)),
          _buildMethodTile(1, local.translate(LangKeys.cashMethod)),

          SizedBox(height: 24.h),

          // Action Button
          SizedBox(
            width: double.infinity,
            height: 54.h,
            child: ElevatedButton(
              onPressed: widget.isProcessing ? null : () => widget.onPayAndPublish(_selectedMethod),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              child: widget.isProcessing
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      local.translate(LangKeys.payAndPublish),
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),

          SizedBox(height: 8.h),

          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              local.translate(LangKeys.cancelAction),
              style: TextStyle(color: Colors.grey[600], fontSize: 13.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodTile(int index, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = _selectedMethod == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = index),
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.05)
              : (isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[50]),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1,
          ),
        ),
        child: RadioListTile(
          value: index,
          groupValue: _selectedMethod,
          activeColor: AppColors.primary,
          contentPadding: EdgeInsets.zero,
          onChanged: (val) => setState(() => _selectedMethod = val as int),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}


extension on EdgeInsets {
  EdgeInsets bottom(double h) => copyWith(bottom: h);
}
