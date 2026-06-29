import 'package:dartz/dartz.dart';
import 'package:test_graduation/core/errors/failures.dart';
import 'package:test_graduation/core/models/app_config_model.dart';

abstract class AppSettingsRepo {
  Future<Either<Failure, AppConfigModel>> getAppSettings();
  Stream<Either<Failure, AppConfigModel>> watchAppSettings();
  Future<Either<Failure, void>> updateAppSettings(AppConfigModel config);
}
