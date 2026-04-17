import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/cubits/app_cubit/app_cubit.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/profile/presentation/manager/profile_cubit/profile_cubit.dart';
import 'widgets/profile_menu_item.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(locale!.translate(LangKeys.settings)),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final user = context.read<ProfileCubit>().user;
          final bool isLoggedIn = user != null;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isLoggedIn) ...[
                  _buildSectionTitle(
                    locale.translate(LangKeys.account),
                    locale,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        ProfileMenuItem(
                          icon: Icons.person_outline,
                          title: locale.translate(LangKeys.editProfile),
                          iconColor: AppColors.primary,
                          onTap: () => context.push(
                            AppRoutes.editProfileView,
                            extra: {'user': user, 'isPasswordChange': false},
                          ),
                        ),
                        _buildDivider(),
                        ProfileMenuItem(
                          icon: Icons.lock_outline,
                          title: locale.translate(LangKeys.changePassword),
                          iconColor: Colors.orange,
                          onTap: () => context.push(
                            AppRoutes.editProfileView,
                            extra: {'user': user, 'isPasswordChange': true},
                          ),
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                ],

                _buildSectionTitle(locale.translate(LangKeys.app), locale),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      ProfileMenuItem(
                        icon: Icons.language,
                        title: locale.translate(LangKeys.language),
                        trailing: Text(
                          locale.isEnLocale ? "العربية" : "English",
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        iconColor: Colors.blue,
                        onTap: () {
                          if (locale.isEnLocale) {
                            context.read<AppCubit>().toArabic();
                          } else {
                            context.read<AppCubit>().toEnglish();
                          }
                        },
                      ),
                      _buildDivider(),
                      ProfileMenuItem(
                        icon: Icons.notifications_none,
                        title: locale.translate(LangKeys.notifications),
                        iconColor: Colors.redAccent,
                        onTap: () {},
                        isLast: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                _buildSectionTitle(locale!.translate(LangKeys.about), locale),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      ProfileMenuItem(
                        icon: Icons.info_outline,
                        title: locale.translate(LangKeys.aboutApp),
                        iconColor: Colors.teal,
                        onTap: () {},
                      ),
                      _buildDivider(),
                      ProfileMenuItem(
                        icon: Icons.privacy_tip_outlined,
                        title: locale.translate(LangKeys.privacyPolicy),
                        iconColor: Colors.indigo,
                        onTap: () {},
                        isLast: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title, AppLocalizations locale) {
    return Padding(
      padding: EdgeInsets.only(
        right: locale.isEnLocale ? 0 : 10,
        left: locale.isEnLocale ? 10 : 0,
        bottom: 10,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      indent: 60,
      endIndent: 20,
      color: Colors.grey.withOpacity(0.1),
    );
  }
}
