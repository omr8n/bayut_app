import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/helper/my_app_method.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/services/secure_storage_singleton.dart';
import 'package:test_graduation/features/profile/presentation/manager/profile_cubit/profile_cubit.dart';

import 'night_mode_switch.dart';
import 'profile_menu_item.dart';

class ProfileMenuSection extends StatelessWidget {
  const ProfileMenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    // 🔥 توحيد مصدر الحالة: الاعتماد على الـ Cubit فقط لضمان المزامنة
    final user = context.watch<ProfileCubit>().user;
    final bool isLoggedIn = user != null;
    final bool isAdmin = user?.isAdmin ?? false;

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
          if (isAdmin) ...[
            ProfileMenuItem(
              icon: Icons.admin_panel_settings_outlined,
              title: "لوحة التحكم (المدير)",
              iconColor: Colors.deepPurple,
              onTap: () => GoRouter.of(context).push(AppRoutes.adminDashboard),
            ),
            _buildDivider(),
          ],
          ProfileMenuItem(
            icon: Icons.home_work_outlined,
            title: locale!.translate(LangKeys.myProperties),
            iconColor: Colors.blue,
            onTap: () {
              if (isLoggedIn) {
                GoRouter.of(context).push(AppRoutes.myPropertiesScreen);
              } else {
                MyAppMethods.showErrorORWarningDialog(
                  context: context,
                  subtitle: locale.translate(LangKeys.loginRequiredSubtitle),
                  fct: () => GoRouter.of(context).push(AppRoutes.loginScreen),
                );
              }
            },
          ),
          _buildDivider(),
          ProfileMenuItem(
            icon: Icons.favorite_outline,
            title: locale.translate(LangKeys.favorites),
            iconColor: Colors.red,
            onTap: () {
              if (isLoggedIn) {
                GoRouter.of(context).push(AppRoutes.favoritesView);
              } else {
                MyAppMethods.showErrorORWarningDialog(
                  context: context,
                  subtitle: locale.translate(LangKeys.favoritesLoginRequired),
                  fct: () => GoRouter.of(context).push(AppRoutes.loginScreen),
                );
              }
            },
          ),
          _buildDivider(),
          ProfileMenuItem(
            icon: Icons.settings_outlined,
            title: locale.translate(LangKeys.settings),
            iconColor: Colors.orange,
            onTap: () => GoRouter.of(context).push(AppRoutes.settingsView),
          ),
          _buildDivider(),
          const NightModeSwitch(),
          _buildDivider(),
          ProfileMenuItem(
            icon: Icons.menu_book_outlined,
            title: locale.translate(LangKeys.guide),
            iconColor: Colors.pink,
            onTap: () => GoRouter.of(context).push(AppRoutes.guideView),
          ),
          _buildDivider(),
          ProfileMenuItem(
            icon: Icons.policy_outlined,
            title: locale.translate(LangKeys.terms),
            iconColor: Colors.teal,
            onTap: () => GoRouter.of(context).push(AppRoutes.termsView),
          ),
          _buildDivider(),
          ProfileMenuItem(
            icon: Icons.star_outline,
            title: locale.translate(LangKeys.rateApp),
            iconColor: Colors.amber,
            onTap: () {},
          ),
          _buildDivider(),
          ProfileMenuItem(
            icon: Icons.share_outlined,
            title: locale.translate(LangKeys.shareApp),
            iconColor: Colors.lightBlue,
            onTap: () {},
          ),
          _buildDivider(),
          ProfileMenuItem(
            icon: Icons.contact_support_outlined,
            title: locale.translate(LangKeys.contactUs),
            iconColor: Colors.cyan,
            onTap: () => GoRouter.of(context).push(AppRoutes.contactView),
          ),
          _buildDivider(),

          // 🔥 زر تفاعلي: تسجيل دخول (للزائر) أو تسجيل خروج (للمسجل)
          ProfileMenuItem(
            key: ValueKey('login_logout_$isLoggedIn'), // مفتاح فريد لإجبار إعادة البناء
            icon: isLoggedIn ? Icons.logout : Icons.login,
            title: isLoggedIn
                ? locale.translate(LangKeys.logOut)
                : locale.translate(LangKeys.login),
            iconColor: isLoggedIn ? Colors.red : Colors.green,
            onTap: () {
              if (isLoggedIn) {
                MyAppMethods.showErrorORWarningDialog(
                  context: context,
                  subtitle: locale.translate(LangKeys.logoutConfirmation),
                  isError: false,
                  fct: () => context.read<ProfileCubit>().logout(),
                );
              } else {
                // للزائر: انتقال مباشر ومضمون باستخدام push
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
