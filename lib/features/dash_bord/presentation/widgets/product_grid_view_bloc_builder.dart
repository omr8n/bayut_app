// // // // // import 'package:e_commerce_shop_smart/Features/edit/domain/entities/product_entity.dart';
// // // // // import 'package:e_commerce_shop_smart/Features/search/presentation/views/widgets/products_grid_view.dart';
// // // // // import 'package:e_commerce_shop_smart/core/helper/my_app_method.dart';
// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:flutter_bloc/flutter_bloc.dart';
// // // // // import 'package:skeletonizer/skeletonizer.dart';

// // // // // import '../../../../../core/cubits/products_cubit/products_cubit.dart';

// // // // // class ProductGridViewBlocBuilder extends StatelessWidget {
// // // // //   const ProductGridViewBlocBuilder({
// // // // //     super.key,
// // // // //     required this.searchController,
// // // // //     // حذف productListSearch لأنها غير مستخدمة
// // // // //   });

// // // // //   final TextEditingController searchController;

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return BlocBuilder<ProductsCubit, ProductsState>(
// // // // //       builder: (context, state) {
// // // // //         if (state is ProductsSuccess) {
// // // // //           final validProducts =
// // // // //               state.products.where((product) {
// // // // //                 return product.imageUrl != null && product.productId.isNotEmpty;
// // // // //               }).toList();

// // // // //           if (validProducts.isEmpty) {
// // // // //             return const Center(child: Text('No products found'));
// // // // //           }

// // // // //           return ProductsGridView(
// // // // //             searchController: searchController,
// // // // //             products: validProducts, // ✅ المنتجات المفلترة فقط
// // // // //           );
// // // // //         } else if (state is ProductsLoading) {
// // // // //           return Skeletonizer(
// // // // //             enabled: true,
// // // // //             child: GridView.count(
// // // // //               crossAxisCount: 2,
// // // // //               shrinkWrap: true,
// // // // //               children: List.generate(
// // // // //                 6,
// // // // //                 (index) => const Card(child: SizedBox(height: 150)),
// // // // //               ),
// // // // //             ),
// // // // //           );
// // // // //         } else {
// // // // //           return const Center(child: Text('No products found'));
// // // // //         }
// // // // //       },
// // // // //     );
// // // // //   }
// // // // // }

// // // // import 'package:flutter/material.dart';
// // // // import 'package:flutter_bloc/flutter_bloc.dart';
// // // // import 'package:grocery_app_dashboard/core/helper/functions/global_methods.dart';
// // // // import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/product_grid_view.dart';
// // // // // import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/product_grid_view.dart';
// // // // import 'package:skeletonizer/skeletonizer.dart';

// // // // import '../../../../../core/cubits/products_cubit/products_cubit.dart';

// // // // class ProductGridViewBlocBuilder extends StatelessWidget {
// // // //   const ProductGridViewBlocBuilder({
// // // //     super.key,
// // // //     required this.searchController,
// // // //     // required this.child,
// // // //   });

// // // //   final TextEditingController searchController;
// // // //   // final Widget child;
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return BlocConsumer<ProductsCubit, ProductsState>(
// // // //       listener: (context, state) {
// // // //         if (state is ProductsFailure) {
// // // //           GlobalMethods.showErrorORWarningDialog(
// // // //             context: context,
// // // //             subtitle: state.errMessage,
// // // //             fct: () {},
// // // //           );
// // // //         }
// // // //       },
// // // //       builder: (context, state) {
// // // //         if (state is ProductsLoading) {
// // // //           return Skeletonizer(
// // // //             enabled: true,
// // // //             child: GridView.count(
// // // //               crossAxisCount: 2,
// // // //               shrinkWrap: true,
// // // //               padding: const EdgeInsets.all(8),
// // // //               children: List.generate(
// // // //                 6,
// // // //                 (index) => const Card(child: SizedBox(height: 150)),
// // // //               ),
// // // //             ),
// // // //           );
// // // //         } else if (state is ProductsSuccess) {
// // // //           final validProducts = state.products
// // // //               .where(
// // // //                 (product) =>
// // // //                     product.imageUrl != null && product.productId.isNotEmpty,
// // // //               )
// // // //               .toList();

// // // //           if (validProducts.isEmpty) {
// // // //             return const Center(child: Text('No products found'));
// // // //           }
// // // //           return ProductGridView(
// // // //             searchController: searchController,
// // // //             products: validProducts,
// // // //           );
// // // //         } else {
// // // //           return const Center(child: Text('No products found'));
// // // //         }
// // // //       },
// // // //     );
// // // //   }
// // // // }

// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_bloc/flutter_bloc.dart';
// // // import 'package:grocery_app_dashboard/core/helper/functions/global_methods.dart';
// // // import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/product_grid_view.dart';
// // // import 'package:skeletonizer/skeletonizer.dart';

// // // import '../../../../../core/cubits/products_cubit/products_cubit.dart';

// // // class ProductGridViewBlocBuilder extends StatelessWidget {
// // //   const ProductGridViewBlocBuilder({super.key, required this.searchController});

// // //   final TextEditingController searchController;

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return BlocConsumer<ProductsCubit, ProductsState>(
// // //       listener: (context, state) {
// // //         if (state is ProductsFailure) {
// // //           GlobalMethods.showErrorORWarningDialog(
// // //             context: context,
// // //             subtitle: state.errMessage,
// // //             fct: () {},
// // //           );
// // //         }
// // //       },
// // //       builder: (context, state) {
// // //         if (state is ProductsLoading) {
// // //           return SliverToBoxAdapter(
// // //             child: Skeletonizer(
// // //               enabled: true,
// // //               child: GridView.count(
// // //                 crossAxisCount: 2,
// // //                 shrinkWrap: true,
// // //                 physics: const NeverScrollableScrollPhysics(),
// // //                 padding: const EdgeInsets.all(8),
// // //                 children: List.generate(
// // //                   6,
// // //                   (index) => const Card(child: SizedBox(height: 150)),
// // //                 ),
// // //               ),
// // //             ),
// // //           );
// // //         } else if (state is ProductsSuccess) {
// // //           final validProducts = state.products
// // //               .where(
// // //                 (product) =>
// // //                     product.imageUrl != null && product.productId.isNotEmpty,
// // //               )
// // //               .toList();

// // //           if (validProducts.isEmpty) {
// // //             return const SliverToBoxAdapter(
// // //               child: Center(child: Text('No products found')),
// // //             );
// // //           }

// // //           return SliverToBoxAdapter(
// // //             child: ProductGridView(
// // //               searchController: searchController,
// // //               products: validProducts,
// // //             ),
// // //           );
// // //         } else {
// // //           return const SliverToBoxAdapter(
// // //             child: Center(child: Text('No products found')),
// // //           );
// // //         }
// // //       },
// // //     );
// // //   }
// // // }

// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:grocery_app_dashboard/core/cubits/products_cubit/products_cubit.dart';
// // import 'product_grid_view.dart';

// // class ProductGridViewBlocBuilder extends StatelessWidget {
// //   const ProductGridViewBlocBuilder({super.key, required this.searchController});

// //   final TextEditingController searchController;

// //   @override
// //   Widget build(BuildContext context) {
// //     return BlocConsumer<ProductsCubit, ProductsState>(
// //       listener: (context, state) {
// //         if (state is ProductsFailure) {
// //           ScaffoldMessenger.of(
// //             context,
// //           ).showSnackBar(SnackBar(content: Text(state.errMessage)));
// //         }
// //       },
// //       builder: (context, state) {
// //         if (state is ProductsLoading) {
// //           return const SliverToBoxAdapter(
// //             child: Center(child: CircularProgressIndicator()),
// //           );
// //         } else if (state is ProductsSuccess) {
// //           final validProducts = state.products
// //               .where(
// //                 (product) =>
// //                     product.imageUrl != null && product.productId.isNotEmpty,
// //               )
// //               .toList();

// //           if (validProducts.isEmpty) {
// //             return const SliverToBoxAdapter(
// //               child: Center(child: Text('No products found')),
// //             );
// //           }

// //           // ✅ رجّع SliverGrid مباشرة
// //           return ProductGridView(
// //             searchController: searchController,
// //             products: validProducts,
// //           );
// //         } else if (state is ProductsFailure) {
// //           return SliverToBoxAdapter(
// //             child: Center(child: Text('Error: ${state.errMessage}')),
// //           );
// //         }

// //         return const SliverToBoxAdapter(child: SizedBox.shrink());
// //       },
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:grocery_app_dashboard/core/cubits/products_cubit/products_cubit.dart';
// import 'product_grid_view.dart';
// import 'custom_text.dart';
// // import 'titles_text_widget.dart'; // استورد الـ widget الجديد للـ "No results found"

// class ProductGridViewBlocBuilder extends StatelessWidget {
//   const ProductGridViewBlocBuilder({super.key, required this.searchController});

//   final TextEditingController searchController;

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<ProductsCubit, ProductsState>(
//       listener: (context, state) {
//         if (state is ProductsFailure) {
//           ScaffoldMessenger.of(
//             context,
//           ).showSnackBar(SnackBar(content: Text(state.errMessage)));
//         }
//       },
//       builder: (context, state) {
//         if (state is ProductsLoading) {
//           return const SliverToBoxAdapter(
//             child: Center(child: CircularProgressIndicator()),
//           );
//         }

//         if (state is ProductsFailure) {
//           return SliverToBoxAdapter(
//             child: Center(child: Text('Error: ${state.errMessage}')),
//           );
//         }

//         if (state is ProductsSuccess) {
//           // تصفية المنتجات الصالحة
//           final validProducts = state.products
//               .where(
//                 (product) =>
//                     product.imageUrl != null && product.productId.isNotEmpty,
//               )
//               .toList();

//           // حالة البحث الفارغ
//           if (searchController.text.isNotEmpty && validProducts.isEmpty) {
//             return const SliverToBoxAdapter(
//               child: Center(
//                 child: CustomText(text: "No results found", fontSize: 40),
//               ),
//             );
//           }

//           // حالة عدم وجود أي منتجات أصلاً
//           if (validProducts.isEmpty) {
//             return const SliverToBoxAdapter(
//               child: Center(child: Text('No products found')),
//             );
//           }

//           // عرض الـ Grid
//           return ProductGridView(
//             searchController: searchController,
//             products: validProducts,
//           );
//         }

//         // الحالة الافتراضية
//         return const SliverToBoxAdapter(child: SizedBox.shrink());
//       },
//     );
//   }
// }
