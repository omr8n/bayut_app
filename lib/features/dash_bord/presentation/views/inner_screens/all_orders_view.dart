// // // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:flutter/material.dart';
// // // // import 'package:grocery_admin_panel/widgets/orders_list.dart';
// // // // import 'package:provider/provider.dart';

// // // import '../dash_bord/presentation/widgets/header.dart';
// // // import '../dash_bord/presentation/widgets/orders_list.dart';
// // // import '../dash_bord/presentation/widgets/side_menu.dart';

// // // class AllOrdersView extends StatefulWidget {
// // //   const AllOrdersView({super.key});
// // //   static const String routeName = '/all-orders';
// // //   @override
// // //   State<AllOrdersView> createState() => _AllOrdersViewState();
// // // }

// // // class _AllOrdersViewState extends State<AllOrdersView> {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     //  Size size = Utils(context).getScreenSize;
// // //     return Scaffold(
// // //       //    key: context.read<MenuController>().getOrdersScaffoldKey,
// // //       drawer: const SideMenu(),
// // //       body: SafeArea(
// // //         child: Row(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             // We want this side menu only for large screen
// // //             const Expanded(
// // //               // default flex = 1
// // //               // and it takes 1/6 part of the screen
// // //               child: SideMenu(),
// // //             ),
// // //             Expanded(
// // //               // It takes 5/6 part of the screen
// // //               flex: 5,
// // //               child: SingleChildScrollView(
// // //                 controller: ScrollController(),
// // //                 child: Column(
// // //                   children: [
// // //                     const SizedBox(height: 25),
// // //                     Header(
// // //                       showTexField: false,
// // //                       onPressed: () {
// // //                         //    context.read<MenuController>().controlAllOrder();
// // //                       },
// // //                       title: 'All Orders',
// // //                     ),
// // //                     const SizedBox(height: 20),
// // //                     const Padding(
// // //                       padding: EdgeInsets.all(8.0),
// // //                       child: OrdersList(isInDashboard: false),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // import 'dart:async';

// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:grocery_app_dashboard/core/cubits/products_cubit/products_cubit.dart';
// // import 'package:grocery_app_dashboard/core/utils/size_config.dart';
// // import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/orders_view_body_builder.dart';
// // import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/update_order_builder.dart';

// // import '../dash_bord/presentation/widgets/header.dart';
// // import '../dash_bord/presentation/widgets/orders_list.dart';
// // import '../dash_bord/presentation/widgets/side_menu.dart';

// // class AllOrdersView extends StatefulWidget {
// //   const AllOrdersView({super.key, this.passedCategory});
// //   static const String routeName = '/all-orders';
// //   final String? passedCategory;
// //   @override
// //   State<AllOrdersView> createState() => _AllOrdersViewState();
// // }

// // class _AllOrdersViewState extends State<AllOrdersView> {
// //   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
// //   late TextEditingController searchController;
// //   StreamSubscription? _productsSubscription;

// //   @override
// //   void initState() {
// //     super.initState();

// //     searchController = TextEditingController();

// //     final cubit = context.read<ProductsCubit>();
// //     cubit.getProducts();

// //     // إذا فيه تصنيف ممرر
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       final category = widget.passedCategory;
// //       if (category != null && category.isNotEmpty) {
// //         if (cubit.state is ProductsSuccess) {
// //           if (mounted) cubit.filterByCategory(categoryName: category);
// //         } else {
// //           _productsSubscription = cubit.stream.listen((state) {
// //             if (state is ProductsSuccess) {
// //               if (mounted) {
// //                 cubit.filterByCategory(categoryName: category);
// //               }
// //               _productsSubscription?.cancel();
// //               _productsSubscription = null;
// //             }
// //           });
// //         }
// //       }
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     searchController.dispose();
// //     _productsSubscription?.cancel();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final isTablet = MediaQuery.sizeOf(context).width >= SizeConfig.tablet;

// //     return Scaffold(
// //       key: scaffoldKey,
// //       appBar: !isTablet
// //           ? AppBar(
// //               elevation: 0,
// //               backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
// //               leading: IconButton(
// //                 onPressed: () => scaffoldKey.currentState?.openDrawer(),
// //                 icon: const Icon(Icons.menu),
// //               ),
// //             )
// //           : null,
// //       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
// //       drawer: !isTablet ? const SideMenu() : null,
// //       // drawer: const SideMenu(),
// //       body: SafeArea(
// //         child: Row(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             // Side menu for large screen
// //             const Expanded(child: SideMenu()),
// //             Expanded(
// //               flex: 5,
// //               child: CustomScrollView(
// //                 slivers: [
// //                   SliverToBoxAdapter(
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         const SizedBox(height: 25),
// //                         Header(
// //                           showTexField:
// //                               MediaQuery.sizeOf(context).width <
// //                                   SizeConfig.tablet
// //                               ? false
// //                               : true,
// //                           onPressed: () {
// //                             // context.read<MenuController>().controlAllOrder();
// //                           },
// //                           title: 'All Orders',
// //                         ),
// //                         const SizedBox(height: 20),
// //                       ],
// //                     ),
// //                   ),
// //                   // هنا بيجي OrdersList كـ SliverList
// //                   UpdateOrderBuilder(child: OrdersViewBodyBuilder()),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// // all_orders_view.dart
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:grocery_app_dashboard/core/cubits/products_cubit/products_cubit.dart';
// import 'package:grocery_app_dashboard/core/utils/size_config.dart';
// import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/orders_view_body_builder.dart';
// import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/update_order_builder.dart';
// import '../dash_bord/presentation/widgets/header.dart';
// import '../dash_bord/presentation/widgets/side_menu.dart';

// class AllOrdersView extends StatefulWidget {
//   const AllOrdersView({super.key, this.passedCategory});
//   static const String routeName = '/all-orders';
//   final String? passedCategory;

//   @override
//   State<AllOrdersView> createState() => _AllOrdersViewState();
// }

// class _AllOrdersViewState extends State<AllOrdersView> {
//   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
//   late TextEditingController searchController;
//   StreamSubscription? _productsSubscription;

//   @override
//   void initState() {
//     super.initState();

//     searchController = TextEditingController();
//     final cubit = context.read<ProductsCubit>();
//     cubit.getProducts();

//     // إذا فيه تصنيف ممرر
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final category = widget.passedCategory;
//       if (category != null && category.isNotEmpty) {
//         if (cubit.state is ProductsSuccess) {
//           if (mounted) cubit.filterByCategory(categoryName: category);
//         } else {
//           _productsSubscription = cubit.stream.listen((state) {
//             if (!mounted) return; // ✅ حماية من disposed
//             if (state is ProductsSuccess) {
//               cubit.filterByCategory(categoryName: category);
//               _productsSubscription?.cancel();
//               _productsSubscription = null;
//             }
//           });
//         }
//       }
//     });
//   }

//   @override
//   void dispose() {
//     searchController.dispose();
//     _productsSubscription?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isTablet = MediaQuery.sizeOf(context).width >= SizeConfig.tablet;

//     return Scaffold(
//       key: scaffoldKey,
//       appBar: !isTablet
//           ? AppBar(
//               elevation: 0,
//               backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
//               leading: IconButton(
//                 onPressed: () => scaffoldKey.currentState?.openDrawer(),
//                 icon: const Icon(Icons.menu),
//               ),
//             )
//           : null,
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       drawer: !isTablet ? const SideMenu() : null,
//       body: SafeArea(
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (isTablet) const Expanded(child: SideMenu()),
//             Expanded(
//               flex: 5,
//               child: CustomScrollView(
//                 slivers: [
//                   SliverToBoxAdapter(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(height: 25),
//                         Header(
//                           showTexField:
//                               MediaQuery.sizeOf(context).width <
//                                   SizeConfig.tablet
//                               ? false
//                               : true,
//                           onPressed: () {},
//                           title: 'All Orders',
//                         ),
//                         const SizedBox(height: 20),
//                       ],
//                     ),
//                   ),
//                   // Orders List مع حماية ضد disposed
//                   SliverToBoxAdapter(
//                     child: UpdateOrderBuilder(child: OrdersViewBodyBuilder()),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
