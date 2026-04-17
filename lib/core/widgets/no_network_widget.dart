import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/widgets/custom_primary_button.dart';

class NoNetworkWidget extends StatelessWidget {
  const NoNetworkWidget({super.key, this.onRetry, this.showBanner = false});
  final VoidCallback? onRetry;
  final bool showBanner;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Column(
      children: [
        if (showBanner)
          Container(
            width: double.infinity,
            color: const Color(0xFFD32F2F),
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Text(
              localizations.translate(LangKeys.noInternet),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        Expanded(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.wifi_rounded,
                        size: 140.sp,
                        color: Colors.grey.shade200,
                      ),
                      Positioned(
                        bottom: 20.h,
                        right: 20.w,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.priority_high_rounded,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),
                  Text(
                    localizations.translate(LangKeys.noInternet),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    localizations.translate(LangKeys.noInternet),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  if (onRetry != null) ...[
                    SizedBox(height: 40.h),
                    SizedBox(
                      width: double.infinity,
                      child: CustomPriamryButton(
                        title: localizations.translate(LangKeys.retry),
                        onPressed: onRetry,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
