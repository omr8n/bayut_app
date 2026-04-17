import 'package:dartz/dartz.dart';
import 'package:test_graduation/core/errors/failures.dart';
import 'package:test_graduation/core/models/app_config_model.dart';

abstract class AppConfigRepo {
  Future<Either<Failure, AppConfigModel>> getConfig();
  Future<Either<Failure, void>> updateConfig(AppConfigModel config);
}
