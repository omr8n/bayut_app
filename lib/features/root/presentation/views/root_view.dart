import 'package:flutter/material.dart';

import 'package:test_graduation/features/home/presentation/view/home_view.dart';
import 'package:test_graduation/features/my_properties/presentation/views/my_properties_view.dart';
import 'package:test_graduation/features/profile/presentation/views/profile_view.dart';
import 'package:test_graduation/features/search/presentation/veiw/search_screen.dart';

import 'package:test_graduation/features/root/presentation/views/widgets/root_view_bloc_builder.dart';

class RootView extends StatelessWidget {
  const RootView({super.key});

  final List<Widget> screens = const [
    HomeScreen(),
    SearchScreen(),
    MyPropertiesScreen(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return RootViewBlocBuilder(screens: screens);
  }
}
