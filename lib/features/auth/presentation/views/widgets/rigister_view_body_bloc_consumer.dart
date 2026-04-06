import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/widgets/loading_manager.dart';
import 'package:test_graduation/features/auth/presentation/views/widgets/register_view_body.dart';
import '../../../../../core/helper/build_error_bar.dart';
import '../../cubits/signup_cubits/signup_cubit.dart';
// import '../../cubits/signup_cubits/signup_state.dart';

class RigisterViewBodyBlocConsumer extends StatelessWidget {
  const RigisterViewBodyBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is SignupSuccess) {
          // 🔥 طلبك: التوجه لشاشة الـ OTP فور نجاح التسجيل
          GoRouter.of(context).pop();
        }

        if (state is SignupFailure) {
          showBar(context, state.message);
        }
      },
      builder: (context, state) {
        return LoadingManager(
          isLoading: state is SignupLoading,
          child: const RegisterViewBody(),
        );
      },
    );
  }
}
