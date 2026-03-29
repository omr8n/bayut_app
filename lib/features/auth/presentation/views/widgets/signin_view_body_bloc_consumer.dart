import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/widgets/loading_manager.dart';
import 'package:test_graduation/features/auth/presentation/views/widgets/login_view_body.dart';
import '../../../../../core/helper/build_error_bar.dart';
import '../../cubits/signin_cubit/signin_cubit.dart';

class SigninViewBodyBlocConsumer extends StatelessWidget {
  const SigninViewBodyBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SigninCubit, SigninState>(
      listener: (context, state) {
        if (state is SigninSuccess) {
          // ذكاء: استبدال الشاشة بالكامل للتوجه للرئيسية
          GoRouter.of(context).pushReplacement(AppRoutes.mainScreen);
        }

        if (state is SigninFailure) {
          showBar(context, state.message);
        }
      },
      builder: (context, state) {
        return LoadingManager(
          isLoading: state is SigninLoading,
          child: const LoginViewBody(),
        );
      },
    );
  }
}
