// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:grocery_app_dashboard/core/cubits/update_order/update_order_cubit.dart';
// import 'package:grocery_app_dashboard/core/helper/functions/global_methods.dart';
// import 'package:grocery_app_dashboard/core/widgets/loading_manager.dart';

// class UpdateOrderBuilder extends StatelessWidget {
//   const UpdateOrderBuilder({super.key, required this.child});
//   final Widget child;
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<UpdateOrderCubit, UpdateOrderState>(
//       listener: (context, state) {
//         if (state is UpdateOrderSuccess) {
//           GlobalMethods.showErrorORWarningDialog(
//             context: context,
//             subtitle: "Order updated successfully",
//             fct: () {},
//           );
//           //      buildBar(context, 'Order updated successfully');
//         }
//         if (state is UpdateOrderFailure) {
//           GlobalMethods.showErrorORWarningDialog(
//             context: context,
//             subtitle: state.errMessage,
//             fct: () {},
//           );
//           // buildBar(context,);
//         }
//       },
//       builder: (context, state) {
//         return LoadingManager(
//           isLoading: state is UpdateOrderLoading,
//           child: child,
//         );
//       },
//     );
//   }
// }
