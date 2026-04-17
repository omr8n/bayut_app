// // // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';
// // import 'package:grocery_app_dashboard/core/entites/order_entity.dart';

// // // import '../consts/constants.dart';
// // import 'order_item.dart';

// // class OrdersList extends StatelessWidget {
// //   const OrdersList({
// //     super.key,
// //     this.isInDashboard = true,
// //     required this.orders,
// //   });
// //   final bool isInDashboard;
// //   final List<OrderEntity> orders;

// //   @override
// //   Widget build(BuildContext context) {
// //     return
// //     // StreamBuilder<QuerySnapshot>(
// //     //   //there was a null error just add those lines
// //     //   stream: FirebaseFirestore.instance.collection('orders').snapshots(),
// //     //   builder: (context, snapshot) {
// //     //     if (snapshot.connectionState == ConnectionState.waiting) {
// //     //       return const Center(
// //     //         child: CircularProgressIndicator(),
// //     //       );
// //     //     } else if (snapshot.connectionState == ConnectionState.active) {
// //     //       if (snapshot.data!.docs.isNotEmpty) {
// //     //         return
// //     //          Container(
// //     //           padding: const EdgeInsets.all(10),
// //     //           decoration: BoxDecoration(
// //     //             color: Theme.of(context).cardColor,
// //     //             borderRadius: const BorderRadius.all(Radius.circular(10)),
// //     //           ),
// //     //           child:
// //     SliverList.builder(
// //       // physics: const BouncingScrollPhysics(),
// //       // shrinkWrap: true,
// //       itemCount: 21,
// //       //  isInDashboard && snapshot.data!.docs.length > 4
// //       //     ? 4
// //       //     : snapshot.data!.docs.length,
// //       itemBuilder: (ctx, index) {
// //         return OrderItem(orderEntity: orders[index]);
// //       },
// //     );

// //     // } else {
// //     //   return const Center(
// //     //     child: Padding(
// //     //       padding: EdgeInsets.all(18.0),
// //     //       child: Text('Your store is empty'),
// //     //     ),
// //     //   );
// //     // }
// //   }

// //   // return const Center(
// //   //   child: Text(
// //   //     'Something went wrong',
// //   //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
// //   //   ),
// //   // );
// // }

// import 'package:flutter/material.dart';
// import 'package:grocery_app_dashboard/core/entites/order_entity.dart';
// import 'order_item.dart';

// class OrdersList extends StatelessWidget {
//   const OrdersList({
//     super.key,
//     this.isInDashboard = true,
//     required this.orders,
//   });

//   final bool isInDashboard;
//   final List<OrderEntity> orders;

//   @override
//   Widget build(BuildContext context) {
//     if (orders.isEmpty) {
//       return const Center(
//         child: Padding(
//           padding: EdgeInsets.all(18.0),
//           child: Text('No orders available'),
//         ),
//       );
//     }

//     return ListView.builder(
//       reverse: true,
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: orders.length,
//       itemBuilder: (ctx, index) {
//         //  return Text("");
//         return OrderItem(orderEntity: orders[index]);
//       },
//     );
//   }
// }
