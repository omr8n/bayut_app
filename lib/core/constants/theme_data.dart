// // import 'package:flutter/material.dart';

// // import '../utils/app_colors.dart';

// // class Styles {
// //   static ThemeData themeData(
// //       {required bool isDarkTheme, required BuildContext context}) {
// //     return ThemeData(
// //       scaffoldBackgroundColor:
// //           //0A1931  // white yellow 0xFFFCF8EC
// //           isDarkTheme ? const Color(0xFF00001a) : const Color(0xFFFFFFFF),
// //       primaryColor: Colors.blue,
// //       //
// //       colorScheme: ThemeData().colorScheme.copyWith(
// //             secondary:
// //                 isDarkTheme ? const Color(0xFF1a1f3c) : const Color(0xFFE8FDFD),
// //             brightness: isDarkTheme ? Brightness.dark : Brightness.light,
// //           ),
// //       //
// //       cardColor:
// // //           isDarkTheme ? const Color(0xFF0a0d2c) : const Color(0xFFF2FDFD),
// // //       //
// // //       canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
// // //       //
// // //       buttonTheme: Theme.of(context).buttonTheme.copyWith(
// // //           colorScheme: isDarkTheme
// // //               ? const ColorScheme.dark()
// // //               : const ColorScheme.light()),
// // //       brightness: isDarkTheme ? Brightness.dark : Brightness.light,
// // // //       appBarTheme: AppBarTheme(
// // // //         iconTheme: IconThemeData(
// // // //           color: isDarkTheme ? Colors.white : Colors.black,
// // // //         ),
// // // //         backgroundColor: isDarkTheme
// // // //             ? AppColors.darkScaffoldColor
// // // //             : AppColors.lightScaffoldColor,
// // // //         elevation: 0,
// // // //         centerTitle: false,
// // // //         titleTextStyle: TextStyle(
// // // //           color: isDarkTheme ? Colors.white : Colors.black,
// // // //         ),
// // // //       ),
// // // //       inputDecorationTheme: InputDecorationTheme(
// // // //         filled: true,
// // // //         contentPadding: const EdgeInsets.all(10),
// // // //         enabledBorder: OutlineInputBorder(
// // // //           borderSide: const BorderSide(
// // // //             width: 1,
// // // //             color: Colors.transparent,
// // // //           ),
// // // //           borderRadius: BorderRadius.circular(8),
// // // //         ),
// // // //         focusedBorder: OutlineInputBorder(
// // // //           borderSide: BorderSide(
// // // //             width: 1,
// // // //             color: isDarkTheme ? Colors.white : Colors.black,
// // // //           ),
// // // //           borderRadius: BorderRadius.circular(8),
// // // //         ),
// // // //         errorBorder: OutlineInputBorder(
// // // //           borderSide: BorderSide(
// // // //             width: 1,
// // // //             color: Theme.of(context).colorScheme.error,
// // // //           ),
// // // //           borderRadius: BorderRadius.circular(8),
// // // //         ),
// // // //         focusedErrorBorder: OutlineInputBorder(
// // // //           borderSide: BorderSide(
// // // //             width: 1,
// // // //             color: Theme.of(context).colorScheme.error,
// // // //           ),
// // // //           borderRadius: BorderRadius.circular(8),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // import 'package:flutter/material.dart';

// // import '../utils/app_colors.dart';

// class Styles {
//   static ThemeData themeData({
//     required bool isDarkTheme,
//     required BuildContext context,
//   }) {
//     return ThemeData(
//       scaffoldBackgroundColor: isDarkTheme
//           ? AppColors.darkScaffoldColor
//           : AppColors.lightScaffoldColor,
//       cardColor:
//           isDarkTheme ? AppColors.lightPrimary : AppColors.lightCardColor,
//       brightness: isDarkTheme ? Brightness.dark : Brightness.light,
//       appBarTheme: AppBarTheme(
//         iconTheme: IconThemeData(
//             color: isDarkTheme ? Colors.white : AppColors.darkScaffoldColor),
//         backgroundColor: isDarkTheme
//             ? AppColors.darkScaffoldColor
//             : AppColors.lightScaffoldColor,
//         elevation: 0,
//         centerTitle: false,
//         titleTextStyle: TextStyle(
//           color: isDarkTheme ? Colors.white : Colors.black,
//         ),
//       ),
//       inputDecorationTheme: InputDecorationTheme(
//         filled: true,
//         contentPadding: const EdgeInsets.all(10),
//         enabledBorder: OutlineInputBorder(
//           borderSide: const BorderSide(
//             width: 1,
//             color: Colors.transparent,
//           ),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(
//             width: 1,
//             color: isDarkTheme ? Colors.white : Colors.black,
//           ),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderSide: BorderSide(
//             width: 1,
//             color: Theme.of(context).colorScheme.error,
//           ),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         focusedErrorBorder: OutlineInputBorder(
//           borderSide: BorderSide(
//             width: 1,
//             color: Theme.of(context).colorScheme.error,
//           ),
//           borderRadius: BorderRadius.circular(8),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import 'package:test_graduation/core/utils/colors.dart';

class MyThemeData {
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppColors.background,
    cardColor: AppColors.cardBackground,
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(color: Colors.black),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      contentPadding: const EdgeInsets.all(10),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 1, color: Colors.transparent),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.red),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1,
          color: Colors.red,
          //   color: Theme.of(context).colorScheme.error,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      //backgroundColor: const Color.fromARGB(255, 184, 101, 101),
      // selectedItemColor: Color(value)
      //  unselectedItemColor:
    ),
  );

  // static final ThemeData darkTheme = ThemeData.dark().copyWith(
  //   scaffoldBackgroundColor: AppColors.darkColor,
  //   cardColor: AppColors.lightPrimary,
  //   brightness: Brightness.dark,
  //   appBarTheme: const AppBarTheme(
  //     iconTheme: IconThemeData(color: Colors.white),
  //     backgroundColor: AppColors.darkScaffoldColor,

  //     elevation: 0,
  //     centerTitle: false,
  //     titleTextStyle: TextStyle(color: Colors.white),
  //   ),
  //   inputDecorationTheme: InputDecorationTheme(
  //     filled: true,
  //     contentPadding: const EdgeInsets.all(10),
  //     enabledBorder: OutlineInputBorder(
  //       borderSide: const BorderSide(width: 1, color: Colors.transparent),
  //       borderRadius: BorderRadius.circular(8),
  //     ),
  //     focusedBorder: OutlineInputBorder(
  //       borderSide: BorderSide(width: 1, color: Colors.white),
  //       borderRadius: BorderRadius.circular(8),
  //     ),
  //     errorBorder: OutlineInputBorder(
  //       borderSide: BorderSide(width: 1, color: Colors.red),
  //       borderRadius: BorderRadius.circular(8),
  //     ),
  //     focusedErrorBorder: OutlineInputBorder(
  //       borderSide: BorderSide(
  //         width: 1,
  //         color: Colors.red,
  //         // color:
  //         //   color: Theme.of(context).colorScheme.error,
  //       ),
  //       borderRadius: BorderRadius.circular(8),
  //     ),
  //   ),
  //   // bottomNavigationBarTheme: BottomNavigationBarThemeData(
  //   //   backgroundColor: const Color.fromARGB(255, 184, 101, 101),
  //   // ),
  // );
}
