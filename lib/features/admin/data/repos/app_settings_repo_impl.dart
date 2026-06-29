import 'package:dartz/dartz.dart';
import 'package:test_graduation/core/errors/failures.dart';
import 'package:test_graduation/core/models/app_config_model.dart';
import 'package:test_graduation/core/services/data_service.dart';
import 'package:test_graduation/core/utils/backend_endpoint.dart';
import 'package:test_graduation/features/admin/domain/repos/app_settings_repo.dart';

class AppSettingsRepoImpl implements AppSettingsRepo {
  final DatabaseService _databaseService;
  static const String _configDocId = 'main_config';

  AppSettingsRepoImpl(this._databaseService);

  @override
  Future<Either<Failure, AppConfigModel>> getAppSettings() async {
    try {
      final data = await _databaseService.getData(
        path: BackendEndpoint.appConfig,
        documentId: _configDocId,
      );
      if (data == null) {
        // Return default if not exists
        final defaultConfig = AppConfigModel.fromJson({});
        return Right(defaultConfig);
      }
      return Right(AppConfigModel.fromJson(data));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, AppConfigModel>> watchAppSettings() {
    return _databaseService
        .streamDocument(
          path: BackendEndpoint.appConfig,
          documentId: _configDocId,
        )
        .map<Either<Failure, AppConfigModel>>((data) {
      if (data == null) {
        return Right(AppConfigModel.fromJson({}));
      }
      return Right(AppConfigModel.fromJson(data));
    }).handleError((e) {
      return Left(ServerFailure(e.toString()));
    });
  }

  @override
  Future<Either<Failure, void>> updateAppSettings(AppConfigModel config) async {
    try {
      await _databaseService.setData(
        collectionPath: BackendEndpoint.appConfig,
        documentId: _configDocId,
        data: config.toJson(),
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
