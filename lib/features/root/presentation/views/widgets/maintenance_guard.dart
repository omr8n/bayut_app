import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_settings_cubit/admin_settings_cubit.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_settings_cubit/admin_settings_state.dart';
import 'package:test_graduation/features/on_boarding/presentation/views/maintenance_view.dart';
import 'package:test_graduation/features/profile/presentation/manager/profile_cubit/profile_cubit.dart';

class MaintenanceGuard extends StatelessWidget {
  final Widget child;

  const MaintenanceGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminSettingsCubit, AdminSettingsState>(
      builder: (context, settingsState) {
        final config = context.read<AdminSettingsCubit>().currentConfig;

        if (config != null && config.maintenanceMode) {
          final user = context.watch<ProfileCubit>().user;

          // إذا كان المستخدم أدمن، نسمح له بالمرور مع إظهار شريط تحذيري
          if (user != null && user.isAdmin) {
            return Stack(
              children: [
                child,
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top,
                        bottom: 4.h,
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.9),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.build_rounded,
                              size: 14.sp,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "وضع الصيانة مفعل - المستخدمون محجوبون حالياً",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          // لغير الأدمن (مستخدم عادي أو زائر)، نظهر شاشة الصيانة
          return const MaintenanceView();
        }

        // إذا كان وضع الصيانة مغلقاً، نظهر التطبيق بشكل طبيعي
        return child;
      },
    );
  }
}
