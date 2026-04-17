import 'package:flutter/material.dart';
import 'package:test_graduation/core/utils/colors.dart';

import 'widgets/profile_header.dart';
import 'widgets/profile_menu_section.dart';
import 'widgets/profile_view_bloc_listener.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileViewBlocListener(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: CustomScrollView(
          slivers: [
            // 🔥 استخدام Slivers لتمرير سلس واحترافي
            SliverToBoxAdapter(child: ProfileHeader()),
            SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverToBoxAdapter(child: ProfileMenuSection()),
            SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }
}
