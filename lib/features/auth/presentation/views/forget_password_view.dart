import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/utils/service_locator.dart';

import '../manager/forget_password_cubit/forget_password_cubit.dart';
import 'widgets/forget_password_view_bloc_builder.dart';

class ForgetPasswordView extends StatelessWidget {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // 🔥 توفير الكيوبيت للشاشة بالكامل (MVVM)
    return BlocProvider(
      create: (context) => getIt.get<ForgetPasswordCubit>(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            localizations.translate(LangKeys.forgotPassword),
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
            onPressed: () => GoRouter.of(context).pop(),
          ),
        ),
        body: const ForgetPasswordViewBlocBuilder(),
      ),
    );
  }
}
