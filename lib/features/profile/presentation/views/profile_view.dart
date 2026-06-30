import 'package:flutter/material.dart';
import 'package:test_graduation/core/utils/colors.dart';

import 'widgets/profile_header.dart';
import 'widgets/profile_menu_section.dart';
import 'widgets/profile_view_bloc_listener.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileViewBlocListener(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: CustomScrollView(
          slivers: [
            // 🔥 استخدام Slivers لتمرير سلس واحترافي
            const SliverToBoxAdapter(child: ProfileHeader()),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            const SliverToBoxAdapter(child: ProfileMenuSection()),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }
}
