import 'package:flutter/material.dart';
import 'package:test_graduation/features/dash_bord/presentation/widgets/main_view.dart';

class DashBoardMobileLayout extends StatelessWidget {
  const DashBoardMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: MainView());
  }
}








  // body: CustomScrollView(
      //   slivers: [
      //     SliverToBoxAdapter(
      //       child: Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             const SizedBox(height: 5),
      //             Header(onPressed: () {}, showTexField: false, title: ''),
      //             const SizedBox(height: 20),
      //             const Center(child: CustomText(text: 'Latest Products')),
      //             const SizedBox(height: 15),
      //             Row(
      //               children: [
      //                 ButtonsWidget(
      //                   onPressed: () {},
      //                   text: 'View All',
      //                   icon: Icons.store,
      //                   backgroundColor: Colors.blue,
      //                 ),
      //                 const Spacer(),
      //                 ButtonsWidget(
      //                   onPressed: () {
      //                     Navigator.pushNamed(
      //                       context,
      //                       UploadProductForm.routeName,
      //                     );
      //                   },
      //                   text: 'Add product',
      //                   icon: Icons.add,
      //                   backgroundColor: Colors.blue,
      //                 ),
      //               ],
      //             ),
      //             const SizedBox(height: 15),
      //           ],
      //         ),
      //       ),
      //     ),
      //     const ProductGridView(),
      //     const OrdersList(),
      //     // SliverFillRemaining(hasScrollBody: true, child: MainView()),
      //   ],
      // ),