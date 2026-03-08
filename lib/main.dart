import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test_graduation/core/utils/service_locator.dart';
import 'firebase_options.dart';
import 'package:test_graduation/features/root/presentation/views/root_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // تهيئة حقن التبعيات (GetIt) لربط الـ Repos والـ Services والـ Cubits
  setupServiceLocator();

  // تثبيت وضع الشاشة للأعلى فقط
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

      // دعم اللغة العربية والاتجاه من اليمين لليسار (RTL)
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'AE'), // العربية
        Locale('en', 'US'), // الإنجليزية
      ],
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),

        useMaterial3: true,
      ),

      home: const RootView(),
    );
  }
}
