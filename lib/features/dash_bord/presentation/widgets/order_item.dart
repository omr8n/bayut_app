// // // // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:grocery_admin_panel/services/utils.dart';

// // // // // import 'text_widget.dart';

// // // // // class OrdersWidget extends StatefulWidget {
// // // // //   const OrdersWidget(
// // // // //     // required this.price,
// // // // //     //   required this.totalPrice,
// // // // //     //   required this.productId,
// // // // //     //   required this.userId,
// // // // //     //   required this.imageUrl,
// // // // //     //   required this.userName,
// // // // //     //   required this.quantity,
// // // // //     //   required this.orderDate
// // // // //       {Key? key,
// // // // //     })
// // // // //       : super(key: key);
// // // // //   // final double price, totalPrice;
// // // // //   // final String productId, userId, imageUrl, userName;
// // // // //   // final int quantity;
// // // // //   // final Timestamp orderDate;
// // // // //   @override
// // // // //   _OrdersWidgetState createState() => _OrdersWidgetState();
// // // // // }

// // // // // class _OrdersWidgetState extends State<OrdersWidget> {
// // // // //   late String orderDateStr;
// // // // //   @override
// // // // //   void initState() {
// // // // //     var postDate = widget.orderDate.toDate();
// // // // //     orderDateStr = '${postDate.day}/${postDate.month}/${postDate.year}';
// // // // //     super.initState();
// // // // //   }

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     final theme = Utils(context).getTheme;
// // // // //     Color color = theme == true ? Colors.white : Colors.black;
// // // // //     Size size = Utils(context).getScreenSize;

// // // // // return Padding(
// // // // //   padding: const EdgeInsets.all(8.0),
// // // // //   child: Material(
// // // // //     borderRadius: BorderRadius.circular(8.0),
// // // // //     color: Theme.of(context).cardColor.withOpacity(0.4),
// // // // //     child: Padding(
// // // // //       padding: const EdgeInsets.all(0.0),
// // // // //       child: Row(
// // // // //         mainAxisAlignment: MainAxisAlignment.start,
// // // // //         children: [
// // // // //           Flexible(
// // // // //             flex: size.width < 650 ? 3 : 1,
// // // // //             child: Image.network(
// // // // //               widget.imageUrl,

// // // // //               fit: BoxFit.fill,
// // // // //               // height: screenWidth * 0.15,
// // // // //               // width: screenWidth * 0.15,
// // // // //             ),
// // // // //           ),
// // // // //           const SizedBox(
// // // // //             width: 12,
// // // // //           ),
// // // // //           Expanded(
// // // // //             flex: 10,
// // // // //             child: Column(
// // // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // // //               mainAxisAlignment: MainAxisAlignment.start,
// // // // //               children: [
// // // // //                 TextWidget(
// // // // //                   text:
// // // // //                       '${widget.quantity}X For \$${widget.price.toStringAsFixed(2)}',
// // // // //                   color: color,
// // // // //                   textSize: 16,
// // // // //                   isTitle: true,
// // // // //                 ),
// // // // //                 FittedBox(
// // // // //                   child: Row(
// // // // //                     children: [
// // // // //                       TextWidget(
// // // // //                         text: 'By',
// // // // //                         color: Colors.blue,
// // // // //                         textSize: 16,
// // // // //                         isTitle: true,
// // // // //                       ),
// // // // //                     Text('  ${widget.userName}')
// // // // //                     ],
// // // // //                   ),
// // // // //                 ),
// // // // //                 Text(
// // // // //                   orderDateStr,
// // // // //                 )
// // // // //               ],
// // // // //             ),
// // // // //           ),
// // // // //         ],
// // // // //       ),
// // // // //     ),
// // // // //   ),
// // // // // );
// // // // //   }
// // // // // }

// // // // import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/custom_text.dart';

// // // // class OrderItem extends StatelessWidget {
// // // //   const OrderItem({super.key});

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Padding(
// // // //       padding: const EdgeInsets.all(8.0),
// // // //       child: Material(
// // // //         borderRadius: BorderRadius.circular(8.0),
// // // //         color: Theme.of(context).cardColor.withOpacity(0.4),
// // // //         child: Padding(
// // // //           padding: const EdgeInsets.all(0.0),
// // // //           child: Row(
// // // //             mainAxisAlignment: MainAxisAlignment.start,
// // // //             children: [
// // // //               Flexible(
// // // //                 flex: 2,
// // // //                 child: ConstrainedBox(
// // // //                   constraints: const BoxConstraints(maxWidth: 200),
// // // //                   child: AspectRatio(
// // // //                     aspectRatio: 1,
// // // //                     child: FancyShimmerImage(
// // // //                       imageUrl:
// // // //                           "https://www.rouanews.com/wp-content/uploads/2022/09/DF2D0238-0F79-4D21-9B42-E617C331E394.png",
// // // //                       boxFit: BoxFit.fill,
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //               ),
// // // //               const SizedBox(width: 12),
// // // //               Expanded(
// // // //                 flex: 5,
// // // //                 child: Column(
// // // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // // //                   mainAxisAlignment: MainAxisAlignment.center,
// // // //                   children: [
// // // //                     CustomText(
// // // //                       text: 'r\${32}',
// // // //                       //  '${widget.quantity}X For \$${widget.price.toStringAsFixed(2)}',
// // // //                       // color: color,
// // // //                       fontSize: 16,
// // // //                       isTitle: true,
// // // //                     ),
// // // //                     FittedBox(
// // // //                       child: Row(
// // // //                         children: [
// // // //                           CustomText(
// // // //                             text: 'By',
// // // //                             color: Colors.blue,
// // // //                             fontSize: 16,
// // // //                             isTitle: true,
// // // //                           ),
// // // //                           // Text('  ${widget}'),
// // // //                           Text("userName"),
// // // //                         ],
// // // //                       ),
// // // //                     ),
// // // //                     Text("orderDateStr"),
// // // //                   ],
// // // //                 ),
// // // //               ),
// // // //             ],
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // // import 'package:cached_network_image/cached_network_image.dart';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:fruits_hub_dashboard/features/orders/domain/entities/data/models/order_entity.dart';

// // // // // import '../../../../../core/enums/order_enum.dart';

// // // // import 'order_action_buttons.dart';

// // // // class OrderItemWidget extends StatelessWidget {
// // // //   final OrderEntity orderModel;

// // // //   const OrderItemWidget({super.key, required this.orderModel});

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return Card(
// // // //       elevation: 4,
// // // //       child: Padding(
// // // //         padding: const EdgeInsets.all(16),
// // // //         child: Column(
// // // //           crossAxisAlignment: CrossAxisAlignment.start,
// // // //           children: [
// // // //             // Total Price
// // // //             Row(
// // // //               children: [
// // // //                 Text(
// // // //                   'Total Price: \$${orderModel.totalPrice.toStringAsFixed(2)}',
// // // //                   style: const TextStyle(
// // // //                     fontWeight: FontWeight.bold,
// // // //                     fontSize: 16,
// // // //                   ),
// // // //                 ),
// // // //                 const Spacer(),
// // // //                 // Order Status
// // // //                 Container(
// // // //                   padding: const EdgeInsets.symmetric(
// // // //                     horizontal: 8,
// // // //                     vertical: 4,
// // // //                   ),
// // // //                   decoration: BoxDecoration(
// // // //                     color:
// // // //                         orderModel.status == OrderStatusEnum.pending
// // // //                             ? Colors.orange
// // // //                             : orderModel.status == OrderStatusEnum.accepted
// // // //                             ? Colors.green
// // // //                             : orderModel.status == OrderStatusEnum.delivered
// // // //                             ? Colors.blue
// // // //                             : Colors.red,
// // // //                     borderRadius: BorderRadius.circular(8),
// // // //                   ),
// // // //                   child: Text(
// // // //                     orderModel.status.name,
// // // //                     style: const TextStyle(fontSize: 14, color: Colors.white),
// // // //                   ),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //             const SizedBox(height: 8),

// // // //             // User ID
// // // //             Text(
// // // //               'User ID: ${orderModel.uId}',
// // // //               style: const TextStyle(fontSize: 14, color: Colors.grey),
// // // //             ),
// // // //             const SizedBox(height: 8),

// // // //             // Shipping Address
// // // //             const Text(
// // // //               'Shipping Address:',
// // // //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
// // // //             ),
// // // //             Text(
// // // //               orderModel.shippingAddressModel.toString(),
// // // //               style: const TextStyle(fontSize: 14),
// // // //             ),
// // // //             const SizedBox(height: 8),

// // // //             // Payment Method
// // // //             Text(
// // // //               'Payment Method: ${orderModel.paymentMethod}',
// // // //               style: const TextStyle(fontSize: 14, color: Colors.grey),
// // // //             ),
// // // //             const SizedBox(height: 16),

// // // //             // Order Products
// // // //             const Text(
// // // //               'Products:',
// // // //               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
// // // //             ),
// // // //             ListView.builder(
// // // //               shrinkWrap: true,
// // // //               physics: const NeverScrollableScrollPhysics(),
// // // //               itemCount: orderModel.orderProducts.length,
// // // //               itemBuilder: (context, index) {
// // // //                 final product = orderModel.orderProducts[index];
// // // //                 return ListTile(
// // // //                   leading: CachedNetworkImage(
// // // //                     imageUrl: product.imageUrl,
// // // //                     placeholder:
// // // //                         (context, url) => const SizedBox(
// // // //                           width: 24,
// // // //                           height: 24,
// // // //                           child: CircularProgressIndicator(),
// // // //                         ),
// // // //                     errorWidget:
// // // //                         (context, url, error) => const Icon(Icons.error),
// // // //                   ),
// // // //                   title: Text(product.name),
// // // //                   subtitle: Text(
// // // //                     'Quantity: ${product.quantity} | Price: \$${product.price.toStringAsFixed(2)}',
// // // //                   ),
// // // //                   trailing: Text(
// // // //                     '\$${(product.price * product.quantity).toStringAsFixed(2)}',
// // // //                     style: const TextStyle(
// // // //                       fontWeight: FontWeight.bold,
// // // //                       color: Colors.green,
// // // //                     ),
// // // //                   ),
// // // //                 );
// // // //               },
// // // //             ),

// // // //             const SizedBox(height: 16),
// // // //             OrderActionButtons(orderEntity: orderModel),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // import 'package:cached_network_image/cached_network_image.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:grocery_app_dashboard/core/entites/enums/order_enum.dart';
// // // import 'package:grocery_app_dashboard/core/entites/order_entity.dart';
// // // import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/custom_text.dart';
// // // import 'order_action_buttons.dart';

// // // class OrderItem extends StatelessWidget {
// // //   final OrderEntity orderEntity;

// // //   const OrderItem({super.key, required this.orderEntity});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Padding(
// // //       padding: const EdgeInsets.all(8.0),
// // //       child: Material(
// // //         borderRadius: BorderRadius.circular(12),
// // //         color: Theme.of(context).cardColor.withOpacity(0.4),
// // //         child: Padding(
// // //           padding: const EdgeInsets.all(12.0),
// // //           child: Column(
// // //             crossAxisAlignment: CrossAxisAlignment.start,
// // //             children: [
// // //               // Row with first product image + summary
// // //               Row(
// // //                 crossAxisAlignment: CrossAxisAlignment.start,
// // //                 children: [
// // //                   // First product image
// // //                   Flexible(
// // //                     flex: 2,
// // //                     child: AspectRatio(
// // //                       aspectRatio: 1,
// // //                       child: CachedNetworkImage(
// // //                         imageUrl: orderEntity.orderProducts.isNotEmpty
// // //                             ? orderEntity.orderProducts[0].imageUrl
// // //                             : '',
// // //                         fit: BoxFit.cover,
// // //                         placeholder: (context, url) =>
// // //                             const Center(child: CircularProgressIndicator()),
// // //                         errorWidget: (context, url, error) =>
// // //                             const Icon(Icons.error),
// // //                       ),
// // //                     ),
// // //                   ),
// // //                   const SizedBox(width: 12),
// // //                   // Order summary
// // //                   Expanded(
// // //                     flex: 5,
// // //                     child: Column(
// // //                       crossAxisAlignment: CrossAxisAlignment.start,
// // //                       children: [
// // //                         // Total Price
// // //                         CustomText(
// // //                           text:
// // //                               'Total: \$${orderEntity.totalPrice.toStringAsFixed(2)}',
// // //                           fontSize: 16,
// // //                           isTitle: true,
// // //                         ),
// // //                         const SizedBox(height: 4),
// // //                         // User Info
// // //                         FittedBox(
// // //                           child: Row(
// // //                             children: [
// // //                               CustomText(
// // //                                 text: 'By ',
// // //                                 color: Colors.blue,
// // //                                 fontSize: 14,
// // //                                 isTitle: true,
// // //                               ),
// // //                               Text(orderEntity.userName),
// // //                             ],
// // //                           ),
// // //                         ),
// // //                         const SizedBox(height: 4),
// // //                         // Order Date
// // //                         Text(
// // //                           orderEntity.orderDate != null
// // //                               ? orderEntity.orderDate!.toString()
// // //                               : '',
// // //                           style: const TextStyle(
// // //                             fontSize: 12,
// // //                             color: Colors.grey,
// // //                           ),
// // //                         ),
// // //                         const SizedBox(height: 8),
// // //                         // Order Status
// // //                         Container(
// // //                           padding: const EdgeInsets.symmetric(
// // //                             horizontal: 8,
// // //                             vertical: 4,
// // //                           ),
// // //                           decoration: BoxDecoration(
// // //                             color: orderEntity.status == OrderStatusEnum.pending
// // //                                 ? Colors.orange
// // //                                 : orderEntity.status == OrderStatusEnum.accepted
// // //                                 ? Colors.green
// // //                                 : orderEntity.status ==
// // //                                       OrderStatusEnum.delivered
// // //                                 ? Colors.blue
// // //                                 : Colors.red,
// // //                             borderRadius: BorderRadius.circular(8),
// // //                           ),
// // //                           child: Text(
// // //                             orderEntity.status.name,
// // //                             style: const TextStyle(
// // //                               fontSize: 12,
// // //                               color: Colors.white,
// // //                             ),
// // //                           ),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //               const SizedBox(height: 12),
// // //               // Shipping Address
// // //               const Text(
// // //                 'Shipping Address:',
// // //                 style: TextStyle(fontWeight: FontWeight.bold),
// // //               ),
// // //               Text(
// // //                 orderEntity.shippingAddressModel.toString(),
// // //                 style: const TextStyle(fontSize: 12),
// // //               ),
// // //               const SizedBox(height: 8),
// // //               // Payment Method
// // //               Text(
// // //                 'Payment: ${orderEntity.paymentMethod}',
// // //                 style: const TextStyle(fontSize: 12, color: Colors.grey),
// // //               ),
// // //               const SizedBox(height: 12),
// // //               // List of Products
// // //               const Text(
// // //                 'Products:',
// // //                 style: TextStyle(fontWeight: FontWeight.bold),
// // //               ),
// // //               ListView.builder(
// // //                 shrinkWrap: true,
// // //                 physics: const NeverScrollableScrollPhysics(),
// // //                 itemCount: orderEntity.orderProducts.length,
// // //                 itemBuilder: (context, index) {
// // //                   final product = orderEntity.orderProducts[index];
// // //                   return Padding(
// // //                     padding: const EdgeInsets.symmetric(vertical: 4),
// // //                     child: Row(
// // //                       children: [
// // //                         // Product Image
// // //                         SizedBox(
// // //                           width: 40,
// // //                           height: 40,
// // //                           child: CachedNetworkImage(
// // //                             imageUrl: product.imageUrl,
// // //                             fit: BoxFit.cover,
// // //                             placeholder: (context, url) =>
// // //                                 const CircularProgressIndicator(strokeWidth: 2),
// // //                             errorWidget: (context, url, error) =>
// // //                                 const Icon(Icons.error, size: 24),
// // //                           ),
// // //                         ),
// // //                         const SizedBox(width: 8),
// // //                         // Product Info
// // //                         Expanded(
// // //                           child: Text(
// // //                             '${product.name} | Qty: ${product.quantity} | \$${product.price.toStringAsFixed(2)}',
// // //                             style: const TextStyle(fontSize: 12),
// // //                           ),
// // //                         ),
// // //                         // Product Total
// // //                         Text(
// // //                           '\$${(product.price * product.quantity).toStringAsFixed(2)}',
// // //                           style: const TextStyle(
// // //                             fontWeight: FontWeight.bold,
// // //                             color: Colors.green,
// // //                             fontSize: 12,
// // //                           ),
// // //                         ),
// // //                       ],
// // //                     ),
// // //                   );
// // //                 },
// // //               ),
// // //               const SizedBox(height: 12),
// // //               // Action Buttons
// // //               OrderActionButtons(orderEntity: orderEntity),
// // //             ],
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }

// // import 'package:cached_network_image/cached_network_image.dart';
// // import 'package:flutter/material.dart';
// // import 'package:grocery_app_dashboard/core/entites/enums/order_enum.dart';
// // import 'package:grocery_app_dashboard/core/entites/order_entity.dart';
// // import 'package:grocery_app_dashboard/core/entites/order_product_entity.dart';
// // import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/custom_text.dart';
// // import 'order_action_buttons.dart';

// // class OrderItem extends StatelessWidget {
// //   const OrderItem({super.key, required this.orderEntity});

// //   final OrderEntity orderEntity;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.all(8.0),
// //       child: Material(
// //         borderRadius: BorderRadius.circular(12),
// //         color: Theme.of(context).cardColor.withOpacity(0.4),
// //         child: Padding(
// //           padding: const EdgeInsets.all(12.0),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Row(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   // Flexible(
// //                   //   flex: 2,
// //                   //   child: AspectRatio(
// //                   //     aspectRatio: 1,
// //                   //     child: CachedNetworkImage(
// //                   //       imageUrl: orderEntity.orderProducts.isNotEmpty
// //                   //           ? orderEntity.orderProducts[0].imageUrl
// //                   //           : '',
// //                   //       fit: BoxFit.cover,
// //                   //       placeholder: (context, url) =>
// //                   //           const Center(child: CircularProgressIndicator()),
// //                   //       errorWidget: (context, url, error) =>
// //                   //           const Icon(Icons.error),
// //                   //     ),
// //                   //   ),
// //                   // ),
// //                   const SizedBox(width: 12),
// //                   Expanded(
// //                     flex: 5,
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         CustomText(
// //                           text:
// //                               'Total: \$${orderEntity.totalPrice.toStringAsFixed(2)}',
// //                           fontSize: 16,
// //                           isTitle: true,
// //                         ),
// //                         const SizedBox(height: 4),
// //                         FittedBox(
// //                           child: Row(
// //                             children: [
// //                               CustomText(
// //                                 text: 'By ',
// //                                 color: Colors.blue,
// //                                 fontSize: 14,
// //                                 isTitle: true,
// //                               ),
// //                               Text(orderEntity.userName!),
// //                             ],
// //                           ),
// //                         ),
// //                         const SizedBox(height: 4),
// //                         Text(
// //                           orderEntity.orderDate?.toString() ?? '',
// //                           style: const TextStyle(
// //                             fontSize: 12,
// //                             color: Colors.grey,
// //                           ),
// //                         ),
// //                         const SizedBox(height: 8),
// //                         Container(
// //                           padding: const EdgeInsets.symmetric(
// //                             horizontal: 8,
// //                             vertical: 4,
// //                           ),
// //                           decoration: BoxDecoration(
// //                             color: orderEntity.status == OrderStatusEnum.pending
// //                                 ? Colors.orange
// //                                 : orderEntity.status == OrderStatusEnum.accepted
// //                                 ? Colors.green
// //                                 : orderEntity.status ==
// //                                       OrderStatusEnum.delivered
// //                                 ? Colors.blue
// //                                 : Colors.red,
// //                             borderRadius: BorderRadius.circular(8),
// //                           ),
// //                           child: Text(
// //                             orderEntity.status.name,
// //                             style: const TextStyle(
// //                               fontSize: 12,
// //                               color: Colors.white,
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               const SizedBox(height: 12),
// //               const Text(
// //                 'Shipping Address:',
// //                 style: TextStyle(fontWeight: FontWeight.bold),
// //               ),
// //               Text(
// //                 orderEntity.shippingAddressModel.toString(),
// //                 style: const TextStyle(fontSize: 12),
// //               ),
// //               const SizedBox(height: 8),
// //               Text(
// //                 'Payment: ${orderEntity.paymentMethod}',
// //                 style: const TextStyle(fontSize: 12, color: Colors.grey),
// //               ),
// //               const SizedBox(height: 12),
// //               const Text(
// //                 'Products:',
// //                 style: TextStyle(fontWeight: FontWeight.bold),
// //               ),
// //               ListView.builder(
// //                 shrinkWrap: true,
// //                 physics: const NeverScrollableScrollPhysics(),
// //                 itemCount: orderEntity.orderProducts.length,
// //                 itemBuilder: (context, index) {
// //                   final OrderProductEntity product =
// //                       orderEntity.orderProducts[index];
// //                   return Padding(
// //                     padding: const EdgeInsets.symmetric(vertical: 4),
// //                     child: Row(
// //                       children: [
// //                         SizedBox(
// //                           width: 40,
// //                           height: 40,
// //                           child: CachedNetworkImage(
// //                             imageUrl: product.imageUrl,
// //                             fit: BoxFit.cover,
// //                             placeholder: (context, url) =>
// //                                 const CircularProgressIndicator(strokeWidth: 2),
// //                             errorWidget: (context, url, error) =>
// //                                 const Icon(Icons.error, size: 24),
// //                           ),
// //                         ),
// //                         const SizedBox(width: 8),
// //                         // Expanded(
// //                         //   child: Text(
// //                         //     '${product.name} | Qty: ${product.quantity} | \$${(product.isOnSale == true ? product.onSale : product.price)?.toStringAsFixed(2)}',
// //                         //     style: const TextStyle(fontSize: 12),
// //                         //   ),
// //                         // ),
// //                         // Text(
// //                         //   '\$${((product.isOnSale == true ? product.onSale : product.price)! * product.quantity).toStringAsFixed(2)}',
// //                         //   style: const TextStyle(
// //                         //     fontWeight: FontWeight.bold,
// //                         //     color: Colors.green,
// //                         //     fontSize: 12,
// //                         //   ),
// //                         // ),
// //                         Expanded(
// //                           child: Text(
// //                             '${product.name} | Qty: ${product.quantity} | \$${(product.isOnSale == true && product.onSale != null ? product.onSale : product.price)!.toStringAsFixed(2)}',
// //                             style: const TextStyle(fontSize: 12),
// //                           ),
// //                         ),
// //                         Text(
// //                           '\$${(((product.isOnSale == true && product.onSale != null) ? product.onSale : product.price)! * product.quantity).toStringAsFixed(2)}',
// //                           style: const TextStyle(
// //                             fontWeight: FontWeight.bold,
// //                             color: Colors.green,
// //                             fontSize: 12,
// //                           ),
// //                         ),

// //                         // Expanded(
// //                         //   child: Text(
// //                         //     '${product.name} | Qty: ${product.quantity} | \$${product.price.toStringAsFixed(2)}',
// //                         //     style: const TextStyle(fontSize: 12),
// //                         //   ),
// //                         // ),
// //                         // Text(
// //                         //   '\$${(product.price * product.quantity).toStringAsFixed(2)}',
// //                         //   style: const TextStyle(
// //                         //     fontWeight: FontWeight.bold,
// //                         //     color: Colors.green,
// //                         //     fontSize: 12,
// //                         //   ),
// //                         // ),
// //                       ],
// //                     ),
// //                   );
// //                 },
// //               ),
// //               const SizedBox(height: 12),
// //               OrderActionButtons(orderEntity: orderEntity),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:grocery_app_dashboard/core/entites/enums/order_enum.dart';
// import 'package:grocery_app_dashboard/core/entites/order_entity.dart';
// import 'package:grocery_app_dashboard/core/entites/order_product_entity.dart';
// import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/custom_text.dart';
// import 'order_action_buttons.dart';

// class OrderItem extends StatefulWidget {
//   const OrderItem({super.key, required this.orderEntity});

//   final OrderEntity orderEntity;

//   @override
//   State<OrderItem> createState() => _OrderItemState();
// }

// class _OrderItemState extends State<OrderItem> {
//   late String orderDateToShow;
//   @override
//   void didChangeDependencies() {
//     //  final OrderModel ordersModel = Provider.of<OrderModel>(context);
//     var orderDate = widget.orderEntity.orderDate!.toDate();
//     orderDateToShow = '${orderDate.day}/${orderDate.month}/${orderDate.year}';
//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Material(
//         borderRadius: BorderRadius.circular(12),
//         color: Theme.of(context).canvasColor,
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // صورة أول منتج
//                   // Flexible(
//                   //   flex: 2,
//                   //   child: AspectRatio(
//                   //     aspectRatio: 1,
//                   //     child: CachedNetworkImage(
//                   //       imageUrl: orderEntity.orderProducts.isNotEmpty
//                   //           ? orderEntity.orderProducts[0].imageUrl
//                   //           : '',
//                   //       fit: BoxFit.cover,
//                   //       placeholder: (context, url) =>
//                   //           const Center(child: CircularProgressIndicator()),
//                   //       errorWidget: (context, url, error) =>
//                   //           const Icon(Icons.error),
//                   //     ),
//                   //   ),
//                   // ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     flex: 5,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CustomText(
//                           text:
//                               'Total: \$${widget.orderEntity.totalPrice.toStringAsFixed(2)}',
//                           fontSize: 16,
//                           isTitle: true,
//                         ),
//                         const SizedBox(height: 4),
//                         FittedBox(
//                           child: Row(
//                             children: [
//                               CustomText(
//                                 text: 'By ',
//                                 color: Colors.blue,
//                                 fontSize: 14,
//                                 isTitle: true,
//                               ),
//                               Text(widget.orderEntity.userName!),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           orderDateToShow,
//                           style: const TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 8,
//                             vertical: 4,
//                           ),
//                           decoration: BoxDecoration(
//                             color:
//                                 widget.orderEntity.status ==
//                                     OrderStatusEnum.pending
//                                 ? Colors.orange
//                                 : widget.orderEntity.status ==
//                                       OrderStatusEnum.accepted
//                                 ? Colors.green
//                                 : widget.orderEntity.status ==
//                                       OrderStatusEnum.delivered
//                                 ? Colors.blue
//                                 : Colors.red,
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Text(
//                             widget.orderEntity.status.name,
//                             style: const TextStyle(
//                               fontSize: 12,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               const Text(
//                 'Shipping Address:',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 widget.orderEntity.shippingAddressModel.toString(),
//                 style: const TextStyle(fontSize: 12),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 'Payment: ${widget.orderEntity.paymentMethod}',
//                 style: const TextStyle(fontSize: 12, color: Colors.grey),
//               ),
//               const SizedBox(height: 12),
//               const Text(
//                 'Products:',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: widget.orderEntity.orderProducts.length,
//                 itemBuilder: (context, index) {
//                   final OrderProductEntity product =
//                       widget.orderEntity.orderProducts[index];
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 4),
//                     child: Row(
//                       children: [
//                         SizedBox(
//                           width: 40,
//                           height: 40,
//                           child: CachedNetworkImage(
//                             imageUrl: product.imageUrl,
//                             fit: BoxFit.cover,
//                             placeholder: (context, url) =>
//                                 const CircularProgressIndicator(strokeWidth: 2),
//                             errorWidget: (context, url, error) =>
//                                 const Icon(Icons.error, size: 24),
//                           ),
//                         ),
//                         const SizedBox(width: 8),

//                         // ✅ عرض السعر مع الخصم إذا موجود
//                         Expanded(
//                           child: Text(
//                             '${product.name} | Qty: ${product.quantity} | \$${(product.isOnSale == true && product.onSale != null ? product.onSale : product.price)!.toStringAsFixed(2)}',
//                             style: const TextStyle(fontSize: 12),
//                           ),
//                         ),

//                         // ✅ المجموع (الكمية * السعر الصحيح)
//                         Text(
//                           '\$${(((product.isOnSale == true && product.onSale != null) ? product.onSale : product.price)! * product.quantity).toStringAsFixed(2)}',
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.green,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 12),
//               OrderActionButtons(orderEntity: widget.orderEntity),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
