// // // import 'package:flutter/material.dart';
// // // import 'package:flutter_bloc/flutter_bloc.dart';
// // // import 'package:grocery_app_dashboard/core/cubits/orders_cubit/orders_cubit.dart';
// // // import 'package:grocery_app_dashboard/core/cubits/orders_cubit/orders_state.dart';
// // // import 'package:grocery_app_dashboard/core/helper/functions/get_order_dummy_data.dart';
// // // import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/orders_list.dart';
// // // import 'package:skeletonizer/skeletonizer.dart';

// // // class OrdersViewBodyBuilder extends StatefulWidget {
// // //   const OrdersViewBodyBuilder({super.key});

// // //   @override
// // //   State<OrdersViewBodyBuilder> createState() => _OrdersViewBodyBuilderState();
// // // }

// // // class _OrdersViewBodyBuilderState extends State<OrdersViewBodyBuilder> {
// // //   @override
// // //   void initState() {
// // //     context.read<OrdersCubit>().fetchAllOrders();
// // //     super.initState();
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return BlocBuilder<OrdersCubit, OrdersState>(
// // //       builder: (context, state) {
// // //         if (state is AllOrderSuccess) {
// // //           return OrdersList(orders: state.orders);
// // //           //  return OrdersList(orders: state.orders);
// // //           //  return OrdersViewBody(orders: state.orders);
// // //         } else if (state is OrdersError) {
// // //           return Center(child: Text(state.message));
// // //         } else {
// // //           return CircularProgressIndicator();
// // //           //  Skeletonizer(
// // //           //   child: (orders: [getDummyOrder(), getDummyOrder()]),
// // //           // );
// // //         }
// // //       },
// // //     );
// // //   }
// // // }
// // import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:grocery_app_dashboard/core/cubits/orders_cubit/orders_cubit.dart';
// // import 'package:grocery_app_dashboard/core/cubits/orders_cubit/orders_state.dart';
// // import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/orders_list.dart';

// // class OrdersViewBodyBuilder extends StatefulWidget {
// //   const OrdersViewBodyBuilder({super.key});

// //   @override
// //   State<OrdersViewBodyBuilder> createState() => _OrdersViewBodyBuilderState();
// // }

// // class _OrdersViewBodyBuilderState extends State<OrdersViewBodyBuilder> {
// //   @override
// //   void initState() {
// //     super.initState();
// //     context.read<OrdersCubit>().fetchAllOrders();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return BlocBuilder<OrdersCubit, OrdersState>(
// //       builder: (context, state) {
// //         if (state is AllOrderSuccess) {
// //           return OrdersList(orders: state.orders);
// //         } else if (state is OrdersError) {
// //           return Center(child: Text(state.message));
// //         } else {
// //           return const Center(child: CircularProgressIndicator());
// //         }
// //       },
// //     );
// //   }
// // }
// // orders_view_body_builder.dart
// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:grocery_app_dashboard/core/cubits/orders_cubit/orders_cubit.dart';
// import 'package:grocery_app_dashboard/core/cubits/orders_cubit/orders_state.dart';
// import 'package:grocery_app_dashboard/features/dash_bord/presentation/widgets/orders_list.dart';

// class OrdersViewBodyBuilder extends StatefulWidget {
//   const OrdersViewBodyBuilder({super.key});

//   @override
//   State<OrdersViewBodyBuilder> createState() => _OrdersViewBodyBuilderState();
// }

// class _OrdersViewBodyBuilderState extends State<OrdersViewBodyBuilder> {
//   @override
//   void initState() {
//     super.initState();
//     // حماية من disposed قبل fetch
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!mounted) return;
//       context.read<OrdersCubit>().fetchAllOrders();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<OrdersCubit, OrdersState>(
//       builder: (context, state) {
//         if (!mounted) return const SizedBox.shrink(); // حماية إضافية

//         if (state is AllOrderSuccess) {
//           print(
//             "======================================success ${state.runtimeType}",
//           );
//           print(
//             "======================================success ${state.toString()}",
//           );
//           print(
//             "======================================success ${state.orders.length}",
//           );
//           return OrdersList(orders: state.orders);
//         } else if (state is OrdersError) {
//           log('errooorrrrrr${state.message}');
//           return Center(child: Text(state.message));
//         } else {
//           return const Center(child: CircularProgressIndicator());
//         }
//       },
//     );
//   }
// }
