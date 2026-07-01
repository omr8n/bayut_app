import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/utils/service_locator.dart';

import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_cubit.dart';
import 'widgets/admin_properties_widgets/admin_properties_view_body.dart';

class AdminPropertiesView extends StatelessWidget {
  const AdminPropertiesView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocProvider(
      create: (context) => getIt<AdminCubit>()..fetchProperties(),
      child: Scaffold(
        backgroundColor: isDark ? AppColors.darkBackground : const Color(0xFFF8F9FA),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: isDark ? AppColors.darkBackground : const Color(0xFF00142B),
          title: Text(
            AppLocalizations.of(context)!.manage_properties,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => context.pop(),
          ),
        ),
        body: const AdminPropertiesViewBody(),
      ),
    );
  }
}
