import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_graduation/core/cubits/app_cubit/app_cubit.dart';
import 'package:test_graduation/core/cubits/property_cubit/property_cubit.dart';
import 'package:test_graduation/core/language/app_localizations_setup.dart';
import 'package:test_graduation/core/routing/router_generation_config.dart';
import 'package:test_graduation/core/constants/theme_data.dart';
import 'package:test_graduation/core/services/custom_bloc_observer.dart';
import 'package:test_graduation/core/services/fcm_service.dart';
import 'package:test_graduation/core/services/shared_preferences_singleton.dart';
import 'package:test_graduation/core/services/secure_storage_singleton.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test_graduation/core/utils/service_locator.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_settings_cubit/admin_settings_state.dart';
import 'package:test_graduation/features/my_properties/presentation/cubit/add_property_cubit.dart';
import 'package:test_graduation/features/my_properties/presentation/manager/my_properties_cubit.dart';
import 'package:test_graduation/features/profile/presentation/manager/favorites_cubit/favorites_cubit.dart';
import 'package:test_graduation/features/profile/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:test_graduation/features/notifications/presentation/manager/user_notification_cubit.dart';
import 'package:test_graduation/core/widgets/banned_dialog.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_settings_cubit/admin_settings_cubit.dart';
import 'package:test_graduation/features/root/presentation/manager/navigation_cubit.dart';
import 'package:test_graduation/features/root/presentation/views/widgets/maintenance_guard.dart';
import 'package:test_graduation/features/search/presentation/manager/search_cubit/search_cubit.dart';
import 'firebase_options.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 🔥 تفعيل دعم العمل دون إنترنت مع تحديد سقف للكاش
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: 30 * 1024 * 1024,
  );

  Bloc.observer = CustomBlocObserver();
  await Prefs.init();
  await SecureStorage.init();

  // تهيئة Awesome Notifications
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

  // 🔔 تهيئة خدمة الإشعارات المركزية
  await getIt<FCMService>().init();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const BayutApp());
}

class BayutApp extends StatelessWidget {
  const BayutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<AppCubit>()..getSavedLanguage(),
      child: BlocBuilder<AppCubit, AppState>(
        buildWhen: (previous, current) =>
            current is LanguageChangeState || current is ThemeChangeModeState,
        builder: (context, state) {
          final cubit = context.read<AppCubit>();
          final locale = Locale(cubit.currentLangCode);
          final isDark = cubit.isDark;

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
                BlocProvider<AdminSettingsCubit>(
                  create: (context) =>
                      getIt.get<AdminSettingsCubit>()..getSettings(),
                ),
                BlocProvider<UserNotificationCubit>(
                  create: (context) {
                    final cubit = getIt.get<UserNotificationCubit>();
                    final user = context.read<ProfileCubit>().user;
                    if (user != null) {
                      cubit.getNotifications(user.uId);
                    }
                    return cubit;
                  },
                ),
              ],
              child: MaterialApp.router(
                title: 'بيوت',
                debugShowCheckedModeBanner: false,
                routerConfig: RouterGenerationConfig.goRouter,
                locale: locale,
                supportedLocales: AppLocalizationsSetup.supportedLocales,
                localizationsDelegates:
                    AppLocalizationsSetup.localizationsDelegates,

                localeResolutionCallback:
                    AppLocalizationsSetup.localeResolutionCallback,
                theme: MyThemeData.getThemeData(
                  isDarkMode: isDark,
                  langCode: locale.languageCode,
                ),
                builder: (context, child) {
                  return MaintenanceGuard(
                    child: MultiBlocListener(
                      listeners: [
                        BlocListener<ProfileCubit, ProfileState>(
                          listener: (context, state) {
                            if (state is ProfileUserLoaded) {
                              context
                                  .read<UserNotificationCubit>()
                                  .getNotifications(state.user.uId);
                            }

                            if (state is ProfileUserBanned) {
                              if (SecureStorage.isLoggedIn) {
                                _showBannedDialog(context);
                              }
                            }
                          },
                        ),
                      ],
                      child: child!,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _showBannedDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocBuilder<AdminSettingsCubit, AdminSettingsState>(
          builder: (context, configState) {
            String adminPhone = '';
            if (configState is AdminSettingsLoaded) {
              adminPhone = configState.config.contactPhone;
            }

            return BannedDialog(
              adminPhone: adminPhone,
              onContinueAsGuest: () {
                context.read<ProfileCubit>().logout();
                Navigator.of(dialogContext).pop();
              },
            );
          },
        );
      },
    );
  }
}
