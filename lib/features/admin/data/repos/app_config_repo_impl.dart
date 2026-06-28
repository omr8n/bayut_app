import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:test_graduation/core/errors/failures.dart';
import 'package:test_graduation/core/models/app_config_model.dart';
import 'package:test_graduation/core/utils/backend_endpoint.dart';
import 'package:test_graduation/features/admin/domain/repos/app_config_repo.dart';

class AppConfigRepoImpl implements AppConfigRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _docId = 'settings';

  @override
  Future<Either<Failure, AppConfigModel>> getConfig() async {
    try {
      final doc = await _firestore
          .collection(BackendEndpoint.appConfig)
          .doc(_docId)
          .get();
      
      if (doc.exists) {
        return Right(AppConfigModel.fromJson(doc.data()!));
      } else {
        // Return default config if not exists
        final defaultConfig = AppConfigModel(
          appName: 'Bayut Syria',
          appVersion: '1.0.0',
          contactEmail: 'support@bayut-syria.com',
          contactPhone: '+963000000',
          featuredPropertyPrice: 500.0,
          maxImagesPerProperty: 10,
          allowedCities: ['Damascus', 'Aleppo', 'Homs', 'Latakia', 'Tartus', 'Hama'],
          allowedPropertyTypes: ['Apartment', 'Villa', 'Office', 'Shop', 'Land'],
          requireAdminApproval: false,
          maintenanceMode: false,
          termsOfService: 'Terms of Service...',
          privacyPolicy: 'Privacy Policy...',
        );
        await updateConfig(defaultConfig);
        return Right(defaultConfig);
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateConfig(AppConfigModel config) async {
    try {
      await _firestore
          .collection(BackendEndpoint.appConfig)
          .doc(_docId)
          .set(config.toJson());
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
