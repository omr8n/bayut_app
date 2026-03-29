import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/utils/service_locator.dart';
import 'package:test_graduation/features/auth/domain/repos/auth_repo.dart';
import 'package:test_graduation/features/auth/presentation/cubits/signin_cubit/signin_cubit.dart';

import 'package:test_graduation/features/auth/presentation/views/widgets/signin_view_body_bloc_consumer.dart';

// شاشة تسجيل الدخول
class SiginView extends StatelessWidget {
  const SiginView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BlocProvider(
        create: (context) => SigninCubit(getIt.get<AuthRepo>()),
        child: SigninViewBodyBlocConsumer(),
      ),
    );
  }
}
