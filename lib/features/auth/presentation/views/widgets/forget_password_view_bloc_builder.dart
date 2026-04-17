import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/helper/build_error_bar.dart';
import 'package:test_graduation/core/widgets/loading_manager.dart';
import 'package:test_graduation/features/auth/presentation/manager/forget_password_cubit/forget_password_cubit.dart';

import 'forget_password_view_body.dart';

class ForgetPasswordViewBlocBuilder extends StatelessWidget {
  const ForgetPasswordViewBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (context, state) {
        if (state is ForgetPasswordSuccess) {
          showBar(
            context,
            localizations.translate(LangKeys.resetLinkSent),
          );
          Navigator.pop(context);
        } else if (state is ForgetPasswordFailure) {
          final translatedMessage =
              localizations.translate(state.errMessage);
          showBar(context, translatedMessage);
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
