import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/helper/build_error_bar.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/utils/service_locator.dart';
import 'package:test_graduation/core/widgets/loading_manager.dart';
import 'package:test_graduation/features/auth/domain/entites/user_entity.dart';
import 'package:test_graduation/features/profile/presentation/manager/edit_profile_cubit/edit_profile_cubit.dart';
import 'package:test_graduation/features/profile/presentation/manager/profile_cubit/profile_cubit.dart';
import 'widgets/edit_profile/edit_profile_view_body.dart';

class EditProfileView extends StatelessWidget {
  final UserEntity user;
  final bool isPasswordChange;
  const EditProfileView({
    super.key,
    required this.user,
    this.isPasswordChange = false,
  });

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return BlocProvider(
      create: (context) => getIt<EditProfileCubit>(),
      child: BlocConsumer<EditProfileCubit, EditProfileState>(
        listener: (context, state) {
          if (state is EditProfileSuccess) {
            context.read<ProfileCubit>().updateUser(state.user);
            showBar(context, locale!.translate(LangKeys.updateSuccess));
            GoRouter.of(context).pop();
          }
          if (state is EditProfileFailure) {
            showBar(context, state.message);
          }
        },
        builder: (context, state) {
          final isDark = Theme.of(context).brightness == Brightness.dark;

          return LoadingManager(
            isLoading: state is EditProfileLoading,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  isPasswordChange
                      ? locale!.translate(LangKeys.changePassword)
                      : locale!.translate(LangKeys.editProfile),
                ),
                centerTitle: true,
                backgroundColor: isDark ? AppColors.darkCard : AppColors.primary,
                foregroundColor: Colors.white,
              ),
              body: EditProfileViewBody(
                user: user,
                isPasswordChange: isPasswordChange,
              ),
            ),
          );
        },
      ),
    );
  }
}
