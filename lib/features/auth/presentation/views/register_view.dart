import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/repos/media_repo/media_repo.dart';
import 'package:test_graduation/core/utils/service_locator.dart';
import 'package:test_graduation/features/auth/domain/repos/auth_repo.dart';
import 'package:test_graduation/features/auth/presentation/cubits/signup_cubits/signup_cubit.dart';

import 'package:test_graduation/features/auth/presentation/views/widgets/rigister_view_body_bloc_consumer.dart';

// شاشة إنشاء حساب
class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BlocProvider(
        create: (context) =>
            SignupCubit(getIt.get<AuthRepo>(), getIt.get<MediaRepo>()),
        child: Scaffold(body: RigisterViewBodyBlocConsumer()),
      ),

      //  const Scaffold(
      //   // body: Padding(
      //   //   padding: EdgeInsets.all(8.0),
      //   //   child: SingleChildScrollView(
      //   //     child: RigisterViewBody(),
      //   //   ),
      //   // ),
      // ),
    );
  }
}
