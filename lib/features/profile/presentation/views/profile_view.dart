import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/utils/service_locator.dart';
import '../manager/profile_cubit/profile_cubit.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_menu_section.dart';
import 'widgets/profile_view_bloc_listener.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileCubit>()..getUserInfo(),
      child: const ProfileViewBlocListener(
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            slivers: [
              // 🔥 استخدام Slivers لتمرير سلس واحترافي
              SliverToBoxAdapter(
                child: ProfileHeader(),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),
              SliverToBoxAdapter(
                child: ProfileMenuSection(),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: 40),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
