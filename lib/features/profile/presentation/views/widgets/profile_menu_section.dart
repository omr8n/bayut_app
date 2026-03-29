import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/helper/my_app_method.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/services/secure_storage_singleton.dart';
import 'package:test_graduation/features/my_properties/presentation/views/my_properties_view.dart';
import 'package:test_graduation/features/profile/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:test_graduation/features/profile/presentation/views/contact_view.dart';
import 'package:test_graduation/features/profile/presentation/views/guide_view.dart';
import 'package:test_graduation/features/profile/presentation/views/settings_view.dart';
import 'package:test_graduation/features/profile/presentation/views/terms_view.dart';

import 'night_mode_switch.dart';
import 'profile_menu_item.dart';

class ProfileMenuSection extends StatelessWidget {
  const ProfileMenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 فحص حالة تسجيل الدخول
    final bool isLoggedIn = SecureStorage.isLoggedIn;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          ProfileMenuItem(
            icon: Icons.home_work_outlined,
            title: 'عقاراتي',
            iconColor: Colors.blue,
            onTap: () {
              if (isLoggedIn) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyPropertiesScreen()),
                );
              } else {
                MyAppMethods.showErrorORWarningDialog(
                  context: context,
                  subtitle: 'يرجى تسجيل الدخول أولاً للوصول لعقاراتك',
                  fct: () => GoRouter.of(context).push(AppRoutes.loginScreen),
                );
              }
            },
          ),
          _buildDivider(),
          ProfileMenuItem(
            icon: Icons.settings_outlined,
            title: 'الإعدادات',
            iconColor: Colors.orange,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsView()),
            ),
          ),
          _buildDivider(),
          const NightModeSwitch(),
          _buildDivider(),
          ProfileMenuItem(
            icon: Icons.menu_book_outlined,
            title: 'دليل استخدام التطبيق',
            iconColor: Colors.pink,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GuideView()),
            ),
          ),
          _buildDivider(),
          ProfileMenuItem(
            icon: Icons.policy_outlined,
            title: 'شروط الاستخدام',
            iconColor: Colors.teal,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TermsView()),
            ),
          ),
          _buildDivider(),
          ProfileMenuItem(
            icon: Icons.star_outline,
            title: 'تقييم التطبيق',
            iconColor: Colors.amber,
            onTap: () {},
          ),
          _buildDivider(),
          ProfileMenuItem(
            icon: Icons.share_outlined,
            title: 'مشاركة التطبيق',
            iconColor: Colors.lightBlue,
            onTap: () {},
          ),
          _buildDivider(),
          ProfileMenuItem(
            icon: Icons.contact_support_outlined,
            title: 'اتصل بنا وتابعنا',
            iconColor: Colors.cyan,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ContactView()),
            ),
          ),
          _buildDivider(),
          
          // 🔥 زر تفاعلي: تسجيل دخول (للزائر) أو تسجيل خروج (للمسجل)
          ProfileMenuItem(
            icon: isLoggedIn ? Icons.logout : Icons.login,
            title: isLoggedIn ? 'تسجيل الخروج' : 'تسجيل الدخول',
            iconColor: isLoggedIn ? Colors.red : Colors.green,
            onTap: () {
              if (isLoggedIn) {
                MyAppMethods.showErrorORWarningDialog(
                  context: context,
                  subtitle: 'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
                  isError: false,
                  fct: () => context.read<ProfileCubit>().logout(),
                );
              } else {
                GoRouter.of(context).push(AppRoutes.loginScreen);
              }
            },
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      indent: 70,
      endIndent: 20,
      color: Colors.grey.withValues(alpha: 0.1),
    );
  }
}
