import 'package:flutter/material.dart';

import 'package:test_graduation/features/dash_bord/presentation/widgets/dashboard_tablet_layout.dart';

// import 'buttons.dart';
// import 'custom_text.dart';
// import 'orders_list.dart';
// import 'product_grid_view.dart';
// import 'header.dart';

// class DashboardDesktopLayout extends StatelessWidget {
//   const DashboardDesktopLayout({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Row(
//         children: [
//           const Expanded(child: SideMenu()),
//           const SizedBox(width: 8),
//           MainView(),
//         ],
//       ),
//     );
//   }
// }

//     // Expanded(
//           //   flex: 4,
//           //   child: CustomScrollView(
//           //     physics: const BouncingScrollPhysics(),
//           //     slivers: [
//           //       /// Header + Latest Products + Buttons
//           //       SliverToBoxAdapter(
//           //         child: Padding(
//           //           padding: const EdgeInsets.all(8.0),
//           //           child: Column(
//           //             crossAxisAlignment: CrossAxisAlignment.start,
//           //             children: [
//           //               const SizedBox(height: 5),
//           //               Header(title: 'Dashboard', onPressed: () {}),
//           //               const SizedBox(height: 20),
//           //               Center(child: const CustomText(text: 'Latest Products')),
//           //               const SizedBox(height: 15),
//           //               Row(
//           //                 children: [
//           //                   ButtonsWidget(
//           //                     onPressed: () {},
//           //                     text: 'View All',
//           //                     icon: Icons.store,
//           //                     backgroundColor: Colors.blue,
//           //                   ),
//           //                   const Spacer(),
//           //                   ButtonsWidget(
//           //                     onPressed: () {},
//           //                     text: 'Add product',
//           //                     icon: Icons.add,
//           //                     backgroundColor: Colors.blue,
//           //                   ),
//           //                 ],
//           //               ),
//           //               const SizedBox(height: 15),
//           //             ],
//           //           ),
//           //         ),
//           //       ),

//           //       /// Grid المنتجات (Sliver مستقل)
//           //       ProductGridView(),

//           //       /// الطلبات (Sliver مستقل)
//           //       OrdersList(),
//           //     ],
//           //   ),
//           // ),

class DashboardDesktopLayout extends StatelessWidget {
  const DashboardDesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DashBoardTabletLayout(flex: 4),
      // body: Row(
      //   children: [
      //     const Expanded(child: SideMenu()),
      //     const SizedBox(width: 8),
      //     const Expanded(
      //       flex: 4,
      //       child: MainView(), // 👈 صار Expanded هنا
      //     ),
      //   ],
      // ),
    );
  }
}
