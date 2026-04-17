// // // import 'package:flutter/material.dart';
// // // import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/product_grid_view.dart';

// // // import '../dash_bord/presentation/widgets/header.dart';
// // // import '../dash_bord/presentation/widgets/products_item.dart';
// // // import '../dash_bord/presentation/widgets/side_menu.dart';

// // // class AllProductsView extends StatefulWidget {
// // //   const AllProductsView({super.key});
// // //   static const String routeName = '/all-products';
// // //   @override
// // //   State<AllProductsView> createState() => _AllProductsViewState();
// // // }

// // // class _AllProductsViewState extends State<AllProductsView> {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     //Size size = Utils(context).getScreenSize;
// // //     return Scaffold(
// // //       //  key: context.read<MenuController>().getgridscaffoldKey,
// // //       drawer: const SideMenu(),
// // //       body: SafeArea(
// // //         child: Row(
// // //           crossAxisAlignment: CrossAxisAlignment.start,
// // //           children: [
// // //             // We want this side menu only for large screen
// // //             //   if (Responsive.isDesktop(context))
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
// // //                       onPressed: () {
// // //                         //   context.read<MenuController>().controlProductsMenu();
// // //                       },
// // //                       title: 'All products',
// // //                     ),
// // //                     const SizedBox(height: 25),

// // //                     ProductGridView(
// // //                       // crossAxisCount: size.width < 650 ? 2 : 4,
// // //                       // childAspectRatio:
// // //                       //     size.width < 650 && size.width > 350 ? 1.1 : 0.8,
// // //                       // isInMain: false,
// // //                     ),

// // //                     ProductItem(
// // //                       // childAspectRatio: size.width < 1400 ? 0.8 : 1.05,
// // //                       // isInMain: false,
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
// // // import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/product_grid_view.dart';
// // import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/product_grid_view_bloc_builder.dart';

// // import '../dash_bord/presentation/widgets/header.dart';
// // // import '../dash_bord/presentation/widgets/products_item.dart';
// // import '../dash_bord/presentation/widgets/side_menu.dart';

// // class AllProductsView extends StatefulWidget {
// //   const AllProductsView({super.key, this.passedCategory});
// //   static const String routeName = '/all-products';
// //   final String? passedCategory;
// //   @override
// //   State<AllProductsView> createState() => _AllProductsViewState();
// // }

// // class _AllProductsViewState extends State<AllProductsView> {
// //   final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
// //   late TextEditingController searchController;
// //   StreamSubscription? _productsSubscription;

// //   @override
// //   void initState() {
// //     super.initState();

// //     searchController = TextEditingController();

// //     /// تحميل المنتجات عند فتح الصفحة
// //     final cubit = context.read<ProductsCubit>();
// //     cubit.getProducts();

// //     /// لو فيه تصنيف محدد ممرر
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       final category = widget.passedCategory;
// //       if (category != null && category.isNotEmpty) {
// //         if (cubit.state is ProductsSuccess) {
// //           cubit.filterByCategory(categoryName: category);
// //         } else {
// //           _productsSubscription = cubit.stream.listen((state) {
// //             if (state is ProductsSuccess) {
// //               cubit.filterByCategory(categoryName: category);
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
// //     return Scaffold(
// //       key: scaffoldKey,
// //       appBar: MediaQuery.sizeOf(context).width < SizeConfig.tablet
// //           ? AppBar(
// //               elevation: 0,
// //               backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
// //               leading: IconButton(
// //                 onPressed: () {
// //                   scaffoldKey.currentState!.openDrawer();
// //                 },
// //                 icon: const Icon(Icons.menu),
// //               ),
// //             )
// //           : null,
// //       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
// //       drawer: MediaQuery.sizeOf(context).width < SizeConfig.tablet
// //           ? const SideMenu()
// //           : null,
// //       //  drawer: const SideMenu(),
// //       // body: SafeArea(
// //       //   child: Row(
// //       //     crossAxisAlignment: CrossAxisAlignment.start,
// //       //     children: [
// //       //       const Expanded(child: SideMenu()),
// //       //       Expanded(
// //       //         flex: 5,
// //       //         child: CustomScrollView(
// //       //           slivers: [
// //       //             SliverToBoxAdapter(
// //       //               child: Column(
// //       //                 children: [
// //       //                   const SizedBox(height: 25),
// //       //                   Header(onPressed: () {}, title: 'All products'),
// //       //                   const SizedBox(height: 25),
// //       //                 ],
// //       //               ),
// //       //             ),

// //       //             // 🟢 الـ Grid
// //       //             ProductGridViewBlocBuilder(
// //       //               searchController: searchController,
// //       //             ),
// //       //             // ProductGridView(),

// //       //             // 🟢 منتج واحد (لو بدك تعرضه عادي)
// //       //             //  SliverToBoxAdapter(child: ProductItem()),
// //       //           ],
// //       //         ),
// //       //       ),
// //       //     ],
// //       //   ),
// //       // ),
// //       body: SafeArea(
// //         child: MediaQuery.sizeOf(context).width >= SizeConfig.tablet
// //             ? Row(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   const Expanded(child: SideMenu()), // الشاشة الكبيرة: يظهر جنب
// //                   Expanded(
// //                     flex: 5,
// //                     child: CustomScrollView(
// //                       slivers: [
// //                         SliverToBoxAdapter(
// //                           child: Column(
// //                             children: [
// //                               const SizedBox(height: 25),
// //                               Header(onPressed: () {}, title: 'All products'),
// //                               const SizedBox(height: 25),
// //                             ],
// //                           ),
// //                         ),
// //                         ProductGridViewBlocBuilder(
// //                           searchController: searchController,
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               )
// //             : CustomScrollView(
// //                 slivers: [
// //                   SliverToBoxAdapter(
// //                     child: Column(
// //                       children: [
// //                         const SizedBox(height: 25),
// //                         Header(
// //                           onPressed: () {
// //                             scaffoldKey.currentState!.openDrawer();
// //                           },
// //                           title: 'All products',
// //                         ),
// //                         const SizedBox(height: 25),
// //                       ],
// //                     ),
// //                   ),
// //                   ProductGridViewBlocBuilder(
// //                     searchController: searchController,
// //                   ),
// //                 ],
// //               ),
// //       ),
// //     );
// //   }
// // }

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:grocery_app_dashboard/core/cubits/products_cubit/products_cubit.dart';
// import 'package:grocery_app_dashboard/core/utils/size_config.dart';
// import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/product_grid_view_bloc_builder.dart';
// import '../dash_bord/presentation/widgets/header.dart';
// import '../dash_bord/presentation/widgets/side_menu.dart';

// class AllProductsView extends StatefulWidget {
//   const AllProductsView({super.key, this.passedCategory});
//   static const String routeName = '/all-products';
//   final String? passedCategory;

//   @override
//   State<AllProductsView> createState() => _AllProductsViewState();
// }

// class _AllProductsViewState extends State<AllProductsView> {
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
//             if (state is ProductsSuccess) {
//               if (mounted) {
//                 cubit.filterByCategory(categoryName: category);
//               }
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
//                       children: [
//                         const SizedBox(height: 25),
//                         Header(
//                           onPressed: () {},
//                           title: 'All products',
//                           showTexField:
//                               MediaQuery.sizeOf(context).width <
//                                   SizeConfig.tablet
//                               ? false
//                               : true,
//                         ),
//                         const SizedBox(height: 25),
//                       ],
//                     ),
//                   ),
//                   // GridView مع BlocBuilder
//                   ProductGridViewBlocBuilder(
//                     searchController: searchController,
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
