// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:test_graduation/core/utils/colors.dart';
// import 'package:test_graduation/features/my_properties/presentation/cubit/add_property_cubit.dart';
// import 'package:test_graduation/features/my_properties/presentation/cubit/add_property_state.dart';

// class GlobalUploadOverlay extends StatelessWidget {
//   const GlobalUploadOverlay({super.key});
// س
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AddPropertyCubit, AddPropertyState>(
//       builder: (context, state) {
//         if (state is AddPropertyLoading) {
//           return Positioned(
//             top: MediaQuery.of(context).padding.top + 10,
//             left: 20,
//             right: 20,
//             child: Material(
//               elevation: 8,
//               borderRadius: BorderRadius.circular(12),
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: AppColors.primary.withValues(alpha: 0.2),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     const SizedBox(
//                       width: 20,
//                       height: 20,
//                       child: CircularProgressIndicator(strokeWidth: 2),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           const Text(
//                             'جاري رفع العقار...',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 14,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             state.message,
//                             style: const TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }

//         // في حالة النجاح أو الفشل، يمكننا إظهار بار صغير للحظات (اختياري)
//         return const SizedBox.shrink();
//       },
//     );
//   }
// }
