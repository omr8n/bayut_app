import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:test_graduation/core/cubits/app_cubit/app_cubit.dart';
import 'package:test_graduation/core/services/connectivity_service.dart';
import 'package:test_graduation/core/cubits/property_cubit/property_cubit.dart';
import 'package:test_graduation/core/repos/media_repo/media_repo.dart';
import 'package:test_graduation/core/repos/media_repo/media_repo_impl.dart';
import 'package:test_graduation/core/repos/property_repo/property_repo.dart';
import 'package:test_graduation/core/repos/property_repo/property_repo_impl.dart';
import 'package:test_graduation/core/services/cloudinary_storage_service.dart';
import 'package:test_graduation/core/services/data_service.dart';
import 'package:test_graduation/core/services/firebase_auth_service.dart';
import 'package:test_graduation/core/services/firestore_service.dart';
import 'package:test_graduation/core/services/storage_service.dart';
import 'package:test_graduation/features/auth/data/repos/auth_repo_impl.dart';
import 'package:test_graduation/features/auth/domain/repos/auth_repo.dart';
import 'package:test_graduation/features/auth/presentation/cubits/signup_cubits/signup_cubit.dart';
import 'package:test_graduation/features/auth/presentation/cubits/signin_cubit/signin_cubit.dart';
import 'package:test_graduation/features/auth/presentation/manager/forget_password_cubit/forget_password_cubit.dart';
import 'package:test_graduation/features/my_properties/data/repos/add_property_repo_impl.dart';
import 'package:test_graduation/features/my_properties/domain/repos/add_property_repo.dart';
import 'package:test_graduation/features/my_properties/presentation/cubit/add_property_cubit.dart';
import 'package:test_graduation/features/my_properties/presentation/manager/my_properties_cubit.dart';
import 'package:test_graduation/features/profile/data/repos/rating_repo_impl.dart';
import 'package:test_graduation/features/profile/domain/repos/rating_repo.dart';
import 'package:test_graduation/features/profile/data/repos/favorites_repo_impl.dart';
import 'package:test_graduation/features/profile/domain/repos/favorites_repo.dart';
import 'package:test_graduation/features/profile/presentation/manager/edit_profile_cubit/edit_profile_cubit.dart';
import 'package:test_graduation/features/profile/presentation/manager/favorites_cubit/favorites_cubit.dart';
import 'package:test_graduation/features/profile/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:test_graduation/features/profile/presentation/manager/rating_cubit/rating_cubit.dart';
import 'package:test_graduation/features/profile/presentation/manager/seller_properties_cubit/seller_properties_cubit.dart';
import 'package:test_graduation/features/search/presentation/manager/search_cubit/search_cubit.dart';

import 'package:test_graduation/features/reports/data/repositories/report_repository_impl.dart';
import 'package:test_graduation/features/reports/domain/repositories/report_repository.dart';
import 'package:test_graduation/features/reports/domain/use_cases/send_report_use_case.dart';
import 'package:test_graduation/features/reports/presentation/cubit/report_cubit.dart';

import 'package:test_graduation/core/services/notification_service.dart';
import 'package:test_graduation/features/notifications/domain/repos/notification_repository.dart';
import 'package:test_graduation/features/notifications/data/repos/notification_repository_impl.dart';
import 'package:test_graduation/features/notifications/domain/use_cases/get_combined_notifications_use_case.dart';
import 'package:test_graduation/features/notifications/domain/use_cases/send_notification_use_case.dart';
import 'package:test_graduation/features/notifications/presentation/manager/user_notification_cubit.dart';

// Admin Imports
import 'package:test_graduation/features/admin/domain/repos/admin_repo.dart';
import 'package:test_graduation/features/admin/data/repos/admin_repo_impl.dart';
import 'package:test_graduation/features/admin/domain/repos/admin_action_repo.dart';
import 'package:test_graduation/features/admin/data/repos/admin_action_repo_impl.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_cubit.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_action_cubit/admin_action_cubit.dart';

import 'package:test_graduation/features/admin/domain/repos/app_config_repo.dart';
import 'package:test_graduation/features/admin/data/repos/app_config_repo_impl.dart';
import 'package:test_graduation/features/admin/presentation/manager/app_config_cubit/app_config_cubit.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Services
  getIt.registerLazySingleton<AppCubit>(() => AppCubit());
  getIt.registerLazySingleton<ConnectivityService>(
    () => ConnectivityServiceImpl(Connectivity()),
  );
  getIt.registerLazySingleton<StorageService>(() => CloudinaryStorageService());
  getIt.registerLazySingleton<DatabaseService>(() => FireStoreService());
  getIt.registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthService());

  // Repositories
  getIt.registerLazySingleton<MediaRepo>(
    () => MediaRepoImpl(getIt<StorageService>()),
  );
  getIt.registerLazySingleton<AddPropertyRepo>(
    () => AddPropertyRepoImpl(getIt<DatabaseService>()),
  );
  getIt.registerLazySingleton<PropertyRepo>(
    () => PropertyRepoImpl(
      getIt<DatabaseService>(),
      getIt<ConnectivityService>(),
    ),
  );
  getIt.registerLazySingleton<FavoritesRepo>(
    () => FavoritesRepoImpl(getIt<DatabaseService>()),
  );
  getIt.registerLazySingleton<RatingRepo>(
    () => RatingRepoImpl(getIt<DatabaseService>()),
  );
  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(
      databaseService: getIt<DatabaseService>(),
      firebaseAuthService: getIt<FirebaseAuthService>(),
    ),
  );

  // Cubits
  getIt.registerLazySingleton<AddPropertyCubit>(
    () => AddPropertyCubit(
      mediaRepo: getIt<MediaRepo>(),
      addPropertiesRepo: getIt<AddPropertyRepo>(),
    ),
  );
  getIt.registerLazySingleton<PropertyCubit>(
    () => PropertyCubit(getIt<PropertyRepo>(), getIt<ConnectivityService>()),
  );

  // 🔥 تسجيل SearchCubit المستقل
  getIt.registerFactory<SearchCubit>(() => SearchCubit(getIt<PropertyRepo>()));

  getIt.registerFactory<SignupCubit>(
    () => SignupCubit(getIt<AuthRepo>(), getIt<MediaRepo>()),
  );
  getIt.registerFactory<SigninCubit>(() => SigninCubit(getIt<AuthRepo>()));
  getIt.registerLazySingleton<MyPropertiesCubit>(
    () => MyPropertiesCubit(getIt<PropertyRepo>()),
  );
  getIt.registerFactory<SellerPropertiesCubit>(
    () => SellerPropertiesCubit(getIt<PropertyRepo>()),
  );
  getIt.registerFactory<RatingCubit>(() => RatingCubit(getIt<RatingRepo>()));
  getIt.registerLazySingleton<FavoritesCubit>(
    () => FavoritesCubit(getIt<FavoritesRepo>(), getIt<FirebaseAuthService>()),
  );
  getIt.registerFactory<ForgetPasswordCubit>(
    () => ForgetPasswordCubit(getIt<AuthRepo>()),
  );
  getIt.registerLazySingleton<ProfileCubit>(
    () => ProfileCubit(getIt<FirebaseAuthService>(), getIt<DatabaseService>()),
  );
  getIt.registerFactory<EditProfileCubit>(
    () => EditProfileCubit(getIt<AuthRepo>(), getIt<MediaRepo>()),
  );
  getIt.registerLazySingleton<ReportRepository>(
    () => ReportRepositoryImpl(getIt<DatabaseService>()),
  );
  getIt.registerLazySingleton<SendReportUseCase>(
    () => SendReportUseCase(getIt<ReportRepository>()),
  );
  getIt.registerFactory<ReportCubit>(
    () => ReportCubit(getIt<SendReportUseCase>()),
  );

  getIt.registerLazySingleton<AdminRepo>(
    () => AdminRepoImpl(getIt<DatabaseService>()),
  );
  getIt.registerLazySingleton<AdminActionRepo>(
    () => AdminActionRepoImpl(),
  );
  getIt.registerLazySingleton<AppConfigRepo>(
    () => AppConfigRepoImpl(),
  );
  getIt.registerFactory<AdminCubit>(
    () => AdminCubit(
      getIt<AdminRepo>(),
      getIt<AdminActionRepo>(),
      getIt<SendNotificationUseCase>(),
    ),
  );
  getIt.registerFactory<AdminActionCubit>(
    () => AdminActionCubit(getIt<AdminActionRepo>()),
  );
  getIt.registerFactory<AppConfigCubit>(
    () => AppConfigCubit(getIt<AppConfigRepo>()),
  );

  // Notifications
  getIt.registerLazySingleton<NotificationService>(() => NotificationService());
  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(getIt<NotificationService>()),
  );
  getIt.registerLazySingleton<GetCombinedNotificationsUseCase>(
    () => GetCombinedNotificationsUseCase(getIt<NotificationRepository>()),
  );
  getIt.registerLazySingleton<SendNotificationUseCase>(
    () => SendNotificationUseCase(getIt<NotificationRepository>()),
  );
  getIt.registerFactory<UserNotificationCubit>(
    () => UserNotificationCubit(
      getIt<GetCombinedNotificationsUseCase>(),
      getIt<NotificationRepository>(),
    ),
  );
}
