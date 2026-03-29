import 'package:get_it/get_it.dart';
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
import 'package:test_graduation/features/my_properties/data/repos/add_property_repo_impl.dart';
import 'package:test_graduation/features/my_properties/domain/repos/add_property_repo.dart';
import 'package:test_graduation/features/my_properties/presentation/cubit/add_property_cubit.dart';
import 'package:test_graduation/features/my_properties/presentation/manager/my_properties_cubit.dart';
import 'package:test_graduation/features/profile/data/repos/rating_repo_impl.dart'; // 🔥
import 'package:test_graduation/features/profile/domain/repos/rating_repo.dart'; // 🔥
import 'package:test_graduation/features/profile/presentation/manager/rating_cubit/rating_cubit.dart'; // 🔥
import 'package:test_graduation/features/profile/presentation/manager/seller_properties_cubit/seller_properties_cubit.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Services
  getIt.registerLazySingleton<StorageService>(() => CloudinaryStorageService());
  getIt.registerLazySingleton<DatabaseService>(() => FireStoreService());
  getIt.registerLazySingleton<FirebaseAuthService>(() => FirebaseAuthService());

  // Repositories
  getIt.registerLazySingleton<MediaRepo>(() => MediaRepoImpl(getIt<StorageService>()));
  getIt.registerLazySingleton<AddPropertyRepo>(() => AddPropertyRepoImpl(getIt<DatabaseService>()));
  getIt.registerLazySingleton<PropertyRepo>(() => PropertyRepoImpl(getIt<DatabaseService>()));
  getIt.registerLazySingleton<RatingRepo>(() => RatingRepoImpl(getIt<DatabaseService>())); // 🔥 سجل التقييم
  getIt.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(databaseService: getIt<DatabaseService>(), firebaseAuthService: getIt<FirebaseAuthService>()));

  // Cubits
  getIt.registerLazySingleton<AddPropertyCubit>(() => AddPropertyCubit(mediaRepo: getIt<MediaRepo>(), addPropertiesRepo: getIt<AddPropertyRepo>()));
  getIt.registerFactory<PropertyCubit>(() => PropertyCubit(getIt<PropertyRepo>()));
  getIt.registerFactory<SignupCubit>(() => SignupCubit(getIt<AuthRepo>(), getIt<MediaRepo>()));
  getIt.registerFactory<SigninCubit>(() => SigninCubit(getIt<AuthRepo>()));
  getIt.registerFactory<MyPropertiesCubit>(() => MyPropertiesCubit(getIt<PropertyRepo>()));
  getIt.registerFactory<SellerPropertiesCubit>(() => SellerPropertiesCubit(getIt<PropertyRepo>()));
  getIt.registerFactory<RatingCubit>(() => RatingCubit(getIt<RatingRepo>())); // 🔥 سجل كيوبيت التقييم
}
