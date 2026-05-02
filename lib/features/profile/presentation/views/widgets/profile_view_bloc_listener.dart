import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/features/root/presentation/manager/navigation_cubit.dart';
import '../../manager/profile_cubit/profile_cubit.dart';

class ProfileViewBlocListener extends StatelessWidget {
  const ProfileViewBlocListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLogoutSuccess) {
          // ✅ العودة للشاشة الرئيسية وكأن التطبيق بدأ من جديد (كزائر)
          Future.delayed(const Duration(milliseconds: 50), () {
            if (context.mounted) {
              context.read<NavigationCubit>().changeIndex(0);
              context.goNamed(AppRoutes.mainScreen);
            }
          });
        } else if (state is ProfileLogoutFailure) {
          // ❌ عرض رسالة الخطأ في حال الفشل
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.translate(state.errMessage),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: child,
    );
  }
}
