import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/helper/build_error_bar.dart';
import 'package:test_graduation/core/widgets/loading_manager.dart';
import 'package:test_graduation/features/auth/presentation/manager/forget_password_cubit/forget_password_cubit.dart';

import 'forget_password_view_body.dart';

class ForgetPasswordViewBlocBuilder extends StatelessWidget {
  const ForgetPasswordViewBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (context, state) {
        if (state is ForgetPasswordSuccess) {
          showBar(
            context,
            'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني بنجاح! ✅',
          );
          Navigator.pop(context);
        } else if (state is ForgetPasswordFailure) {
          showBar(context, state.errMessage);
        }
      },
      builder: (context, state) {
        // 🔥 التصحيح: استخدام LoadingManager للف الـ Body بسلام ومنع الـ Infinite Size
        return LoadingManager(
          isLoading: state is ForgetPasswordLoading,
          child: const ForgetPasswordViewBody(),
        );
      },
    );
  }
}
