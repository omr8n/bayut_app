import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import '../../manager/profile_cubit/profile_cubit.dart';

class ProfileViewBlocListener extends StatelessWidget {
  const ProfileViewBlocListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLogoutSuccess) {
          // ✅ التوجه لصفحة الدخول فور نجاح تسجيل الخروج
          GoRouter.of(context).pushReplacementNamed(AppRoutes.loginScreen);
        } else if (state is ProfileLogoutFailure) {
          // ❌ عرض رسالة الخطأ في حال الفشل
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: child,
    );
  }
}
