import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/profile/presentation/manager/profile_cubit/profile_cubit.dart';

class NightModeSwitch extends StatelessWidget {
  const NightModeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) => current is ProfileDarkModeToggled,
      builder: (context, state) {
        final cubit = context.read<ProfileCubit>();
        return SwitchListTile(
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
          title: const Text(
            'الوضع الليلي',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          value: cubit.isDarkMode,
          onChanged: (value) {
            cubit.toggleDarkMode(value);
          },
        );
      },
    );
  }
}
