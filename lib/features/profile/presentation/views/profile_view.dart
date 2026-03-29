import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/services/firebase_auth_service.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/utils/service_locator.dart';
import '../manager/profile_cubit/profile_cubit.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_menu_section.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 توفير الكيوبيت مع حقن خدمة Firebase (MVVM)
    return BlocProvider(
      create: (context) => ProfileCubit(getIt.get<FirebaseAuthService>()),
      child: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLogoutSuccess) {
            // ✅ العودة لصفحة الدخول بعد حذف الحساب بنجاح
            GoRouter.of(context).pushReplacement(AppRoutes.loginScreen);
          } else if (state is ProfileLogoutFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errMessage), backgroundColor: Colors.red),
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: const SingleChildScrollView(
            child: Column(
              children: [
                ProfileHeader(),
                SizedBox(height: 20),
                ProfileMenuSection(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
