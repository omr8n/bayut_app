// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:grocery_app_dashboard/core/cubits/products_cubit/products_cubit.dart';
// import 'package:grocery_app_dashboard/core/utils/size_config.dart';
// import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/product_grid_view_bloc_builder.dart';

// import '../../../inner_screens/add_product_view.dart';
// import 'buttons.dart';
// import 'custom_text.dart';
// import 'header.dart';
// import 'orders_list.dart';
// // import 'product_grid_view.dart';

// class MainView extends StatefulWidget {
//   const MainView({super.key});
//   static const String routeName = '/main_view';

//   @override
//   State<MainView> createState() => _MainViewState();
// }

// class _MainViewState extends State<MainView> {
//   late TextEditingController searchController;
//   StreamSubscription? _productsSubscription;

//   @override
//   void initState() {
//     super.initState();

//     searchController = TextEditingController();

//     context.read<ProductsCubit>().getProducts();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final category = widget.passedCategory;
//       if (category != null && category.isNotEmpty) {
//         final cubit = context.read<ProductsCubit>();

//         if (cubit.state is ProductsSuccess) {
//           cubit.filterByCategory(categoryName: category);
//         } else {
//           _productsSubscription = cubit.stream.listen((state) {
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
//     return CustomScrollView(
//       physics: const BouncingScrollPhysics(),
//       slivers: [
//         /// Header + Latest Products + Buttons
//         SliverToBoxAdapter(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 5),
//                 Header(
//                   title: 'Dashboard',
//                   showTexField:
//                       MediaQuery.sizeOf(context).width < SizeConfig.tablet
//                       ? false
//                       : true,
//                   onPressed: () {},
//                 ),
//                 const SizedBox(height: 20),
//                 Center(child: const CustomText(text: 'Latest Products')),
//                 const SizedBox(height: 15),
//                 Row(
//                   children: [
//                     ButtonsWidget(
//                       onPressed: () {},
//                       text: 'View All',
//                       icon: Icons.store,
//                       backgroundColor: Colors.blue,
//                     ),
//                     const Spacer(),
//                     ButtonsWidget(
//                       onPressed: () {
//                         Navigator.pushNamed(context, AddProductView.routeName);
//                       },
//                       text: 'Add product',
//                       icon: Icons.add,
//                       backgroundColor: Colors.blue,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 15),
//               ],
//             ),
//           ),
//         ),

//         /// Grid المنتجات (Sliver مستقل)
//         ProductGridViewBlocBuilder(searchController: searchController),

//         /// الطلبات (Sliver مستقل)
//         OrdersList(),
//       ],
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/utils/size_config.dart';
// import 'package:grocery_app_dashboard/core/cubits/add_product_cubit/add_product_cubit.dart';

// import 'package:grocery_app_dashboard/core/cubits/products_cubit/products_cubit.dart';
// import 'package:grocery_app_dashboard/core/repos/add_product_repo/add_products_repo.dart';
// import 'package:grocery_app_dashboard/core/repos/images_repo/images_repo.dart';
// import 'package:grocery_app_dashboard/core/services/get_it_service.dart';
// // import 'package:grocery_app_dashboard/core/cubits/products_cubit/products_state.dart';
// import 'package:grocery_app_dashboard/core/utils/size_config.dart';
// import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/orders_view_body_builder.dart';

// import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/product_grid_view_bloc_builder.dart';
// import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/update_order_builder.dart';
// import '../../../inner_screens/add_product_view.dart';

import 'buttons.dart';
import 'custom_text.dart';
import 'header.dart';
import 'orders_list.dart';

class MainView extends StatefulWidget {
  const MainView({super.key, this.passedCategory});
  static const String routeName = '/main_view';

  /// تصنيف اختياري (لو المستخدم دخل من تبويب تصنيفات معينة)
  final String? passedCategory;

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late TextEditingController searchController;
  StreamSubscription? _productsSubscription;
  @override
  void initState() {
    super.initState();

    searchController = TextEditingController();
    // final cubit = context.read<ProductsCubit>();
    // cubit.getProducts();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // final category = widget.passedCategory;
      // if (category != null && category.isNotEmpty) {
      //   if (!mounted) return; // تأكد أن الـ Widget ما انحذف
      //   if (cubit.state is ProductsSuccess) {
      //     cubit.filterByCategory(categoryName: category);
      //   } else {
      //     _productsSubscription = cubit.stream.listen((state) {
      //       if (!mounted) return; // حماية إضافية
      //       if (state is ProductsSuccess) {
      //         cubit.filterByCategory(categoryName: category);
      //         _productsSubscription?.cancel();
      //         _productsSubscription = null;
      //       }
      //     });
      //   }
      // }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _productsSubscription?.cancel();
    super.dispose();
  }

  // @override
  // void initState() {
  //   super.initState();

  //   searchController = TextEditingController();

  //   /// تحميل المنتجات عند فتح الصفحة
  //   final cubit = context.read<ProductsCubit>();
  //   cubit.getProducts();

  //   /// لو فيه تصنيف محدد ممرر
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     final category = widget.passedCategory;
  //     if (category != null && category.isNotEmpty) {
  //       if (cubit.state is ProductsSuccess) {
  //         cubit.filterByCategory(categoryName: category);
  //       } else {
  //         _productsSubscription = cubit.stream.listen((state) {
  //           if (state is ProductsSuccess) {
  //             cubit.filterByCategory(categoryName: category);
  //             _productsSubscription?.cancel();
  //             _productsSubscription = null;
  //           }
  //         });
  //       }
  //     }
  //   });
  // }

  // @override
  // void dispose() {
  //   searchController.dispose();
  //   _productsSubscription?.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        /// Header + Latest Products + Buttons
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Header(
                  title: 'Dashboard',
                  showTexField:
                      MediaQuery.sizeOf(context).width < SizeConfig.tablet
                      ? false
                      : true,

                  onChanged: (value) {
                    // final cubit = context.read<ProductsCubit>();
                    // final state = cubit.state;

                    // if (value.isEmpty) {
                    //   cubit.resetProducts();
                    // } else if (state is ProductsSuccess) {
                    //   cubit.searchProducts(
                    //     searchText: value,
                    //     productsList: state.products,
                    //   );
                    // }
                  },

                  onPressed: () {
                    setState(() {
                      searchController.clear();
                      FocusScope.of(context).unfocus();
                      //     context.read<ProductsCubit>().resetProducts();
                    });
                  },
                ),
                const SizedBox(height: 20),
                const Center(child: CustomText(text: 'Latest Products')),
                const SizedBox(height: 15),
                Row(
                  children: [
                    ButtonsWidget(
                      onPressed: () {
                        // TODO: افتح صفحة فيها كل المنتجات
                      },
                      text: 'View All',
                      icon: Icons.store,
                      backgroundColor: Colors.blue,
                    ),
                    const Spacer(),
                    ButtonsWidget(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => BlocProvider(
                        //       create: (_) => AddProductCubit(
                        //         getIt.get<ImagesRepo>(),
                        //         getIt.get<AddProductsRepo>(),
                        //       ),
                        //       child: const AddProductView(),
                        //     ),
                        //   ),
                        // );

                        //   Navigator.pushNamed(context, AddProductView.routeName);
                      },
                      text: 'Add product',
                      icon: Icons.add,
                      backgroundColor: Colors.blue,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),

        /// Grid المنتجات (Sliver مستقل)
        /// ProductGridViewBlocBuilder(searchController: searchController),
        // BlocBuilder<ProductsCubit, ProductsState>(
        //   builder: (context, state) {
        //     if (searchController.text.isNotEmpty &&
        //         state is ProductsSuccess &&
        //         state.products.isEmpty) {
        //       return const Center(
        //         child: CustomText(text: "No results found", fontSize: 40),
        //       );
        //     }
        //     return ProductGridViewBlocBuilder(
        //       searchController: searchController,
        //     );
        //   },
        // ),

        /// الطلبات (Sliver مستقل)
        /// الطلبات (Sliver مستقل)
        // SliverToBoxAdapter(
        //   child: UpdateOrderBuilder(child: OrdersViewBodyBuilder()),
        // ),
      ],
    );
  }
}
