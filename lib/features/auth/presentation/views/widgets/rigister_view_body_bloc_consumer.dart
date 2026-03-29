import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/helper/build_error_bar.dart';
import 'package:test_graduation/core/widgets/loading_manager.dart';

import '../../cubits/signup_cubits/signup_cubit.dart';
import 'register_view_body.dart';

class RegisterViewBodyBlocConsumer extends StatelessWidget {
  const RegisterViewBodyBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is SignupSuccess) {
          Navigator.pop(context);
        }
        if (state is SignupFailure) {
          showBar(context, state.message);
        }
      },
      builder: (context, state) {
        return LoadingManager(
          isLoading: state is SignupLoading,
          child: const RegisterViewBody(), // <<< مافي ScrollView هون
        );
      },
    );
  }
}
