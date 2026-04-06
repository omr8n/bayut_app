import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/utils/service_locator.dart';
import 'package:test_graduation/core/utils/strings_ar.dart';

import '../manager/forget_password_cubit/forget_password_cubit.dart';
import 'widgets/forget_password_view_bloc_builder.dart';

class ForgetPasswordView extends StatelessWidget {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔥 توفير الكيوبيت للشاشة بالكامل (MVVM)
    return BlocProvider(
      create: (context) => getIt.get<ForgetPasswordCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.forgotPassword),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => GoRouter.of(context).pop(),
          ),
        ),
        body: const ForgetPasswordViewBlocBuilder(),
      ),
    );
  }
}
