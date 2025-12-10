// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:test_graduation/core/utils/colors.dart';
// import 'package:test_graduation/featuers/home/view/home_view.dart';

// void main() {
//   // تثبيت وضع الشاشة للأعلى فقط
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

//   runApp(const BayutApp());
// }

// class BayutApp extends StatelessWidget {
//   const BayutApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'بيوت',
//       debugShowCheckedModeBanner: false,

//       // دعم العربية (RTL)
//       localizationsDelegates: const [
//         // Add localization delegates here if needed
//       ],
//       supportedLocales: const [
//         Locale('ar', 'AE'), // Arabic UAE
//         Locale('en', 'US'), // English
//       ],
//       locale: const Locale('ar', 'AE'),

//       // الثيم
//       theme: ThemeData(
//         primaryColor: AppColors.primary,
//         scaffoldBackgroundColor: AppColors.background,
//         fontFamily: 'Dubai', // يمكنك إضافة خط عربي لاحقاً

//         colorScheme: ColorScheme.fromSeed(
//           seedColor: AppColors.primary,
//           primary: AppColors.primary,
//           secondary: AppColors.secondary,
//         ),

//         appBarTheme: const AppBarTheme(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           iconTheme: IconThemeData(color: AppColors.textPrimary),
//           titleTextStyle: TextStyle(
//             color: AppColors.textPrimary,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//           systemOverlayStyle: SystemUiOverlayStyle.dark,
//         ),

//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: AppColors.primary,
//             foregroundColor: Colors.white,
//             elevation: 2,
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         ),

//         inputDecorationTheme: InputDecorationTheme(
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: AppColors.error),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: AppColors.primary, width: 2),
//           ),
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 14,
//           ),
//         ),

//         useMaterial3: true,
//       ),

//       // الصفحة الرئيسية
//       home: const HomeScreen(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // ⬅️ مهم جداً
import 'package:test_graduation/core/utils/colors.dart';

import 'package:test_graduation/features/root/presentation/views/root_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const BayutApp());
}

class BayutApp extends StatelessWidget {
  const BayutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'بيوت',
      debugShowCheckedModeBanner: false,

      // دعم العربية واللغات الأخرى
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],

      supportedLocales: const [Locale('ar', 'AE'), Locale('en', 'US')],

      locale: const Locale('ar', 'AE'),

      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Dubai',

        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.textPrimary),
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 2,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.error),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),

        useMaterial3: true,
      ),

      home: const RootView(),
    );
  }
}
