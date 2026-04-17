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
          featuredPropertyPrice: 50.0,
          contactEmail: 'support@aqar.com',
          contactPhone: '+9710000000',
          termsOfService: 'شروط الاستخدام...',
          privacyPolicy: 'سياسة الخصوصية...',
          maintenanceMode: false,
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
