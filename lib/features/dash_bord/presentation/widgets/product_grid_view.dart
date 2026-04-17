// // // // import 'package:flutter/material.dart';

// // // // import 'products_widget.dart';

// // // // class ProductGridWidget extends StatelessWidget {
// // // //   const ProductGridWidget({
// // // //     super.key,
// // // //     this.crossAxisCount = 4,
// // // //     this.childAspectRatio = 1,
// // // //     this.isInMain = true,
// // // //   });
// // // //   final int crossAxisCount;
// // // //   final double childAspectRatio;
// // // //   final bool isInMain;
// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     //final Color color = Utils(context).color;
// // // //     return StreamBuilder<QuerySnapshot>(
// // // //       //there was a null error just add those lines
// // // //       stream: FirebaseFirestore.instance.collection('products').snapshots(),

// // // //       builder: (context, snapshot) {
// // // //         if (snapshot.connectionState == ConnectionState.waiting) {
// // // //           return const Center(child: CircularProgressIndicator());
// // // //         } else if (snapshot.connectionState == ConnectionState.active) {
// // // //           if (snapshot.data == null) {
// // // //             return const Center(
// // // //               child: Padding(
// // // //                 padding: EdgeInsets.all(18.0),
// // // //                 child: Text('Your store is empty'),
// // // //               ),
// // // //             );
// // // //           } else if (snapshot.hasError) {
// // // //             return const Center(
// // // //               child: Text(
// // // //                 'Something went wrong',
// // // //                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
// // // //               ),
// // // //             );
// // // //           }
// // // //         }
// // // //         return GridView.builder(
// // // //           physics: const NeverScrollableScrollPhysics(),
// // // //           shrinkWrap: true,
// // // //           itemCount: isInMain && snapshot.data!.docs.length > 4
// // // //               ? 4
// // // //               : snapshot.data!.docs.length,
// // // //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// // // //             crossAxisCount: crossAxisCount,
// // // //             childAspectRatio: childAspectRatio,
// // // //             // crossAxisSpacing: defaultPadding,
// // // //             // mainAxisSpacing: defaultPadding,
// // // //           ),
// // // //           itemBuilder: (context, index) {
// // // //             return ProductWidget(id: snapshot.data!.docs[index]['id']);
// // // //           },
// // // //         );
// // // //       },
// // // //     );
// // // //   }
// // // // }

// // // import 'package:flutter/material.dart';

// // // import 'products_item.dart';

// // // class ProductGridView extends StatelessWidget {
// // //   const ProductGridView({super.key});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return SizedBox(
// // //       height: MediaQuery.of(context).size.width * 0.32,
// // //       child: SliverGrid(
// // //         delegate: SliverChildBuilderDelegate(
// // //           (context, index) => const ProductItem(),
// // //           childCount: 10,
// // //         ),
// // //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// // //           crossAxisCount: 2,
// // //           mainAxisSpacing: 10,
// // //           crossAxisSpacing: 10,
// // //           childAspectRatio: 0.8,
// // //         ),
// // //       ),
// // //     );
// // //     // child: GridView.builder(
// // //     //   physics: const NeverScrollableScrollPhysics(),
// // //     //   // shrinkWrap: true,
// // //     //   itemCount: 12,
// // //     //   // itemCount: isInMain && snapshot.data!.docs.length > 4
// // //     //   //     ? 4
// // //     //   //     : snapshot.data!.docs.length,
// // //     //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// // //     //     crossAxisCount: 4,
// // //     //     mainAxisSpacing: 4,
// // //     //     // crossAxisSpacing: defaultPadding,
// // //     //     // mainAxisSpacing: defaultPadding,
// // //     //   ),
// // //     //   itemBuilder: (context, index) {
// // //     //     return ProductItem(
// // //     //       // id: snapshot.data!.docs[index]['id']
// // //     //     );
// // //     //   },
// // //     // ),
// // //     // );
// // //   }
// // // }

// // // import 'package:flutter/material.dart';
// // // import '../../../../core/utils/size_config.dart';
// // // import 'products_item.dart';

// // // class ProductGridView extends StatelessWidget {
// // //   const ProductGridView({super.key});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return SliverGrid(
// // //       delegate: SliverChildBuilderDelegate(
// // //         (context, index) => const ProductItem(),
// // //         childCount: 4,
// // //       ),
// // //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// // //         crossAxisCount: MediaQuery.sizeOf(context).width < SizeConfig.tablet
// // //             ? 2
// // //             : 4, //// عدد الأعمدة
// // //         mainAxisSpacing: MediaQuery.sizeOf(context).width < SizeConfig.tablet
// // //             ? 5
// // //             : 10, //// عدد ا 10,
// // //         crossAxisSpacing: MediaQuery.sizeOf(context).width < SizeConfig.tablet
// // //             ? 5
// // //             : 10, //// عدد ا 10,,
// // //         childAspectRatio: 1, // نسبة العرض للطول
// // //       ),
// // //     );
// // //   }
// // // }

// // import 'package:flutter/material.dart';
// // import 'package:grocery_app_dashboard/core/entites/product_entity.dart';
// // import '../../../../core/utils/size_config.dart';
// // import 'products_item.dart';

// // class ProductGridView extends StatelessWidget {
// //   const ProductGridView({
// //     super.key,
// //     required this.searchController,
// //     required this.products,
// //   });
// //   final TextEditingController searchController;
// //   final List<ProductEntity> products;
// //   @override
// //   Widget build(BuildContext context) {
// //     final double screenWidth = MediaQuery.sizeOf(context).width;
// //     final bool isMobile = screenWidth < SizeConfig.tablet;

// //     return SliverGrid(
// //       delegate: SliverChildBuilderDelegate(
// //         (context, index) => const ProductItem(),
// //         childCount: 4, // لاحقاً بدك تجيبها من Firestore أو قائمة المنتجات
// //       ),
// //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// //         crossAxisCount: isMobile ? 2 : 4, // عدد الأعمدة
// //         mainAxisSpacing: isMobile ? 2 : 10, // المسافات بين الصفوف
// //         crossAxisSpacing: isMobile ? 2 : 10, // المسافات بين الأعمدة
// //         childAspectRatio: 0.9, // نسبة العرض للطول
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:grocery_app_dashboard/core/entites/product_entity.dart';
// import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/products_item.dart';
// // import 'product_item.dart';

// class ProductGridView extends StatelessWidget {
//   const ProductGridView({
//     super.key,
//     required this.searchController,
//     required this.products,
//   });

//   final TextEditingController searchController;
//   final List<ProductEntity> products;

//   @override
//   Widget build(BuildContext context) {
//     final bool isMobile = MediaQuery.of(context).size.width < 600;

//     return SliverGrid(
//       delegate: SliverChildBuilderDelegate((context, index) {
//         return ProductItem(
//           product: products[index],
//           // title: product.name,
//           // productCat: product.category,
//           // imageUrl: product.imageUrl ?? '',
//           // price: product.price.toString(),
//           // salePrice: product.salePrice ?? 0,
//           // isOnSale: product.isOnSale,
//           // isPiece: product.isPiece,
//         );
//       }, childCount: products.length),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: isMobile ? 2 : 4,
//         mainAxisSpacing: isMobile ? 2 : 10,
//         crossAxisSpacing: isMobile ? 2 : 10,
//         childAspectRatio: 0.9,
//       ),
//     );
//   }
// }
