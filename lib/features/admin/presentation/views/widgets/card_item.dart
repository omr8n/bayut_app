// import 'package:flutter/material.dart';
// import 'package:test_graduation/core/utils/colors.dart';

// class CrarItem extends StatelessWidget {
//   const CrarItem({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: AppColors.primaryGradient,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.primary.withOpacity(0.3),
//             blurRadius: 12,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.admin_panel_settings,
//               color: Colors.white,
//               size: 32,
//             ),
//           ),
//           const SizedBox(width: 16),
//           const Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'مرحباً أيها المسؤول',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   'لوحة إدارة بيوت',
//                   style: TextStyle(fontSize: 14, color: Colors.white70),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
