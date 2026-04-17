import 'package:dartz/dartz.dart';
import 'package:test_graduation/core/errors/failures.dart';
import 'package:test_graduation/core/models/admin_action_model.dart';

abstract class AdminActionRepo {
  Future<Either<Failure, void>> logAction(AdminActionModel action);
  Future<Either<Failure, List<AdminActionModel>>> getActions();
}
