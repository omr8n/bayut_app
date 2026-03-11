import 'package:get_it/get_it.dart';
import 'package:test_graduation/core/cubits/property_cubit/property_cubit.dart';
import 'package:test_graduation/core/repos/media_repo/media_repo.dart';
import 'package:test_graduation/core/repos/media_repo/media_repo_impl.dart';
import 'package:test_graduation/core/repos/products_repo/products_repo.dart';
import 'package:test_graduation/core/repos/products_repo/products_repo_impl.dart';
import 'package:test_graduation/core/services/cloudinary_storage_service.dart';
import 'package:test_graduation/core/services/data_service.dart';
import 'package:test_graduation/core/services/firestore_service.dart';
import 'package:test_graduation/core/services/storage_service.dart';
import 'package:test_graduation/features/my_properties/data/repos/add_property_repo_impl.dart';
import 'package:test_graduation/features/my_properties/domain/repos/add_property_repo.dart';
import 'package:test_graduation/features/my_properties/presentation/cubit/add_property_cubit.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // Services
  getIt.registerLazySingleton<StorageService>(() => CloudinaryStorageService());
  getIt.registerLazySingleton<DatabaseService>(() => FireStoreService());

  // Repositories
  getIt.registerLazySingleton<MediaRepo>(() => MediaRepoImpl(getIt<StorageService>()));
  getIt.registerLazySingleton<AddPropertyRepo>(() => AddPropertyRepoImpl(getIt<DatabaseService>()));
  getIt.registerLazySingleton<ProductsRepo>(() => ProductsRepoImpl(getIt<DatabaseService>()));

  // Cubits
  getIt.registerLazySingleton<AddPropertyCubit>(
    () => AddPropertyCubit(
      mediaRepo: getIt<MediaRepo>(),
      addPropertiesRepo: getIt<AddPropertyRepo>(),
    ),
  );
  getIt.registerFactory<PropertyCubit>(
    () => PropertyCubit(getIt<ProductsRepo>()),
  );
}
