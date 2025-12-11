import 'package:flutter/material.dart';
import 'package:test_graduation/features/home/presentation/view/home_view.dart';
import 'package:test_graduation/features/auth/presentation/views/login_view.dart';
import 'package:test_graduation/features/my_properties/presentation/views/my_properties_view.dart';
import 'package:test_graduation/features/search/presentation/veiw/search_screen.dart';
import 'package:test_graduation/features/root/presentation/views/widgets/custom_bottom_navigation_bar.dart';

class RootView extends StatefulWidget {
  static const routeName = '/';
  const RootView({super.key});

  @override
  State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
  late PageController controller;
  int currentView = 0;

  List<Widget> screens = [
    HomeScreen(),
    SearchScreen(),
    MyPropertiesScreen(),
    LoginView(),
  ];

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: currentView);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        onPageChanged: (index) {
          setState(() => currentView = index);
        },
        children: screens,
      ),
      bottomNavigationBar: CustomBottonNavigationBar(
        selectedIndex: currentView,
        onTap: (index) {
          setState(() => currentView = index);
          controller.animateToPage(
            currentView,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }
}
