// import 'package:get_it/get_it.dart';
// import 'package:test_graduation/core/repos/images_repo/images_repo.dart';
// import 'package:test_graduation/core/repos/images_repo/images_repo_impl.dart';
// import 'package:test_graduation/core/services/cloudinary_storage_service.dart';
// import 'package:test_graduation/core/services/stoarage_service.dart';
// import 'package:test_graduation/features/my_properties/presentation/cubit/add_property_cubit.dart';

// final GetIt getIt = GetIt.instance;

// void setupServiceLocator() {
//   // Services
//   getIt.registerLazySingleton<StoarageService>(
//     () => CloudinaryStorageService(),
//   );

//   // Repositories
//   getIt.registerLazySingleton<ImagesRepo>(
//     () => ImagesRepoImpl(getIt<StoarageService>()),
//   );

//   // Cubits
//   getIt.registerFactory(() => AddPropertyCubit(getIt<ImagesRepo>()));
// }
