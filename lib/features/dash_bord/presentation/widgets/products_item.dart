// // import 'dart:io';

// // import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
// // import 'package:flutter/foundation.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:grocery_app_dashboard/core/cubits/products_cubit/products_cubit.dart';
// // import 'package:grocery_app_dashboard/core/entites/product_entity.dart';
// // import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/custom_text.dart';
// // import 'package:grocery_app_dashboard/features/inner_screens/edit_product.dart';
// // import 'package:image_picker/image_picker.dart';

// // import '../../../../core/utils/size_config.dart';
// // import '../../../../core/utils/utils.dart';

// // class ProductItem extends StatelessWidget {
// //   const ProductItem({
// //     super.key,
// //     required this.product,
// //     // this.title = 'Apple',
// //     // this.productCat = 'Fruits',
// //     // this.imageUrl =
// //     //     'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRqaD8JX-1mk_Qw0ZXd1q-nr5lf3R4bqojBCzu7AzjIv4rhVJuen11Q5b8JbQZc5zlHwsM&usqp=CAU',
// //     // this.price = '5.99',
// //     // this.salePrice = 3.99,
// //     // this.isOnSale = true,
// //     // this.isPiece = false,
// //     // this.onEdit,
// //     // this.onDelete,
// //   });
// //   final ProductEntity product;
// //   // final String title;
// //   // final String productCat;
// //   // final String imageUrl;
// //   // final String price;
// //   // final double salePrice;
// //   // final bool isOnSale;
// //   // final bool isPiece;
// //   // final VoidCallback? onEdit;
// //   // final VoidCallback? onDelete;

// //   @override
// //   Widget build(BuildContext context) {
// //     Size size = Utils(context).getScreenSize;

// //     //  void showEditProductDialog(BuildContext context) {
// //     //     final _formKey = GlobalKey<FormState>();
// //     //   File? _pickedImage;
// //     //   Uint8List? webImage;
// //     //   String? _catValue;
// //     //   int val = 1; // 1: Kg, 2: Piece
// //     //   bool _isOnSale = isOnSale;
// //     //   double _salePrice = salePrice;

// //     //   Future<void> _pickImage() async {
// //     //     if (!kIsWeb) {
// //     //       final ImagePicker _picker = ImagePicker();
// //     //       XFile? image = await _picker.pickImage(source: ImageSource.gallery);
// //     //       if (image != null) {
// //     //         _pickedImage = File(image.path);
// //     //       }
// //     //     } else {
// //     //       final ImagePicker _picker = ImagePicker();
// //     //       XFile? image = await _picker.pickImage(source: ImageSource.gallery);
// //     //       if (image != null) {
// //     //         webImage = await image.readAsBytes();
// //     //       }
// //     //     }
// //     //   }

// //     //   showDialog(
// //     //     context: context,
// //     //     builder: (context) {
// //     //       return AlertDialog(
// //     //         contentPadding: EdgeInsets.zero,
// //     //         content: SingleChildScrollView(
// //     //           child: Container(
// //     //             width: size.width > 650 ? 650 : size.width * 0.9,
// //     //             padding: const EdgeInsets.all(16),
// //     //             child: StatefulBuilder(
// //     //               builder: (context, setState) {
// //     //                 return Form(
// //     //                   key: _formKey,
// //     //                   child: Column(
// //     //                     crossAxisAlignment: CrossAxisAlignment.start,
// //     //                     mainAxisSize: MainAxisSize.min,
// //     //                     children: [
// //     //                       const Text(
// //     //                         'Edit Product',
// //     //                         style: TextStyle(
// //     //                           fontSize: 20,
// //     //                           fontWeight: FontWeight.bold,
// //     //                         ),
// //     //                       ),
// //     //                       const SizedBox(height: 20),

// //     //                       // Title
// //     //                       const Text(
// //     //                         'Product title*',
// //     //                         style: TextStyle(fontWeight: FontWeight.bold),
// //     //                       ),
// //     //                       const SizedBox(height: 10),
// //     //                       TextFormField(
// //     //                         key: const ValueKey('Title'),
// //     //                         validator: (value) {
// //     //                           if (value == null || value.isEmpty) {
// //     //                             return 'Please enter a Title';
// //     //                           }
// //     //                           return null;
// //     //                         },
// //     //                         decoration: const InputDecoration(
// //     //                           border: OutlineInputBorder(),
// //     //                           hintText: 'Enter product title',
// //     //                         ),
// //     //                       ),
// //     //                       const SizedBox(height: 20),

// //     //                       // Price
// //     //                       const Text(
// //     //                         'Price in \$*',
// //     //                         style: TextStyle(fontWeight: FontWeight.bold),
// //     //                       ),
// //     //                       const SizedBox(height: 10),
// //     //                       TextFormField(
// //     //                         key: const ValueKey('Price'),
// //     //                         keyboardType: TextInputType.number,
// //     //                         validator: (value) {
// //     //                           if (value == null || value.isEmpty) {
// //     //                             return 'Price is missed';
// //     //                           }
// //     //                           return null;
// //     //                         },
// //     //                         inputFormatters: [
// //     //                           FilteringTextInputFormatter.allow(
// //     //                             RegExp(r'[0-9.]'),
// //     //                           ),
// //     //                         ],
// //     //                         decoration: const InputDecoration(
// //     //                           border: OutlineInputBorder(),
// //     //                           hintText: 'Enter price',
// //     //                         ),
// //     //                       ),
// //     //                       const SizedBox(height: 20),

// //     //                       // Category
// //     //                       const Text(
// //     //                         'Product category*',
// //     //                         style: TextStyle(fontWeight: FontWeight.bold),
// //     //                       ),
// //     //                       const SizedBox(height: 10),
// //     //                       DropdownButtonFormField<String>(
// //     //                         value: _catValue,
// //     //                         items: const [
// //     //                           DropdownMenuItem(
// //     //                             value: 'Vegetables',
// //     //                             child: Text('Vegetables'),
// //     //                           ),
// //     //                           DropdownMenuItem(
// //     //                             value: 'Fruits',
// //     //                             child: Text('Fruits'),
// //     //                           ),
// //     //                           DropdownMenuItem(
// //     //                             value: 'Grains',
// //     //                             child: Text('Grains'),
// //     //                           ),
// //     //                           DropdownMenuItem(
// //     //                             value: 'Nuts',
// //     //                             child: Text('Nuts'),
// //     //                           ),
// //     //                           DropdownMenuItem(
// //     //                             value: 'Herbs',
// //     //                             child: Text('Herbs'),
// //     //                           ),
// //     //                           DropdownMenuItem(
// //     //                             value: 'Spices',
// //     //                             child: Text('Spices'),
// //     //                           ),
// //     //                         ],
// //     //                         onChanged: (value) =>
// //     //                             setState(() => _catValue = value),
// //     //                         decoration: const InputDecoration(
// //     //                           border: OutlineInputBorder(),
// //     //                         ),
// //     //                       ),
// //     //                       const SizedBox(height: 20),

// //     //                       // Measure Unit
// //     //                       const Text(
// //     //                         'Measure unit*',
// //     //                         style: TextStyle(fontWeight: FontWeight.bold),
// //     //                       ),
// //     //                       Row(
// //     //                         children: [
// //     //                           const Text('Kg'),
// //     //                           Radio<int>(
// //     //                             value: 1,
// //     //                             groupValue: val,
// //     //                             onChanged: (value) =>
// //     //                                 setState(() => val = value!),
// //     //                           ),
// //     //                           const Text('Piece'),
// //     //                           Radio<int>(
// //     //                             value: 2,
// //     //                             groupValue: val,
// //     //                             onChanged: (value) =>
// //     //                                 setState(() => val = value!),
// //     //                           ),
// //     //                         ],
// //     //                       ),
// //     //                       const SizedBox(height: 20),

// //     //                       // Sale
// //     //                       Row(
// //     //                         children: [
// //     //                           Checkbox(
// //     //                             value: _isOnSale,
// //     //                             onChanged: (value) =>
// //     //                                 setState(() => _isOnSale = value!),
// //     //                           ),
// //     //                           const SizedBox(width: 5),
// //     //                           const Text(
// //     //                             'Sale',
// //     //                             style: TextStyle(fontWeight: FontWeight.bold),
// //     //                           ),
// //     //                         ],
// //     //                       ),
// //     //                       if (_isOnSale)
// //     //                         Row(
// //     //                           children: [
// //     //                             const Text('Sale Price: '),
// //     //                             const SizedBox(width: 10),
// //     //                             SizedBox(
// //     //                               width: 100,
// //     //                               child: TextFormField(
// //     //                                 keyboardType: TextInputType.number,
// //     //                                 onChanged: (value) {
// //     //                                   _salePrice =
// //     //                                       double.tryParse(value) ?? 0.0;
// //     //                                 },
// //     //                                 decoration: const InputDecoration(
// //     //                                   border: OutlineInputBorder(),
// //     //                                   hintText: 'Sale price',
// //     //                                 ),
// //     //                               ),
// //     //                             ),
// //     //                           ],
// //     //                         ),
// //     //                       const SizedBox(height: 20),

// //     //                       // Image
// //     //                       const Text(
// //     //                         'Product Image',
// //     //                         style: TextStyle(fontWeight: FontWeight.bold),
// //     //                       ),
// //     //                       const SizedBox(height: 10),
// //     //                       Container(
// //     //                         height: 150,
// //     //                         width: double.infinity,
// //     //                         decoration: BoxDecoration(
// //     //                           borderRadius: BorderRadius.circular(12),
// //     //                           color: Colors.grey[200],
// //     //                         ),
// //     //                         child: _pickedImage != null
// //     //                             ? Image.file(_pickedImage!, fit: BoxFit.cover)
// //     //                             : (webImage != null
// //     //                                   ? Image.memory(
// //     //                                       webImage!,
// //     //                                       fit: BoxFit.cover,
// //     //                                     )
// //     //                                   : const Icon(
// //     //                                       Icons.image,
// //     //                                       size: 50,
// //     //                                       color: Colors.grey,
// //     //                                     )),
// //     //                       ),
// //     //                       const SizedBox(height: 10),
// //     //                       Center(
// //     //                         child: TextButton(
// //     //                           onPressed: () async {
// //     //                             await _pickImage();
// //     //                             setState(() {});
// //     //                           },
// //     //                           child: FittedBox(
// //     //                             fit: BoxFit.scaleDown,
// //     //                             alignment: AlignmentDirectional.centerStart,
// //     //                             child: const Text(
// //     //                               'Update image',
// //     //                               style: TextStyle(color: Colors.blue),
// //     //                             ),
// //     //                           ),
// //     //                         ),
// //     //                       ),
// //     //                       const SizedBox(height: 20),

// //     //                       // Buttons
// //     //                       Row(
// //     //                         mainAxisAlignment: MainAxisAlignment.spaceAround,
// //     //                         children: [
// //     //                           ElevatedButton(
// //     //                             onPressed: () {
// //     //                               Navigator.of(context).pop();
// //     //                             },
// //     //                             style: ElevatedButton.styleFrom(
// //     //                               backgroundColor: Colors.red,
// //     //                             ),
// //     //                             child: const Text('Delete'),
// //     //                           ),
// //     //                           ElevatedButton(
// //     //                             onPressed: () {
// //     //                               if (_formKey.currentState!.validate()) {
// //     //                                 // هنا منطق تحديث المنتج
// //     //                                 Navigator.of(context).pop();
// //     //                               }
// //     //                             },
// //     //                             child: const Text('Update'),
// //     //                           ),
// //     //                         ],
// //     //                       ),
// //     //                     ],
// //     //                   ),
// //     //                 );
// //     //               },
// //     //             ),
// //     //           ),
// //     //         ),
// //     //       );
// //     //     },
// //     //   );
// //     // }

// //     // final color = Utils(context).color;
// //     return Padding(
// //       padding: const EdgeInsets.all(8.0),
// //       child: Material(
// //         borderRadius: BorderRadius.circular(12),
// //         // ignore: deprecated_member_use
// //         color: Theme.of(context).cardColor.withOpacity(0.8),
// //         child: InkWell(
// //           borderRadius: BorderRadius.circular(12),
// //           onTap: () => Navigator.pushNamed(context, EditProductView.routeName),
// //           // onTap: () => MediaQuery.sizeOf(context).width < SizeConfig.tablet
// //           //     ? Navigator.pushNamed(context, EditProductView.routeName)
// //           //     : showEditProductDialog(context),
// //           // Navigator.pushNamed(context, EditProductView.routeName);
// //           // Navigator.of(context).push(
// //           //   MaterialPageRoute(
// //           //     builder: (context) => EditProductScreen(
// //           //       id: widget.id,
// //           //       title: title,
// //           //       price: price,
// //           //       salePrice: salePrice,
// //           //       productCat: productCat,
// //           //       imageUrl: imageUrl == null
// //           //           ? 'https://www.lifepng.com/wp-content/uploads/2020/11/Apricot-Large-Single-png-hd.png'
// //           //           : imageUrl!,
// //           //       isOnSale: isOnSale,
// //           //       isPiece: isPiece,
// //           //     ),
// //           //   ),
// //           // );
// //           //   },
// //           child: Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.start,
// //               crossAxisAlignment: CrossAxisAlignment.start,

// //               children: [
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Flexible(
// //                       flex: 3,
// //                       child: ConstrainedBox(
// //                         constraints: const BoxConstraints(maxWidth: 200),
// //                         child: AspectRatio(
// //                           aspectRatio: 1,
// //                           child: FancyShimmerImage(
// //                             imageUrl: product.imageUrl!,
// //                             //    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTeBBRudwIEnVGy0pCkGfz5tI-6QK-RIbMgDg&s",
// //                             // fit: BoxFit.fill,
// //                             boxFit: BoxFit.fill,
// //                             // width: screenWidth * 0.12,
// //                             height: size.width * 0.12,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                     //const Spacer(),
// //                     PopupMenuButton<int>(
// //                       onSelected: (value) async {
// //                         if (value == 1) {
// //                           Navigator.pushNamed(
// //                             context,
// //                             EditProductView.routeName,
// //                             arguments: product,
// //                           );
// //                         } else if (value == 2) {
// //                           final confirm =
// //                               await showDialog<bool>(
// //                                 context: context,
// //                                 builder: (ctx) => AlertDialog(
// //                                   title: const Text('Confirm delete'),
// //                                   content: const Text(
// //                                     'Are you sure you want to delete this product?',
// //                                   ),
// //                                   actions: [
// //                                     TextButton(
// //                                       onPressed: () =>
// //                                           Navigator.of(ctx).pop(false),
// //                                       child: const Text('No'),
// //                                     ),
// //                                     TextButton(
// //                                       onPressed: () =>
// //                                           Navigator.of(ctx).pop(true),
// //                                       child: const Text('Yes'),
// //                                     ),
// //                                   ],
// //                                 ),
// //                               ) ??
// //                               false;

// //                           if (confirm) {
// //                             final id = product.productId;

// //                             if (id != null && id.isNotEmpty) {
// //                               if (!context.mounted) return;
// //                               await context.read<ProductsCubit>().deleteProduct(
// //                                 id,
// //                               );

// //                               if (!context.mounted) return;

// //                               ScaffoldMessenger.of(context).showSnackBar(
// //                                 const SnackBar(
// //                                   content: Text(
// //                                     '✅ Product deleted successfully',
// //                                   ),
// //                                 ),
// //                               );
// //                             } else {
// //                               if (!context.mounted) return;

// //                               ScaffoldMessenger.of(context).showSnackBar(
// //                                 const SnackBar(
// //                                   content: Text(
// //                                     '❌ Product ID not available. Cannot delete.',
// //                                   ),
// //                                 ),
// //                               );
// //                             }
// //                           }
// //                         }
// //                       },
// //                       itemBuilder: (context) => [
// //                         const PopupMenuItem(value: 1, child: Text('Edit')),
// //                         const PopupMenuItem(
// //                           value: 2,
// //                           child: Text(
// //                             'Delete',
// //                             style: TextStyle(color: Colors.red),
// //                           ),
// //                         ),
// //                       ],
// //                     ),

// //                     // PopupMenuButton<int>(
// //                     //   onSelected: (value) async {
// //                     //     if (value == 1) {
// //                     //       Navigator.pushNamed(
// //                     //         context,
// //                     //         EditProductView.routeName,
// //                     //         arguments: product,
// //                     //       );
// //                     //     } else if (value == 2) {
// //                     //       final confirm =
// //                     //           await showDialog<bool>(
// //                     //             context: context,
// //                     //             builder: (ctx) => AlertDialog(
// //                     //               title: const Text('Confirm delete'),
// //                     //               content: const Text(
// //                     //                 'Are you sure you want to delete this product?',
// //                     //               ),
// //                     //               actions: [
// //                     //                 TextButton(
// //                     //                   onPressed: () =>
// //                     //                       Navigator.of(ctx).pop(false),
// //                     //                   child: const Text('No'),
// //                     //                 ),
// //                     //                 TextButton(
// //                     //                   onPressed: () =>
// //                     //                       Navigator.of(ctx).pop(true),
// //                     //                   child: const Text('Yes'),
// //                     //                 ),
// //                     //               ],
// //                     //             ),
// //                     //           ) ??
// //                     //           false;

// //                     //       if (confirm) {
// //                     //         // تأكد أن product.productId ليس null
// //                     //         final id = product.productId;
// //                     //         if (id != null && id.isNotEmpty) {
// //                     //           await context.read<ProductsCubit>().deleteProduct(
// //                     //             id,
// //                     //           );
// //                     //         } else {
// //                     //           // خطأ: لا يوجد id صالح — أظهر رسالة خطأ للمستخدم أو سجلّها
// //                     //           ScaffoldMessenger.of(context).showSnackBar(
// //                     //             const SnackBar(
// //                     //               content: Text(
// //                     //                 'Product ID not available. Cannot delete.',
// //                     //               ),
// //                     //             ),
// //                     //           );
// //                     //         }
// //                     //       }
// //                     //     }
// //                     //   },
// //                     //   itemBuilder: (context) => [
// //                     //     const PopupMenuItem(value: 1, child: Text('Edit')),
// //                     //     const PopupMenuItem(
// //                     //       value: 2,
// //                     //       child: Text(
// //                     //         'Delete',
// //                     //         style: TextStyle(color: Colors.red),
// //                     //       ),
// //                     //     ),
// //                     //   ],
// //                     // ),

// //                     // PopupMenuButton(
// //                     //   itemBuilder: (context) => [
// //                     //     PopupMenuItem(
// //                     //       onTap: () {},
// //                     //       value: 1,
// //                     //       child: const Text('Edit'),
// //                     //     ),
// //                     //     PopupMenuItem(
// //                     //       onTap: () {},
// //                     //       value: 2,
// //                     //       child: const Text(
// //                     //         'Delete',
// //                     //         style: TextStyle(color: Colors.red),
// //                     //       ),
// //                     //     ),
// //                     //   ],
// //                     // ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 2),
// //                 Flexible(
// //                   flex: 2,
// //                   child: Row(
// //                     children: [
// //                       Flexible(
// //                         child: FittedBox(
// //                           fit: BoxFit.scaleDown,
// //                           alignment: AlignmentDirectional.centerStart,
// //                           child: CustomText(
// //                             //      text: "323",
// //                             text: product.isOnSale!
// //                                 ? '\$${product.salePrice!.toStringAsFixed(2)}'
// //                                 : '\$${product.price}',
// //                             // color: color,
// //                             fontSize: 18,
// //                           ),
// //                         ),
// //                       ),
// //                       const SizedBox(width: 7),

// //                       Visibility(
// //                         visible: product.isOnSale!,
// //                         child: FittedBox(
// //                           fit: BoxFit.scaleDown,
// //                           alignment: AlignmentDirectional.centerStart,
// //                           child: Text(
// //                             '\$$product. price',
// //                             //   "323",
// //                             style: TextStyle(
// //                               decoration: TextDecoration.lineThrough,
// //                               // color: color,
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                       const Spacer(),
// //                       Flexible(
// //                         child: FittedBox(
// //                           fit: BoxFit.scaleDown,
// //                           alignment: AlignmentDirectional.centerStart,
// //                           child: CustomText(
// //                             text: product.isPiece ? 'Piece' : '1Kg',
// //                             fontSize: 14,
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 const SizedBox(height: 2),
// //                 Flexible(
// //                   child: FittedBox(
// //                     fit: BoxFit.scaleDown,
// //                     alignment: AlignmentDirectional.centerStart,
// //                     child: CustomText(
// //                       text: product.name,
// //                       fontSize: 12,
// //                       isTitle: true,
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// // import 'dart:io';

// import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
// // import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:grocery_app_dashboard/core/cubits/products_cubit/products_cubit.dart';
// import 'package:grocery_app_dashboard/core/entites/product_entity.dart';
// import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/custom_text.dart';
// import 'package:grocery_app_dashboard/features/inner_screens/add_product_view.dart';

// // import 'package:image_picker/image_picker.dart';

// // import '../../../../core/utils/size_config.dart';
// import '../../../../core/utils/utils.dart';

// class ProductItem extends StatelessWidget {
//   const ProductItem({super.key, required this.product});
//   final ProductEntity product;

//   @override
//   Widget build(BuildContext context) {
//     Size size = Utils(context).getScreenSize;

//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Material(
//         borderRadius: BorderRadius.circular(12),
//         color: Theme.of(context).cardColor,
//         child: InkWell(
//           focusColor: Theme.of(context).focusColor,
//           onHover: (value) {},
//           borderRadius: BorderRadius.circular(12),
//           // onTap: () => Navigator.pushNamed(
//           //   context,
//           //   AddProductView.routeName,
//           //   arguments: product,
//           // ),
//           onTap: () => Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => Scaffold()),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Flexible(
//                       flex: 3,
//                       child: ConstrainedBox(
//                         constraints: const BoxConstraints(maxWidth: 200),
//                         child: AspectRatio(
//                           aspectRatio: 1,
//                           child: FancyShimmerImage(
//                             imageUrl: product.imageUrl!,
//                             boxFit: BoxFit.fill,
//                             height: size.width * 0.12,
//                           ),
//                         ),
//                       ),
//                     ),
//                     PopupMenuButton<int>(
//                       onSelected: (value) async {
//                         if (value == 1) {
//                           Navigator.pushNamed(
//                             context,
//                             AddProductView.routeName,
//                             arguments: product,
//                           );
//                           // Navigator.pushNamed(
//                           //   context,
//                           //   EditProductView.routeName,
//                           //   arguments: product,
//                           // );
//                         } else if (value == 2) {
//                           final confirm =
//                               await showDialog<bool>(
//                                 context: context,
//                                 builder: (ctx) => AlertDialog(
//                                   title: const Text('Confirm delete'),
//                                   content: const Text(
//                                     'Are you sure you want to delete this product?',
//                                   ),
//                                   actions: [
//                                     TextButton(
//                                       onPressed: () =>
//                                           Navigator.of(ctx).pop(false),
//                                       child: const Text('No'),
//                                     ),
//                                     TextButton(
//                                       onPressed: () =>
//                                           Navigator.of(ctx).pop(true),
//                                       child: const Text('Yes'),
//                                     ),
//                                   ],
//                                 ),
//                               ) ??
//                               false;

//                           if (confirm) {
//                             final id = product.productId;

//                             if (id != null && id.isNotEmpty) {
//                               if (!context.mounted) return;
//                               await context.read<ProductsCubit>().deleteProduct(
//                                 id,
//                               );

//                               if (!context.mounted) return;

//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                   content: Text(
//                                     '✅ Product deleted successfully',
//                                   ),
//                                 ),
//                               );
//                             } else {
//                               if (!context.mounted) return;

//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                   content: Text(
//                                     '❌ Product ID not available. Cannot delete.',
//                                   ),
//                                 ),
//                               );
//                             }
//                           }
//                         }
//                       },
//                       itemBuilder: (context) => [
//                         const PopupMenuItem(value: 1, child: Text('Edit')),
//                         const PopupMenuItem(
//                           value: 2,
//                           child: Text(
//                             'Delete',
//                             style: TextStyle(color: Colors.red),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 2),
//                 Flexible(
//                   flex: 2,
//                   child: Row(
//                     children: [
//                       Flexible(
//                         child: FittedBox(
//                           fit: BoxFit.scaleDown,
//                           alignment: AlignmentDirectional.centerStart,
//                           child: CustomText(
//                             text: product.isOnSale!
//                                 ? '\$${product.salePrice!.toStringAsFixed(2)}'
//                                 : '\$${product.price.toStringAsFixed(2)}',
//                             fontSize: 18,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 7),
//                       Visibility(
//                         visible: product.isOnSale!,
//                         child: FittedBox(
//                           fit: BoxFit.scaleDown,
//                           alignment: AlignmentDirectional.centerStart,
//                           child: Text(
//                             '\$${product.price.toStringAsFixed(2)}',
//                             style: const TextStyle(
//                               decoration: TextDecoration.lineThrough,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const Spacer(),
//                       Flexible(
//                         child: FittedBox(
//                           fit: BoxFit.scaleDown,
//                           alignment: AlignmentDirectional.centerStart,
//                           child: CustomText(
//                             text: product.isPiece ? 'Piece' : '1Kg',
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Flexible(
//                   child: FittedBox(
//                     fit: BoxFit.scaleDown,
//                     alignment: AlignmentDirectional.centerStart,
//                     child: CustomText(
//                       text: product.name,
//                       fontSize: 12,
//                       isTitle: true,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
