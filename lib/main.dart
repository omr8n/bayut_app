import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:test_graduation/core/cubits/app_cubit/app_cubit.dart';
import 'package:test_graduation/core/cubits/property_cubit/property_cubit.dart';
import 'package:test_graduation/core/language/app_localizations_setup.dart';
import 'package:test_graduation/core/routing/router_generation_config.dart';
import 'package:test_graduation/core/services/custom_bloc_observer.dart';
import 'package:test_graduation/core/services/shared_preferences_singleton.dart';
import 'package:test_graduation/core/services/secure_storage_singleton.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test_graduation/core/utils/service_locator.dart';
import 'package:test_graduation/features/my_properties/presentation/cubit/add_property_cubit.dart';
import 'package:test_graduation/features/my_properties/presentation/manager/my_properties_cubit.dart';
import 'package:test_graduation/features/profile/presentation/manager/favorites_cubit/favorites_cubit.dart';
import 'package:test_graduation/features/profile/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:test_graduation/features/root/presentation/manager/navigation_cubit.dart';
import 'package:test_graduation/features/search/presentation/manager/search_cubit/search_cubit.dart';
import 'firebase_options.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 🔔 معالج الإشعارات في الخلفية (يجب أن يكون دالة خارج أي كلاس)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // يمكنك هنا معالجة البيانات التي تصل في الخلفية إذا أردت
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // تعيين معالج الخلفية
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  Bloc.observer = CustomBlocObserver();
  await Prefs.init();
  await SecureStorage.init();

  AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelKey: 'general_channel',
      channelName: 'إشعارات عامة',
      channelDescription: 'إشعارات الأخبار والتحديثات من التطبيق',
      defaultColor: AppColors.primary,
      ledColor: Colors.white,
      importance: NotificationImportance.High,
      channelShowBadge: true,
      onlyAlertOnce: false,
    ),
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

  setupServiceLocator();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // 🔔 طلب إذن الإشعارات لـ Firebase (مهم لأندرويد 13+)
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // 🔔 الاشتراك في قناة "الكل" لاستقبال الإشعارات الجماعية
  FirebaseMessaging.instance.subscribeToTopic('all');

  // 🔔 التحقق من إذن Awesome Notifications
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  // 🔔 الاستماع للإشعارات والتطبيق مفتوح (Foreground)
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: DateTime.now().millisecond, // استخدام ID متغير لمنع تداخل الإشعارات
          channelKey: 'general_channel', // استخدام القناة العامة للإشعارات من الأدمن
          title: message.notification!.title,
          body: message.notification!.body,
          notificationLayout: NotificationLayout.Default,
          payload: message.data.map((key, value) => MapEntry(key, value.toString())),
        ),
      );
    }
  });

  log(
    "token   ===================== ==  ${await FirebaseMessaging.instance.getToken()}",
  );
  runApp(
    // DevicePreview(enabled: true, builder: (context) => const BayutApp()),
    const BayutApp(),
  );
}

class BayutApp extends StatelessWidget {
  const BayutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<AppCubit>()..getSavedLanguage(),
      child: BlocBuilder<AppCubit, AppState>(
        buildWhen: (previous, current) => current is LanguageChangeState,
        builder: (context, state) {
          final locale = state is LanguageChangeState
              ? state.locale
              : Locale(getIt.get<AppCubit>().currentLangCode);

          return ScreenUtilInit(
            designSize: const Size(390, 844),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) => MultiBlocProvider(
              providers: [
                BlocProvider<NavigationCubit>(
                  create: (context) => NavigationCubit(),
                ),
                BlocProvider<AddPropertyCubit>(
                  create: (context) => getIt.get<AddPropertyCubit>(),
                ),
                BlocProvider.value(
                  value: getIt.get<PropertyCubit>()..fetchProperties(),
                ),
                BlocProvider<SearchCubit>(
                  create: (context) =>
                      getIt.get<SearchCubit>()..fetchAllPropertiesForSearch(),
                ),
                BlocProvider<FavoritesCubit>(
                  create: (context) =>
                      getIt.get<FavoritesCubit>()..getFavorites(),
                ),
                BlocProvider<MyPropertiesCubit>(
                  create: (context) => getIt.get<MyPropertiesCubit>(),
                ),
                BlocProvider.value(
                  value: getIt.get<ProfileCubit>()..getUserInfo(),
                ),
              ],
              child: MaterialApp.router(
                // locale: DevicePreview.locale(context),
                // builder: DevicePreview.appBuilder,
                title: 'بيوت',
                debugShowCheckedModeBanner: false,
                routerConfig: RouterGenerationConfig.goRouter,
                builder: (context, child) => child!,
                locale: locale,
                supportedLocales: AppLocalizationsSetup.supportedLocales,
                localizationsDelegates:
                    AppLocalizationsSetup.localizationsDelegates,

                localeResolutionCallback:
                    AppLocalizationsSetup.localeResolutionCallback,
                theme: ThemeData(
                  primaryColor: AppColors.primary,
                  scaffoldBackgroundColor: AppColors.background,
                  fontFamily: locale.languageCode == 'ar' ? 'Dubai' : 'Poppins',
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: AppColors.primary,
                    primary: AppColors.primary,
                    secondary: AppColors.secondary,
                  ),
                  useMaterial3: true,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
