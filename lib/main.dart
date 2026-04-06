import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:test_graduation/core/cubits/property_cubit/property_cubit.dart';
import 'package:test_graduation/core/routing/router_generation_config.dart';
import 'package:test_graduation/core/services/custom_bloc_observer.dart';
import 'package:test_graduation/core/services/shared_preferences_singleton.dart';
import 'package:test_graduation/core/services/secure_storage_singleton.dart'; 
import 'package:test_graduation/core/services/firebase_auth_service.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test_graduation/core/utils/service_locator.dart';
import 'package:test_graduation/features/my_properties/presentation/cubit/add_property_cubit.dart';
import 'package:test_graduation/features/profile/presentation/manager/favorites_cubit/favorites_cubit.dart';
import 'package:test_graduation/features/profile/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:test_graduation/features/root/presentation/views/root_view.dart';
import 'package:test_graduation/features/search/presentation/manager/search_cubit/search_cubit.dart';
import 'firebase_options.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Bloc.observer = CustomBlocObserver();
  await Prefs.init();
  await SecureStorage.init();

  AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'upload_channel',
      channelName: 'عمليات الرفع',
      channelDescription: 'إشعارات تقدم رفع العقارات',
      defaultColor: AppColors.primary,
      ledColor: Colors.white,
      importance: NotificationImportance.High,
      channelShowBadge: false,
      onlyAlertOnce: true,
      locked: true,
    ),
  ]);

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) AwesomeNotifications().requestPermissionToSendNotifications();
  });

  setupServiceLocator();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const BayutApp());
}

class BayutApp extends StatelessWidget {
  const BayutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MultiBlocProvider(
        providers: [
          BlocProvider<NavigationCubit>(create: (context) => NavigationCubit()),
          BlocProvider<AddPropertyCubit>(create: (context) => getIt.get<AddPropertyCubit>()),
          BlocProvider<PropertyCubit>(create: (context) => getIt.get<PropertyCubit>()..fetchProperties()),
          // 🔥 توفير SearchCubit بشكل عالمي لضمان الترابط بين الشاشات ومنع الانهيار
          BlocProvider<SearchCubit>(create: (context) => getIt.get<SearchCubit>()..fetchAllPropertiesForSearch()),
          BlocProvider<FavoritesCubit>(create: (context) => getIt.get<FavoritesCubit>()..getFavorites()),
          BlocProvider<ProfileCubit>(create: (context) => ProfileCubit(getIt.get<FirebaseAuthService>())..getUserInfo()),
        ],
        child: MaterialApp.router(
          title: 'بيوت',
          debugShowCheckedModeBanner: false,
          routerConfig: RouterGenerationConfig.goRouter,
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
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, primary: AppColors.primary, secondary: AppColors.secondary),
            useMaterial3: true,
          ),
        ),
      ),
    );
  }
}
