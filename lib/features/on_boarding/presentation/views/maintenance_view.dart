import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/profile/presentation/manager/profile_cubit/profile_cubit.dart';

class MaintenanceView extends StatelessWidget {
  const MaintenanceView({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final user = context.watch<ProfileCubit>().user;
    final bool isAdmin = user != null && user.isAdmin;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            // Illustration Container
            Container(
              padding: EdgeInsets.all(40.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F7FF),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.build_circle_rounded,
                size: 120.sp,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 48.h),
            Text(
              local.translate(LangKeys.maintenanceMode),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              local.translate(LangKeys.maintenanceModeDesc),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const Spacer(),
            // Support Action
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Row(
                children: [
                  Icon(Icons.support_agent_rounded, color: AppColors.primary),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      local.translate(LangKeys.contactTechnicalSupport),
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, size: 14.sp, color: Colors.grey),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            // Admin Actions
            if (isAdmin)
              ElevatedButton.icon(
                onPressed: () => context.go(AppRoutes.adminDashboard),
                icon: const Icon(Icons.dashboard_rounded, color: Colors.white),
                label: Text(
                  "العودة للوحة التحكم",
                  style: TextStyle(fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: Size(double.infinity, 50.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
              )
            else
              TextButton(
                onPressed: () => context.push(AppRoutes.loginScreen),
                child: Text(
                  "تسجيل دخول الأدمن",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
