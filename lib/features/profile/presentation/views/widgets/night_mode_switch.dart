import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/cubits/app_cubit/app_cubit.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/profile/presentation/manager/profile_cubit/profile_cubit.dart';

class NightModeSwitch extends StatelessWidget {
  const NightModeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return BlocBuilder<ProfileCubit, ProfileState>(
      // 🔥 تم إزالة buildWhen لضمان مزامنة حالة المفتاح مع الحالة الفعلية دائماً
      builder: (context, state) {
        final cubit = context.read<ProfileCubit>();
        return SwitchListTile(
          activeColor: AppColors.primary,
          secondary: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.indigo.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.dark_mode_outlined,
              color: Colors.indigo,
              size: 24,
            ),
          ),
          title: Text(
            locale!.translate(LangKeys.darkMode),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : AppColors.textPrimary,
            ),
          ),
          value: context.read<AppCubit>().isDark,
          onChanged: (value) {
            cubit.toggleDarkMode(context, value);
          },
        );
      },
    );
  }
}
