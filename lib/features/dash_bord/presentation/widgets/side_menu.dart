import 'package:flutter/material.dart';

import 'package:iconly/iconly.dart';

import 'drawer_list_tile.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  int selectedIndex = 0; // لتحديد العنصر النشط

  void navigateTo(int index, Widget page) {
    setState(() => selectedIndex = index); // تغيير العنصر النشط
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.7,
      child: ListView(
        children: [
          DrawerHeader(child: Image.asset("assets/images/groceries.png")),

          DrawerListTile(
            title: "Main",
            icon: Icons.home_filled,
            selected: selectedIndex == 0,
            onTap: () {
              // navigateTo(0, const DashboardDesktopLayout());
            },
          ),

          DrawerListTile(
            title: "View all products",
            icon: Icons.store,
            selected: selectedIndex == 1,
            onTap: () {
              //    navigateTo(1, const AllProductsView());
            },
          ),

          DrawerListTile(
            title: "View all orders",
            icon: IconlyBold.bag_2,
            selected: selectedIndex == 2,
            onTap: () {
              //       navigateTo(2, const AllOrdersView());
            },
          ),

          // // ✅ SwitchListTile المعدل لتجنب مشاكل layout
          // BlocBuilder<ThemeCubit, ThemeState>(
          //   builder: (context, state) {
          //     final isDark = state is DarkThemeState;
          //     return SizedBox(
          //       width: double.infinity, // يضمن مساحة أفقية كافية
          //       child: SwitchListTile(
          //         secondary: Icon(
          //           isDark
          //               ? Icons.dark_mode_outlined
          //               : Icons.light_mode_outlined,
          //         ),
          //         title: Text(isDark ? "Dark mode" : "Light mode"),
          //         value: isDark,
          //         onChanged: (value) {
          //           context.read<ThemeCubit>().toggleTheme();
          //         },
          //       ),
          //     );
          //   },
          // ),
          // // BlocBuilder<ThemeCubit, ThemeState>(
          // //   builder: (context, state) {
          // //     final isDark = state is DarkThemeState;
          // //     return ListTile(
          // //       leading: Icon(
          // //         isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
          // //       ),
          // //       title: Text(isDark ? "Dark mode" : "Light mode"),
          // //       trailing: SizedBox(
          // //         width: 50, // تعيين عرض محدد للـ Switch
          // //         child: Switch(
          // //           value: isDark,
          // //           onChanged: (value) {
          // //             context.read<ThemeCubit>().toggleTheme();
          // //           },
          // //         ),
          // //       ),
          // //       contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          // //     );
          // //   },
          // // ),
        ],
      ),
    );
  }
}
