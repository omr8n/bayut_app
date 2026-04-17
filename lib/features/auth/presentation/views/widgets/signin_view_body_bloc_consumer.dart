import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/widgets/loading_manager.dart';
import 'package:test_graduation/features/auth/presentation/views/widgets/login_view_body.dart';
import 'package:test_graduation/features/profile/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:test_graduation/features/root/presentation/manager/navigation_cubit.dart';
import '../../../../../core/helper/build_error_bar.dart';
import '../../cubits/signin_cubit/signin_cubit.dart';

class SigninViewBodyBlocConsumer extends StatelessWidget {
  const SigninViewBodyBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SigninCubit, SigninState>(
      listener: (context, state) {
        if (state is SigninSuccess) {
          // تأكيد تحديث البيانات وتصفير أي حالات قديمة
          context.read<ProfileCubit>().getUserInfo();
          // 🔥 ضمان العودة للتبويب الأول (Home) في الـ RootView
          context.read<NavigationCubit>().changeIndex(0);

          // الانتقال للهوم وتصفير المسارات السابقة
          context.go(AppRoutes.mainScreen);
        }

        if (state is SigninFailure) {
          final translatedMessage =
              AppLocalizations.of(context)!.translate(state.message);
          showBar(context, translatedMessage);
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
